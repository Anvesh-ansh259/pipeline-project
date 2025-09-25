pipeline {
    agent { label 'agent1' }

    environment {
        GIT_REPO = 'https://github.com/Anvesh-ansh259/pipeline-project.git'
        BRANCH = 'main'
    }
    
    stages {
        stage('Clean Workspace') {
            steps {
                echo 'Cleaning workspace'
                deleteDir()
            }
        }
        stage('Lint') {
            steps {
                echo "Cloning the repo from Gitlab ........."
                git branch: "${BRANCH}",
                    url: "${GIT_REPO}",
                    credentialsId: 'github-cred'
            }
        }
        stage('Build') {
            steps {
                sh 'dos2unix build.sh'
                sh 'chmod +x build.sh'
                sh 'bash build.sh'
            }
        }
    }

    post {
        success {
            echo '✅ Build Success!'
            emailext (
                subject: "✅ Build Success: ${env.JOB_NAME} [#${env.BUILD_NUMBER}]",
                body: """<p>Build succeeded in job <b>${env.JOB_NAME}</b> [#${env.BUILD_NUMBER}]</p>
                         <p>Check console: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: 'anveshvarekar@gmail.com'
            )
        }
        unstable {
            echo '⚠️ Build marked as UNSTABLE!'
            emailext (
                subject: "⚠️ Build Unstable: ${env.JOB_NAME} [#${env.BUILD_NUMBER}]",
                body: """<p>Build became <b>UNSTABLE</b> in job <b>${env.JOB_NAME}</b> [#${env.BUILD_NUMBER}]</p>
                         <p>Check console: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: 'anveshvarekar@gmail.com'
            )
        }
        failure {
            echo '❌ Build failed!'
            emailext (
                subject: "❌ Build Failed: ${env.JOB_NAME} [#${env.BUILD_NUMBER}]",
                body: """<p>Build failed in job <b>${env.JOB_NAME}</b> [#${env.BUILD_NUMBER}]</p>
                         <p>Check console: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                to: 'anveshvarekar@gmail.com'
            )
        }
    }
}
