pipeline {
    agent { label 'sonarqube-node' }

    environment {
        GIT_REPO = 'https://github.com/Anvesh-ansh259/pipeline-project.git'
        BRANCH = 'main'
    }

    stages {

        stage('Checkout') {
            steps {
                echo '📥 Cloning repository...'
                git branch: "${BRANCH}", url: "${GIT_REPO}"
            }
        }

        stage('Prepare Tools') {
            steps {
                echo '🧰 Installing required tools...'
                sh '''
                    set -e
                    # Update and install Python3/pip3 if missing
                    if ! command -v pip3 &>/dev/null; then
                        sudo yum install -y python3 python3-pip || true
                    fi

                    # Install cmakelint
                    pip3 install --quiet cmakelint

                    # Install dos2unix
                    if ! command -v dos2unix &>/dev/null; then
                        sudo yum install -y dos2unix || true
                    fi

                    # Install cmake
                    if ! command -v cmake &>/dev/null; then
                        sudo yum install -y epel-release || true
                        sudo yum install -y cmake || true
                    fi

                    # Install GCC/G++
                    if ! command -v gcc &>/dev/null; then
                        sudo yum install -y gcc gcc-c++ || true
                    fi
                '''
            }
        }

        stage('Lint') {
            steps {
                echo '🔍 Running lint checks on src/main.c...'
                sh '''
                    mkdir -p reports
                    if [ -f src/main.c ]; then
                        cmakelint src/main.c > reports/lint_report.txt || true
                    else
                        echo "❌ src/main.c not found!"
                        exit 1
                    fi
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'reports/lint_report.txt', fingerprint: true
                    fingerprint 'src/main.c'
                }
            }
        }

        stage('Build') {
            steps {
                echo '⚙️ Running build.sh...'
                sh '''
                    if [ -f build.sh ]; then
                        dos2unix build.sh
                        chmod +x build.sh
                        ./build.sh
                    else
                        echo "❌ build.sh not found!"
                        exit 1
                    fi
                '''
            }
            post {
                always {
                    archiveArtifacts artifacts: 'build/**/*', fingerprint: true, allowEmptyArchive: true
                }
            }
        }
    }

    post {
        always {
            echo '🏁 Pipeline finished.'
        }
        success {
            echo '✅ Build and lint completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs.'
        }
    }
}
