pipeline {
    agent any
    environment {
        REGISTRY = "docker.io/vladyslav280/jenkins-lab"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
    }
    stages('Checkout') {
        steps {
            checkout scm
        }
    } 
}