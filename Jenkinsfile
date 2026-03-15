pipeline {
    agent any

    environment {
        DOCKERHUB_USER = "<your-dockerhub-username>"
        DEV_IMAGE = "${DOCKERHUB_USER}/dev"
        PROD_IMAGE = "${DOCKERHUB_USER}/prod"
    }

    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh './build.sh'
            }
        }

        stage('Push to Dev') {
            when {
                branch 'dev'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker tag devops-app:latest $DEV_IMAGE:latest
                        docker push $DEV_IMAGE:latest
                    '''
                }
            }
        }

        stage('Push to Prod') {
            when {
                branch 'master'
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh '''
                        echo $PASS | docker login -u $USER --password-stdin
                        docker tag devops-app:latest $PROD_IMAGE:latest
                        docker push $PROD_IMAGE:latest
                    '''
                }
            }
        }

        stage('Deploy') {
            steps {
                sh './deploy.sh'
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
