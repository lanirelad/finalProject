#!/bin/bash
# A script to initialize all the infrastructure for running the flask app on EKS using jenkins pipeline, helm, and terraform

set -e  # Ensure the script fails on any errors
cd Terraform


# Run Terraform to initialize and apply configuration
# ---
echo "Starting Terraform Initialization and Apply..."
terraform init
terraform apply -auto-approve
echo "Terraform Apply completed successfully!"
# ---


# Retrieve EC2 Instance IP from Terraform output and add to root/importance.txt
# ---
echo "Retrieving EC2 Instance IP..."
INSTANCE_IP=$(terraform output -raw ec2_instance_public_ip)
echo "EC2 Instance IP: $INSTANCE_IP" > ../importance.txt
# ---


# Wait for EC2 SSH Accessibility
# ---
echo "Waiting for the instance to become ready..."
while ! ssh -o StrictHostKeyChecking=no -i ~/.ssh/firstKey.pem ubuntu@$INSTANCE_IP "echo Instance is ready"; do
    echo "Waiting for SSH to be available on $INSTANCE_IP..."
    sleep 10
done
# ---


# Set up Ansible Inventory
# ---
echo "Setting up Ansible inventory..."
cat > ../Ansible/inventory.ini <<EOF
[jenkins-server]
$INSTANCE_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/firstKey.pem
EOF
# ---


# Transfer Ansible files and Run Ansible Playbook
echo "Transferring Ansible files and installing dependencies..."
chmod 600 $HOME/.ssh/firstKey.pem
    # Transfer Ansible files and SSH keys to EC2 instance
scp -i $HOME/.ssh/firstKey.pem -r "../Ansible" ubuntu@$INSTANCE_IP:/home/ubuntu/
scp -i $HOME/.ssh/firstKey.pem "$HOME/.ssh/firstKey.pem" ubuntu@$INSTANCE_IP:/home/ubuntu/.ssh/
# ---


# SSH into EC2 to install Ansible and run the playbook
# ---
ssh -i $HOME/.ssh/firstKey.pem ubuntu@$INSTANCE_IP <<EOF
    sudo chmod 400 ~/.ssh/firstKey.pem
    sudo apt update
    sudo apt install -y ansible
    cd /home/ubuntu/Ansible
    ansible-playbook -i inventory.ini playbook.yml -vvv
    sudo chmod 600 ~/.ssh/firstKey.pem
EOF
echo "Ansible Playbook executed successfully!"
# ---

# Final message
# ---
echo "All infrastructure has been provisioned and configured successfully!"
# ---