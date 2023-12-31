pipeline {
    agent any
    tools {
        maven 'Maven_3.6.3'
    }
    stages {
      /*  stage("Getting code") {
            steps {
                echo "======== executing stage ========"
                git url: 'https://github.com/Malek-Zaag/TP4-Devops.git', branch: 'main',
                        credentialsId: 'Github-creds'
                sh "ls -ltr"
                sh "java --version"
            }
        }

        stage("Building the application") {
            steps {
                script {
                    echo "======== executing stage ========"
                    sh "mvn clean install -Dmaven.test.skip=true"
                }
            }
        }

        stage("Running Unit tests") {
            steps {
                script {
                    echo "======== executing stage ========"
                    sh "mvn test -Dtest=StudentServiceTest"
                }
            }
        }

        stage("Running Integration tests") {
            steps {
                script {
                    echo "======== executing stage ========"
                    sh "mvn test -Dtest=StudentControllerTest"
                }
            }
        }

        stage("Static Code Analysis") {
            steps {
                echo "======== executing stage ========"
                sh "mvn sonar:sonar -Dsonar.host.url=http://172.23.67.112:9000 -Dsonar.login=3b2d39110fea0aa1052c5f0728042da3bd067691"
            }
        }

        stage("Docker Build image") {
            steps {
                echo "======== executing stage ========"
                sh "docker-compose up --build -d"
            }
        }*/

        stage("Push image to docker hub") {
            steps {
                echo "======== executing stage ========"
               
                sh "docker tag miniprojet-spring-app louaykharouf/miniprojet:tp4v1"
                sh "docker push louaykharouf/miniprojet:tp4v1"
            }
        }

        stage("AKS cluster Provisioning") {
            steps {
                echo "======== executing stage ========"
                dir("Terraform") {
                    sh "pwd"
                    sh "ls"
                    echo "Terraform init"
                    sh "terraform init "
                    echo "Terraform AKS provision "
                    sh "terraform apply --auto-approve --var-file=./terraform.tfvars.json"
                }
            }
        }

        stage("Configure the cluster") {
            steps {
                echo "======== executing stage ========"
                echo "Connect to the cluster "
                sh "az aks get-credentials --resource-group AKS-resource-group --name cluster1-aks "
                echo "installing argocd"
                sh "kubectl create namespace argocd"
                sh "kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml"
                sh "kubectl patch svc argocd-server -n argocd -p '{\"spec\": {\"type\": \"LoadBalancer\"}}'"
            }
        }

        stage("Deploy with argo cd") {
            steps {
                script {
                    echo "======== executing stage ========"
                    echo "login to argo "
                    def password = sh(script: 'argocd admin initial-password -n argocd | head -n 1', returnStdout: true).trim()
                    def argocdServer = sh(script: 'kubectl get svc argocd-server -n argocd -o jsonpath=\'{.status.loadBalancer.ingress[0].ip}\'', returnStdout: true).trim()
                    sh "yes | argocd login ${argocdServer} --username admin --password ${password} --insecure"
                    echo "installing argocd"
                    sh "argocd app create miniprojet --repo https://github.com/Malek-Zaag/TP4-Devops.git --path K8S --dest-server https://kubernetes.default.svc --dest-namespace default"
                    sh "argocd app sync miniprojet"
                    sh "kubectl get pods"
                }
            }
        }
    }

    post {
        success {
            mail bcc: '', body: 'Pipeline build success', cc: '', from: 'zaag.malek@gmail.com', replyTo: '', subject: 'Pipeline build success', to: 'zaag.malek1@gmail.com'
        }
    }
}
