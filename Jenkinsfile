pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Voo6883/room-booking-system.git'
            }
        }
        stage('Build') {
            steps { powershell 'gradle fullBuild'}
        }
        stage('Test') {
            steps { powershell 'gradle runAllTests'}
        }
        stage('Deploy') {
            steps { powershell 'docker-compose up'}
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

