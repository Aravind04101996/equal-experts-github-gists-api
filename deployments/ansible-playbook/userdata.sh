#!/bin/bash
# AL2023 Linux Image

echo "Updating system packages"
dnf update -y

echo "Ensuring SSM Agent is running"
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl status amazon-ssm-agent

# Install Ansible
echo "Installing Ansible"
dnf install -y ansible

# Install Docker
echo "Installing Docker"
dnf install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Verify installations
echo "Verifying installations..."
ansible --version
docker --version
systemctl status amazon-ssm-agent
systemctl status docker

# Run Ansible Playbook on EC2 Host
aws s3 cp s3://github-gists-api/ansible-playbook.zip /tmp/github-gists-api-playbook.zip
chmod 644 /tmp/github-gists-api-playbook.zip
unzip -o /tmp/github-gists-api-playbook.zip -d /tmp
ansible-playbook /tmp/ansible-playbook/github-gists-api-playbook.yml

# Log completion
echo "UserData script completed successfully at $(date)" >> /var/log/userdata-completion.log