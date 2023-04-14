# nkdemo
This repo contains files and instruction to demonstrate following:
- Setting up AWS EKS Cluster via eksctl tool.
- Installing MariaDB, Grafana and Elasticsearch services via Helm charts.
- Getting status of aformentioned services, if they are running, accessible and healthy.

Please read all instruction before implementing it.

Prerequisites:

- AWS Console account
- Basic knowledege how to operate in AWS console
- Experinece in launching EC2 instance

Steps:

1. Create AMI Insrance which accessible over internet or console page
2. Create console user (example name: k8s-admin)
    a. Attach Admin and follwing policy into the user:
    https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json
    b. Set up access and security keys
    c. Configure aws cli via aws configure command, using keys of new user
3. Follow and run commands in eksctl.sh file
    Best practice to run command in batch, in order faster troubleshoot in case of failure
4. Run helm_install_repos.sh script (bash helm_install_repos.sh)
    It will download necessary helm repos and install MariaDB, Grafana & Elasticseach microservices

Step 1: Install Kubernetes
You will need to install Kubernetes on a target environment such as a virtual machine or a cloud instance. You can use a tool such as kubeadm to set up a Kubernetes cluster, or you can use a cloud provider's managed Kubernetes service such as Amazon Elastic Kubernetes Service (EKS), Google Kubernetes Engine (GKE), or Microsoft Azure Kubernetes Service (AKS).

Step 2: Deploy Microservices
Once you have a running Kubernetes cluster, you will need to deploy the microservices on top of it. You can use Helm charts to deploy MariaDB, Grafana, and Elasticsearch on the Kubernetes cluster. Helm is a package manager for Kubernetes that allows you to define, install, and upgrade Kubernetes applications using a declarative configuration.

Step 3: Write a Script
Next, you will need to write a script to check the status of the microservices and verify that they are running correctly. The script should check that the microservices are running, accessible, and healthy.

Step 4: Run a Script
Finally, you will need to run the script and ensure that all microservices are running and accessible. You can run the script locally or on the Kubernetes cluster, and you should verify that the output of the script matches the expected status of the microservices.
