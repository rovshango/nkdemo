###
aws --version
aws configure

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin

curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc

eksctl version
eksctl create cluster --name dev --region us-east-1 --zones us-east-1a,us-east-1b --node-zones us-east-1a,us-east-1b --nodegroup-name ng-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 3 --managed

aws eks update-kubeconfig --name dev --region us-east-1
#####
https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=dev --approve
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster dev \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name AmazonEKS_EBS_CSI_DriverRole

kubectl create secret generic aws-secret \
    --namespace kube-system \
    --from-literal "key_id=${AWS_ACCESS_KEY_ID}" \
    --from-literal "access_key=${AWS_SECRET_ACCESS_KEY}"

sudo yum install git -y

helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver

kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver

for x in `kubectl get pvc | awk {' print $1 '} | grep -v NAME`; do kubectl delete pvc $x; done


aws ec2 create-volume --size 10 --availability-zone us-east-1a --volume-type gp2

aws ec2 describe-volumes --filters Name=status,Values=available --region us-east-1
aws ec2 wait volume-available --volume-ids vol-0d4bd59e48c3e7d0b

# On all worker nodes
aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --instance-id i-0f648f874f31103ba --device /dev/sdf
aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --instance-id i-0c806b1b5524ac286 --device /dev/sdf
aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --instance-id i-0b4c4390f67c76e42 --device /dev/sdf

aws ec2 describe-instances --filters "Name=tag:eks:cluster-name,Values=dev" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text | tr '\n' ' ' | xargs -n 1 -P 0 aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --device /dev/sdf --instance-id