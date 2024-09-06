pipeline {
    agent any
    environment {
        // Specify the path to npm if it's not in the system PATH
        NPM_PATH = 'C:\Program Files\nodejs' // Adjust path if needed
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Voo6883/room-booking-system.git'
            }
        }
        stage('Verify NPM') {
            steps {
                script {
                    // Check if npm is installed and available in the environment
                    def npmVersion = sh(script: "${env.NPM_PATH} --version", returnStatus: true)
                    if (npmVersion != 0) {
                        error 'npm is not installed or not found in the specified path.'
                    }
                }
            }
        }
        stage('Build') {
            steps { 
                powershell 'gradle fullBuild'
            }
        }
        stage('Test') {
            steps { 
                powershell 'gradle runAllTests' 
            }
        }
        stage('Deploy') {
            steps { 
                powershell 'docker-compose up' 
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace'
            deleteDir()
        }
        success {
            echo 'Build succeeded!!!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}