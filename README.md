# nkdemo
This repository contains files and instruction to demonstrate following:
- Setting up an AWS EKS Cluster via eksctl tool.
- Installing MariaDB, Grafana, and Elasticsearch services via Helm charts as POC.
- Getting the status of the aforementioned services, whether they are running, accessible, and healthy.

**Please read all instructions and script comments before implementing it.**

Prerequisites:

- AWS Console account
- Basic knowledge of how to operate in an AWS console
- Experience in launching, accessing, and managing EC2 instance
- Experience in creating policies and users in the AWS IAM service
- Experience in Kubernetes cluster management, using the kubectl command line
- Experience with the Helm command line tool

<img src="https://d2908q01vomqb2.cloudfront.net/fe2ef495a1152561572949784c16bf23abb28057/2020/04/10/eks_architecture.png" alt="EKS Cluster Architecture">


Steps:

1. Create a simple Amazon Linux EC2 Instance that is accessible over the internet (SSH).
    - Once instance is up and running, connect to it & install **git** tool: `sudo yum install git -y`
    - Clone repository into the EC2 Instance: `git clone https://github.com/rovshango/nkdemo.git`
    - Change to the repository directory: `cd nkdemo`
2. Create an IAM CLI user (example name: **k8s-admin**) with **AdministratorAccess** permissions policy (AWS Managed) attached;
    - Configure aws CLI with this new user's access and security keys in the Step 1 EC2 instance (choose the same AZ where EC2 is running).
3. Create an IAM policy named aws-ebs-csi-driver with the following json;
    - https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json
    - Create an IAM CLI user named **aws-ebs-csi-driver** and attach the **aws-ebs-csi-driver** policy.
    - Save its access and security keys for Step 6.
4. Run the `requirements.sh` script, which will install essential tools.
5. Run the `helm-repos.sh` script, which will install the helm tool and the necessary repositories.
6. Follow and run the commands in the `eksctl.sh` file;
    - **Read the comments of each command group before running them.**
    - **It is best practice to run commands in batch, in order to troubleshoot any errors in case of failure.**
    - **Note that first command, cluster creation, will take approximately 15 minutes.**
7. Run the `helm-install-services.sh` script, which will
    - Install MariaDB, Grafana, and Elasticsearch microservices.
8. Wait for 2 or 3 minutes & run `service-status.sh` script to check microserices' status.
    - You can use the `kubectl get pods` & `kubectl get svc` commands to get the status of Pods and Services.
9. Once the demo is finished, run the `clean-up.sh` script to delete all microservices and CF Stacks.
    - **Note that this process will also take around 15 minutes.**
10. **Terminate the EC2 Instance from Step 1.**
11. **Delete all newly created volumes from the EC2 dashboard.**

References:
- https://eksctl.io/introduction/
- https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md
- https://helm.sh/docs/intro/using_helm/
