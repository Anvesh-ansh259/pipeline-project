pipeline {
    agent any  // Use any available agent

    stages {
        stage('Webhook Test') {
            steps {
                echo "Webhook received! Build triggered successfully."
                echo "Branch: ${env.BRANCH_NAME}"
                echo "Commit: ${env.GIT_COMMIT}"
            }
        }
    }

    post {
        always {
            echo "Test pipeline finished successfully."
        }
    }
}
