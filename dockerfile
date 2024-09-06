# Use a base image with Gradle and Node.js installed
FROM gradle:7.5.1-jdk11 as builder

# Install Node.js and npm
RUN apt-get update && apt-get install -y nodejs npm

# Set environment variables
ENV NODE_ENV=production

# Set the working directory for the Gradle build
WORKDIR /usr/src/app

# Copy the Gradle build files and the project files
COPY . /usr/src/app/

# Ensure npm is installed in both web and api
RUN gradle npmInstallWeb --no-daemon
RUN gradle npmInstallApi --no-daemon

# Build the web and api using the defined Gradle tasks
RUN gradle npmBuildWeb --no-daemon

# Clean up the build output after the build process
RUN gradle cleanCustom --no-daemon

# Use a lighter image for production
FROM node:18-alpine

# Set the working directory for the final production build
WORKDIR /usr/src/app

# Copy the built assets from the builder image
COPY --from=builder /usr/src/app/web /usr/src/app/web
COPY --from=builder /usr/src/app/api /usr/src/app/api

# Install dependencies with potential conflict resolution
WORKDIR /usr/src/app/api
RUN npm install --only=production --legacy-peer-deps

WORKDIR /usr/src/app/web
RUN npm install --only=production --legacy-peer-deps

# Expose necessary ports
EXPOSE 3000 7000

# Define the startup command for the app (adjust as needed)
CMD ["npm", "start"]
