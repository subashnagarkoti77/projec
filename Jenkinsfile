pipeline {
    agent any

    environment {
        dockerImage = "subashn77/bookmanagement"
        COMPOSE_PROJECT_NAME = "bookmgmt"
    }

    stages {
        stage('Build Image') {
            steps {
                echo "Building image using Docker Compose"
                sh '''
		whoami
                    docker tag ${COMPOSE_PROJECT_NAME}-web:latest $dockerImage:$BUILD_NUMBER
                '''
            }
        }
        stage('Push to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'dockerhubcredentials', url: '']) {
                    sh "docker push $dockerImage:$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy to Development') {
            steps {
                echo "Deploying to Development environment using Docker Compose"
                sh '''
                    docker compose -f docker-compose.yml down || true
                    docker compose -f docker-compose.yml up -d
                '''
            }
        }
        stage('Deploy to production environment') {
            steps { 
                timeout(time: 5, unit: 'MINUTES') {
                input message: 'Approve PRODUCTION Deployment?'
                }
                echo "Deploying to Production environment"
                sh '''
                    docker compose -f docker-compose.yml down || true
                    docker compose -f docker-compose.yml up --build -d
                '''
            }
        }  
    }
}
