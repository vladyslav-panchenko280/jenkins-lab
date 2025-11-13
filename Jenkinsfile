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
            steps {
                sh 'npm install --silent || true'
                sh 'npm test'
            }
        }
        stage('Build docker') {
            steps {
                script {
                    dockerImage = docker.build("${REGISTRY}:${IMAGE_TAG}")
                }
            }
        }
    }
}
