pipeline 
{
    agent any

    environment 
    {
        AWS_REGION = 'us-east-1'
        EKS_CLUSTER_NAME = 'flask-eks'
        KUBECONFIG = '/tmp/kubeconfig'
    }

    stages 
    {
        stage('Clone Helm Chart') 
        {
            steps 
            {
                git url: 'https://github.com/lanirelad/finalProject.git', branch: 'main'
            }
        }

        stage('Configure AWS CLI and Kubeconfig') 
        {
            steps 
            {
                withCredentials
                ([
                    string(credentialsId: 'AWS_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) 
                {
                    script 
                    {
                        // Configure AWS CLI using the Jenkins credentials
                        sh "aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}"
                        sh "aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}"
                        sh "aws configure set region $AWS_REGION"

                        // Generate kubeconfig file for accessing the EKS cluster
                        sh """
                            aws eks update-kubeconfig --name $EKS_CLUSTER_NAME --region $AWS_REGION --kubeconfig $KUBECONFIG
                        """
                    }
                }
            }
        }

        stage('Deploy with Helm') 
        {
            steps 
            {
                script 
                {
                    sh """
                        helm upgrade --install flask-app ./flask-helm-chart --kubeconfig $KUBECONFIG --force
                    """
                }
            }
        }

        stage('Get Pod IP and Port') 
        {
            steps 
            {
                script 
                {
                    // Get the pod name
                    def podName = sh(script: "kubectl get pods -l app=flask-app -o jsonpath='{.items[0].metadata.name}' --kubeconfig $KUBECONFIG", returnStdout: true).trim()

                    // Get the pod IP
                    def podIP = sh(script: "kubectl get pod $podName -o jsonpath='{.status.podIP}' --kubeconfig $KUBECONFIG", returnStdout: true).trim()

                    // Get the port on which the Flask app is running
                    def podPort = sh(script: "kubectl get pod $podName -o jsonpath='{.spec.containers[0].ports[0].containerPort}' --kubeconfig $KUBECONFIG", returnStdout: true).trim()

                    // Print the Pod IP and Port
                    echo "Flask App is running on Pod IP: $podIP and Port: $podPort"
                }
            }
        }
    }
}