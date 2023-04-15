# create eks cluster with 3 worker nodes
# following command will take approx. 20-25 min to finish 
# in case of error either re-run or change availabilty zones
eksctl create cluster --name dev --region us-east-1 --zones us-east-1a,us-east-1b --node-zones us-east-1a,us-east-1b --nodegroup-name ng-workers --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

# configure kubectl command, so it can access contral plane api
aws eks update-kubeconfig --name dev --region us-east-1

# check if you can see worker nodes
kubectl get nodes

# creating necessary components for ebs csi driver
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

# install aws-ebs-csi-driver services via helm chart
helm upgrade --install aws-ebs-csi-driver \
    --namespace kube-system \
    aws-ebs-csi-driver/aws-ebs-csi-driver

# check status of newly created pods, they all should be running
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver

# delete eks cluster
#eksctl delete cluster dev