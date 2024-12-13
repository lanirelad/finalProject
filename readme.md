# FinalProject

This project summarizes the learning from the DevOps course, demonstrating some of the tools and practices learned, including:

- **Terraform**
- **Kubernetes**
- **Docker**
- **Ansible**
- **Jenkins**
- **Bash Scripting**
- **Python Programming**

## Table of Contents

1. [Project Aim](#project-aim)
2. [Prerequisites](#prerequisites)
3. [Steps to Run the App](#steps-to-run-the-app)
    1. [Clone the Repository](#clone-the-repository)
    2. [Navigate to the Project Root Folder](#navigate-to-the-project-root-folder)
    3. [Run the Setup Script](#run-the-setup-script)
    4. [Access the Jenkins Instance](#access-the-jenkins-instance)
    5. [Jenkins Setup](#jenkins-setup)
    6. [Create Jenkins Credentials](#create-jenkins-credentials)
    7. [Create and Run the Jenkins Pipeline](#create-and-run-the-jenkins-pipeline)
    8. [SSH to the EC2](#ssh-to-the-ec2)

## Project Aim

The aim of this project is to **build infrastructure using Terraform** that creates an EC2 instance and an EKS cluster. The EC2 instance is configured with **Jenkins and necessary plugins** using an **Ansible playbook and roles**. A **dockerized Flask app** is deployed to the EKS cluster, and a **Jenkins pipeline** from the EC2 instance uses **Helm** to manage the application deployment.

## Prerequisites

Before running the app, ensure you have the following:

- AWS credentials (Access Key ID and Secret Access Key)
- Key .pem file: This is the private key used to securely access your EC2 instances via SSH. You will need it to connect to the EC2 instance where your application is deployed.

## Steps to Run the App

###  Clone the repository:
    ```bash
    git clone https://github.com/lanirelad/finalProject.git
    ```

### Navigate to the project root folder:
    ```bash
    cd finalProject
    ```

### Run the setup script:
    ```bash
    bash provisions/main.sh
    ```

    This script will:
    This script will:
   - Initialize and apply the Terraform configuration to create an EC2 instance and an EKS cluster.
   - Set up the **Ansible inventory** with the EC2 instance details (IP address).
   - Use **Ansible** to configure the EC2 instance by installing **Jenkins**, relevant plugins (e.g., **kubectl**, **aws cli**, **Helm**), and any necessary dependencies.
   - Once the Jenkins server is set up, it will be ready for use.

### Access the Jenkins Instance:
   - Once the script finishes, you'll have an EC2 instance running Jenkins and an EKS cluster created on AWS.
   - The instance IP address is saved in the `importance.txt` file located in the project root folder.
   - Access the Jenkins instance by navigating to:
     ```
     http://<instance-ip>:8080
     ```
   - The initial Jenkins admin password is FINISH THIS

### Jenkins Setup:
   - Quick registration and recommended plugins installation will be prompted when you first access Jenkins.
   - Install the following plugins:
     - **Kubernetes Plugin**
     - **Pipeline: Stage View Plugin**

### Create Jenkins Credentials:
   - In Jenkins, create new credentials of type **Secret text** with the following variables:
     - `AWS_ID` (Your AWS Access Key ID)
     - `AWS_KEY` (Your AWS Secret Access Key)

### Create and Run the Jenkins Pipeline:
   - Create a new pipeline job in Jenkins.
   - Scroll down to the **Pipeline from SCM** section.
   - Set the **SCM** to **Git**, and enter the following details:
     - **Git URL**: `https://github.com/lanirelad/finalProject.git`
     - **Branch**: `main`
     - **Script Path**: `Jenkinsfile` (should be the default)
   - Save and build the pipeline.

### SSH to the EC2

   SSH from vs-code to the EC2 and perform the following steps to see the all the kubernetes instances:
   ```
   ssh -i <dir to pem key> ubuntu@<instance-ip>
   sudo su jenkins
   export KUBECONFIG=/tmp/kubeconfig
   kubectl get all
   ```
   Checkout the external IP of the flask-app, visit the app and start your work!
   ```
   <external-IP>:5056/viewContacts
   ```

