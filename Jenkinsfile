pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'SonarQube'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'develop', url: 'https://github.com/Adjagarail/THE_VOD.git'
            }
        }

        stage('Install Backend') {
            steps {
                sh 'docker-compose exec -T php sh -c "cd /var/www/html && composer install"'
            }
        }

        stage('Test Backend') {
            steps {
                sh 'docker-compose exec -T php sh -c "cd /var/www/html && ./vendor/bin/phpunit"'
            }
        }

        stage('Analyse Backend (SonarQube)') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh 'docker-compose exec -T php sh -c "cd /var/www/html && ./vendor/bin/sonar-scanner -Dproject.settings=sonar-project.properties"'
                }
            }
        }

        stage('Install Frontend') {
            steps {
                sh 'cd vod_front && npm install'
            }
        }

        stage('Analyse Frontend (SonarQube)') {
            steps {
                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh 'cd vod_front && npx sonar-scanner -Dproject.settings=sonar-project.properties'
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }

    post {
        always {
            echo 'Analyse complète des deux projets terminée.'
        }
    }
}
