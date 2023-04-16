https://quillbot.com/grammar-check

This repository contains files and instructions to demonstrate the following:

- Setting up an AWS EKS cluster via the eksctl tool
- Installing MariaDB, Grafana, and Elasticsearch services via Helm charts as a POC
- Getting the status of the aforementioned services—whether they are running, accessible, and healthy—is also important.

**Please read all instructions and script comments before implementing them.**

Prerequisites:

- AWS Console account
- Basic knowledge of how to operate in the AWS console
- Experience in launching, accessing, and managing EC2 instances.
- Experience in creating policies and users in the AWS IAM service.
- Experience in Kubernetes cluster management using the kubectl command line
- Experience with the Helm command-line tool

Steps:

1. Create a simple Amazon Linux EC2 instance that is accessible over the internet (SSH).
Once the instance is up and running, connect to it and install the git tool. sudo yum install git -y
Clone repository into an EC2 instance: git clone https://github.com/rovshango/nkdemo.git
Change to the repository directory: cd nkdemo
Create an IAM CLI user (example name: k8s-admin) with an AdministratorAccess permissions policy (AWS Managed) attached;
Configure the AWS CLI with this new user's access and security keys in the Step 1 EC2 instance (choose the same AZ where EC2 is running).
Create an IAM policy named aws-ebs-csi-driver with the following JSON:
https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json
Create an IAM CLI user named aws-ebs-csi-driver and attach the aws-ebs-csi-driver policy.
Save its access and security keys for Step 6.
Run the requirements.sh script, which will install essential tools.
Run the helm-repos.sh script, which will install the helm tool and the necessary repositories.
Follow and run the commands in the eksctl.sh file.
Read the comments for each command group before running them.
It is best practice to run commands in batch in order to troubleshoot any errors in the event of failure.
Note that the first command, cluster creation, will take approximately 15 minutes.
Run the helm-install-services.sh script, which will
Install MariaDB, Grafana, and Elasticsearch microservices.
Wait for 2 or 3 minutes and run the service-status.sh script to check the services' status.
You can use the kubectl get pods and kubectl get svc commands to get the status of pods and services.
Once the demo is finished, run the clean-up.sh script to delete all microservices and CF stacks.
Note that this process will also take around 15 minutes.
Terminate the EC2 instance from Step 1.
Delete all newly created volumes from the EC2 dashboard.
