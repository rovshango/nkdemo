# setup eksctl command tool
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin

# setup kubectl command tool
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

eksctl version
# create eks cluster with 4 worker nodes
# following command will take approx. 20 min to run 
# in case of error either re-run or change AZ
eksctl create cluster --name dev --region us-east-1 --zones us-east-1a,us-east-1b --node-zones us-east-1a,us-east-1b --nodegroup-name ng-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

aws eks update-kubeconfig --name dev --region us-east-1

# check if you can see worker nodes
kubectl get nodes

# creating necessary compoenents for EBS CSI Driver
# source: https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=dev --approve
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster dev \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole

# use newly created user's keys
# define them in env variables in advance
kubectl create secret generic aws-secret \
    --namespace kube-system \
    --from-literal "key_id=${AWS_ACCESS_KEY_ID}" \
    --from-literal "access_key=${AWS_SECRET_ACCESS_KEY}"

# we will need these tools
sudo yum install git telnet jq -y

# install helm tool, repos and driver
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update

helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver

# check status of newly created pods, they all should be running
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver

# delete eks cluster
#eksctl delete cluster dev