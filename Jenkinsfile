pipeline {
    agent any

    environment {
        // Terraform автоматично підхоплює змінні, які починаються з TF_VAR_
        TF_VAR_do_token = credentials('DO_PAT')
        TF_VAR_spaces_access_id = credentials('SPACES_ACCESS_KEY_ID')
        TF_VAR_spaces_secret_key = credentials('SPACES_SECRET_ACCESS_KEY')
        
        // Ці змінні потрібні для бекенду (збереження стану)
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
                    sh 'terraform validate'
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('task1') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }
}
