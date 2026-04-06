pipeline {
    agent any

    environment {
        // Зчитуємо масковані секрети з Jenkins Credentials 
        TF_VAR_do_token = credentials('DO_PAT')
        AWS_ACCESS_KEY_ID = credentials('SPACES_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('SPACES_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('task1') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate & Plan') {
            steps {
                dir('task1') {
                    // Перевірка правильності розгортання без розгортання 
                    sh 'terraform validate'
                    // Якщо plan падає з помилкою, Jenkins автоматично зупиняє конвеєр 
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('task1') {
                    // Реальне розгортання хмарних ресурсів, використовуючи Terraform [cite: 3, 4]
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
