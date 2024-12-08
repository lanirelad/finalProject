pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1' // Change as necessary
        EKS_CLUSTER_NAME = 'flask-eks' // Your EKS cluster name
        KUBECONFIG = '/tmp/kubeconfig' // Location for Kubeconfig
    }

    stages {
        stage('Clone Helm Chart') {
            steps {
                git url: 'https://github.com/lanirelad/finalProject.git', branch: 'main'
            }
        }

        stage('Configure AWS CLI and Kubeconfig') {
            steps {
                script {
                    // Configure AWS CLI using IAM Role or AWS Credentials
                    sh "aws configure set region $AWS_REGION"

                    // Generate kubeconfig file for accessing the EKS cluster
                    sh """
                        aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION --kubeconfig $KUBECONFIG
                    """
                }
            }
        }

        stage('Deploy with Helm') {
            steps {
                script {
                    sh """
                        helm upgrade --install flask-app ./flask-helm-chart --kubeconfig $KUBECONFIG --force
                    """
                }
            }
        }
    }
}