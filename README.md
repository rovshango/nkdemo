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