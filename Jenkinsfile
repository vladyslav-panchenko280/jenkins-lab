pipeline {
    agent any
    environment {
        REGISTRY = "docker.io/vladyslav280/jenkins-lab"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stage('Checkout') {
        steps {
            checkout scm
        }
    } 
}