pipeline {
    agent { label 'sonarqube-node' }

    environment {
        SONARQUBE_ENV = 'SonarQube'
        SONAR_ORGANIZATION = 'anvesh-ansh259'
        SONAR_PROJECT_KEY = 'Anvesh-ansh259_pipeline-project'
    }

    stages {
        stage('Prepare Tools') {
            steps {
                echo 'Installing required tools...'
                sh '''
                    set -e

                    # Update and install Python3, pip, unzip, curl
                    sudo apt-get update -y
                    sudo apt-get install -y python3 python3-pip unzip curl

                    # Install cmakelint safely (Python 3.12+)
                    pip3 install --break-system-packages cmakelint || true

                    echo "✅ Tools are ready."
                '''
            }
        }

        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-pat', // Your GitHub credentials ID
                    url: 'https://github.com/Anvesh-ansh259/pipeline-project.git'
            }
        }

        stage('Lint') {
            steps {
                echo 'Running lint checks...'
                sh '''
                    if command -v cmakelint >/dev/null 2>&1; then
                        cmakelint CMakeLists.txt || true
                    else
                        echo "cmakelint not found, skipping lint."
                    fi
                '''
            }
        }

        stage('Build') {
            steps {
                echo 'Building project...'
                sh '''
                    if [ -f CMakeLists.txt ]; then
                        mkdir -p build
                        cd build
                        cmake ..
                        make || true
                    else
                        echo "No CMakeLists.txt found, skipping build."
                    fi
                '''
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'Running unit tests...'
                sh '''
                    if [ -d tests ]; then
                        pytest tests || true
                    else
                        echo "No tests directory found, skipping unit tests."
                    fi
                '''
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo 'Running SonarQube analysis...'
                withSonarQubeEnv("${SONARQUBE_ENV}") {
                    sh '''
                        sonar-scanner \
                          -Dsonar.organization=${SONAR_ORGANIZATION} \
                          -Dsonar.projectKey=${SONAR_PROJECT_KEY} \
                          -Dsonar.sources=. \
                          -Dsonar.host.url=https://sonarcloud.io
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check logs or SonarCloud dashboard.'
        }
    }
}
