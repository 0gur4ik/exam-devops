pipeline {
    agent any

    // Параметричне задання вузлів (вимога Завдання 2)
    parameters {
        string(name: 'TARGET_IP', defaultValue: '', description: 'IP-адреса ВМ andrus-node')
    }

    environment {
        TF_VAR_do_token = credentials('DO_PAT')
        TF_VAR_spaces_access_id = credentials('SPACES_ACCESS_KEY_ID')
        TF_VAR_spaces_secret_key = credentials('SPACES_SECRET_ACCESS_KEY')
        AWS_ACCESS_KEY_ID = credentials('SPACES_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('SPACES_SECRET_ACCESS_KEY')
        // Налаштовуємо використання локального ansible.cfg
        ANSIBLE_CONFIG = "${WORKSPACE}/task2/ansible.cfg"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                dir('task1') {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Ansible Check (Dry Run)') {
            when {
                expression { params.TARGET_IP != '' }
            }
            steps {
                dir('task2') {
                    // Перевірка правильності без встановлення (зупинить конвеєр у разі помилки)
                    sshagent(credentials: ['ansible-ssh-key']) {
                        sh 'ansible-playbook -i "${TARGET_IP}," playbook.yml --syntax-check'
                    }
                }
            }
        }

        stage('Ansible Deploy') {
            when {
                expression { params.TARGET_IP != '' }
            }
            steps {
                dir('task2') {
                    // Реальне встановлення компонентів
                    sshagent(credentials: ['ansible-ssh-key']) {
                        sh 'ansible-playbook -i "${TARGET_IP}," playbook.yml'
                    }
                }
            }
        }
        
        // Тепер цей етап знаходиться ТУТ, всередині блоку stages
        stage('Kubernetes Deploy') {
            when {
                expression { params.TARGET_IP != '' }
            }
            steps {
                // Використовуємо наш SSH ключ для доступу
                sshagent(credentials: ['ansible-ssh-key']) {
                    // 1. Копіюємо папку task3 на сервер andrus-node
                    sh 'scp -o StrictHostKeyChecking=no -r task3/ root@${TARGET_IP}:/root/'
                    
                    // 2. Підключаємося по SSH і кажемо kubectl застосувати ці файли
                    sh 'ssh -o StrictHostKeyChecking=no root@${TARGET_IP} "kubectl apply -f /root/task3/"'
                    
                    // 3. Виводимо статус запущених ресурсів для перевірки в логах Jenkins
                    sh 'ssh -o StrictHostKeyChecking=no root@${TARGET_IP} "kubectl get all"'
                }
            }
        }
    } // <-- А ось тут тепер закривається блок stages
}


