# nkdemo
This repository contains files and instruction to demonstrate following:
- Setting up AWS EKS Cluster via eksctl tool.
- Installing MariaDB, Grafana and Elasticsearch services via Helm charts as POC.
- Getting status of aformentioned services, whether they are running, accessible, and healthy.

Please read all instruction and script comments before implementing it.

Prerequisites:

- AWS Console account.
- Basic knowledge how to operate in AWS console.
- Experience in launching, accessing, managing EC2 instance.
- Experience in creating policies and users in AWS IAM service.
- Experience in Kubernetes cluster management, using kubectl command line.

Steps:

1. Create simple Amazon Linux EC2 Instance which accessible over internet or console page.
2. Create CLI user (example name: k8s-admin) with AdministratorAccess permission policy attached in IAM Service;
    - Configure aws CLI with new user's access and security key in the Step 1 EC2 instance (choose same AZ where EC2 is running).
3. Create IAM policy named aws-ebs-csi-driver with following json;
    - https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json
    - Create CLI user named aws-ebs-csi-driver and attach aws-ebs-csi-driver policy to it in IAM service.
    - Save its access and security keys for next steps.
4. Run requirements.sh script, which will install essential tools.
5. Run helm-repos.sh script, which will install helm CLI and the necessary repositories.
6. Follow and run commands in eksctl.sh file;
    - Read comments of each command group.
    - Best practice to run commands in batch, in order troubleshoot any errors in case of failure.
7. Run helm-install-services.sh script, which will
    - Install MariaDB, Grafana & Elasticseach microservices.
8. Run service-status.sh script, to check microserices' status.