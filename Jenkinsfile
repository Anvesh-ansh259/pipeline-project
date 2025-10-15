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

                    # Detect package manager (Ubuntu/Debian vs CentOS)
                    if command -v apt-get &>/dev/null; then
                        echo "Detected Ubuntu/Debian system..."
                        sudo apt-get update -y
                        sudo apt-get install -y python3 python3-pip cmake dos2unix gcc g++ || true
                    elif command -v yum &>/dev/null; then
                        echo "Detected RHEL/CentOS system..."
                        sudo yum install -y python3 python3-pip cmake dos2unix gcc gcc-c++ || true
                    else
                        echo "❌ Unsupported OS - no apt-get or yum found."
                        exit 1
                    fi

                    # Install cmakelint using pip3
                    if command -v pip3 &>/dev/null; then
                        pip3 install --quiet cmakelint || true
                    else
                        echo "❌ pip3 not found even after install."
                        exit 1
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
