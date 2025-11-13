pipeline {
    agent any
    environment {
        REGISTRY = "docker.io/vladyslav280/jenkins-lab"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        } 
        stage('Tests') {
            sh 'npm install --silent || true'
            sh 'npm test'
        }
    }
}