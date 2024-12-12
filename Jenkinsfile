pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
        EKS_CLUSTER_NAME = 'flask-eks'
        KUBECONFIG = '/tmp/kubeconfig'
    }

    stages {
        stage('Clone Helm Chart') {
            steps {
                git url: 'https://github.com/lanirelad/finalProject.git', branch: 'main'
            }
        }

        stage('Configure AWS CLI and Kubeconfig') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    withEnv(["AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"]) {
                        sh """
                            aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                            aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                            aws configure set region $AWS_REGION
                        """
                        sh "aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION --kubeconfig $KUBECONFIG"
                    }
                }
            }
        }

        stage('Install Prometheus Operator') {
            steps {
                script {
                    sh """
                        echo "Adding Prometheus Helm repo and updating..."
                        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                        helm repo update

                        # Check if the release already exists, and uninstall if necessary
                        if helm list --namespace monitoring | grep -q prometheus-operator; then
                            echo "Prometheus operator already installed, uninstalling..."
                            helm uninstall prometheus-operator --namespace monitoring --kubeconfig $KUBECONFIG
                        fi

                        echo "Installing Prometheus..."
                        helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --kubeconfig $KUBECONFIG
                    """
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh """
                        # Cleanup existing deployment
                        echo "Uninstalling existing Helm release..."
                        helm uninstall flask-app --kubeconfig $KUBECONFIG || echo "Helm release not found"

                        echo "Deleting ConfigMap..."
                        kubectl delete configmap flask-app-config --kubeconfig $KUBECONFIG --ignore-not-found --force --grace-period=0

                        echo "Deleting resources labeled app=flask-app..."
                        kubectl delete all -l app=flask-app --kubeconfig $KUBECONFIG --ignore-not-found || echo "Resources not found"
                        
                        # Wait to ensure cleanup is complete
                        echo "Waiting for cleanup to complete..."
                        sleep 10

                        # Verify ConfigMap deletion
                        echo "Checking if ConfigMap still exists..."
                        kubectl get configmap flask-app-config --kubeconfig $KUBECONFIG || echo "ConfigMap deleted successfully"

                        # Deploy the application using Helm
                        echo "Deploying the application using Helm..."
                        helm install flask-app ./flask-helm-chart --values ./flask-helm-chart/values.yaml --kubeconfig $KUBECONFIG
                    """
                }
            }
        }

        stage('Get Pod IP and Port') {
            steps {
                script {
                    sh """
                        echo "Fetching service URL for flask-contacts-app-service..."
                        kubectl get service flask-contacts-app-service --kubeconfig $KUBECONFIG
                    """
                }
            }
        }
    }
}