pipeline {
    agent { label 'ubuntu-slave-node' }

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
                    COMPOSE_BAKE=true ||
                    docker compose -f docker-compose.yml build
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
        post {
        always {
            mail to: 'subnag77@gmail.com',
                 subject: "Job '${JOB_NAME}' (#${BUILD_NUMBER}) Status",
                 body: "Visit ${BUILD_URL} to view details."
        }

        success {
            mail to: 'subnag77@gmail.com',
                 subject: "✅ BUILD SUCCESS: ${JOB_NAME} #${BUILD_NUMBER}",
                 body: "Build #${BUILD_NUMBER} succeeded.\nCheck: ${BUILD_URL}"
        }

        failure {
            mail to: 'subnag77@gmail.com',
                 subject: "❌ BUILD FAILED: ${JOB_NAME} #${BUILD_NUMBER}",
                 body: "Build #${BUILD_NUMBER} failed.\nCheck: ${BUILD_URL}"
        }
    }
}
