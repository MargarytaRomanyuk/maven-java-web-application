pipeline {
    agent {
        label 'linux-agent'
    }
    stages {
        stage('Clone Repository') {
            steps {
                // Git clone вже виконується автоматично у мультибранч пайплайні.
                echo "Repository cloned for branch ${env.BRANCH_NAME}"
            }
        }
        stage('Check Commit Message') {
            when { 
                expression { return env.BRANCH_NAME.startsWith('feature/') }
            }
            steps {
                script {
                    def commitMessage = sh(script: 'git log -1 --pretty=%B', returnStdout: true).trim()
                    def commitTitle = commitMessage.split("\n")[0]
                    def commitBody = commitMessage.split("\n")[1..-1].join("\n")

                    // Регулярний вираз для перевірки коду завдання JIRA в заголовку коміту
                    def jiraPattern = ~/^[A-Z]+-\d+\s.+$/ 

                    if (!commitTitle.matches(jiraPattern)) {
                        error("Commit title does not start with a JIRA ticket code")
                    }

                    // Перевірка довжини заголовка коміту
                    if (commitTitle.length() > 50) {
                        error("Commit title is longer than 50 characters")
                    }

                    // Перевірка довжини кожного рядка тіла коміту
                    commitBody.split("\n").each { line ->
                        if (line.length() > 72) {
                            error("A line in the commit body is longer than 72 characters")
                        }
                    }
                }
            }
        }


        stage('Lint Dockerfiles') {
            steps {
                // За умови, що у вас є інструмент лінтингу Dockerfile, наприклад, hadolint.
                sh 'docker run --rm -i hadolint/hadolint:v2.8.0 < ./Dockerfile'
            }
        }
    }
    post {
        failure {
            echo "Pipeline failed for branch ${env.BRANCH_NAME}"
        }
    }
}
