pipeline {
    agent { label 'linuxgit' }

    environment {
        GIT_REPO = 'https://github.com/Anvesh-ansh259/pipeline-project.git'
        BRANCH = 'main'
    }
    
    stages {
        stage('Clean Workspace') {
            steps {
                echo 'Cleaning workspace...'
                deleteDir()
            }
        }
        stage('Checkout') {
            steps {
                echo "Cloning the repo..."
                git branch: "${BRANCH}",
                    url: "${GIT_REPO}"
                // If you need credentials (private repo), add credentialsId
            }
        }
        stage('Build') {
            steps {
                sh 'dos2unix build.sh'
                sh 'chmod +x build.sh'
                sh './build.sh'
            }
        }
    }

    post {
        always {
            // Archive build outputs
            archiveArtifacts artifacts: 'build/*.elf, build/*.bin', fingerprint: true
        }
        unstable {
            echo 'Build marked as UNSTABLE!'
        }
        failure {
            echo 'Build failed!'
        }
    }
}

