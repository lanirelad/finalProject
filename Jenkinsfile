pipeline 
{
    agent any

    environment 
    {
        // Define your environment variables here
        AWS_REGION = 'us-east-1' // Change as necessary
        EKS_CLUSTER_NAME = 'flask-eks' // Your EKS cluster name
        KUBECONFIG = '/tmp/kubeconfig' // Location for Kubeconfig
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

        stage('Deploy with Helm') 
        {
            steps 
            {
                script 
                {
                    sh """
                        helm upgrade --install flask-app ./flask-helm-chart --kubeconfig $KUBECONFIG
                    """
                }
            }
        }
    }

}