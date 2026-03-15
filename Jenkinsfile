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

	stage('Debug') {
    	    steps {
        	sh 'echo "Branch name is: ${BRANCH_NAME}"'
   	    }
	}

        stage('Push to Dev') {
            when {
	    	anyOf {
                	branch 'dev'
			branch 'origin/dev'
		}
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Jenkins Credentials',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
		    echo "Current branch: ${env.BRANCH_NAME}"
		    echo "Starting push to dev..."
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
	    	anyOf {
                	branch 'main'
			branch 'origin/main'
		}
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Jenkins Credentials',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
		    echo "Current branch: ${env.BRANCH_NAME}"
                    echo "Starting push to dev..."
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
