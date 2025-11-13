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
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh '''
                        echo $DOCKERHUB_PASSWORD | docker login -u $DOCKERHUB_USERNAME --password-stdin
                        docker push ${REGISTRY}:${IMAGE_TAG}
                        docker logout
                    '''
                }
            }
        }
    }
}
