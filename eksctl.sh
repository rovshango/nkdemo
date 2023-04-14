
https://adamtheautomator.com/aws-eks-cli/#Provisioning_your_EKS_Cluster
https://github.com/kubernetes-sigs/aws-ebs-csi-driver/blob/master/docs/install.md

aws --version

curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin

eksctl version

eksctl create cluster --name dev --version 1.25 --region us-east-1 --zones us-east-1a,us-east-1b --node-zones us-east-1a,us-east-1b --nodegroup-name standard-workers --node-type t2.micro --nodes 3 --nodes-min 1 --nodes-max 3 --managed

curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.24.11/2023-03-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
aws eks update-kubeconfig --name dev --region us-east-1 

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash


for x in `kubectl get pvc | awk {' print $1 '} | grep -v NAME`; do kubectl delete pvc $x; done


aws ec2 create-volume --size 10 --availability-zone us-east-1a --volume-type gp2

aws ec2 describe-volumes --filters Name=status,Values=available --region us-east-1
aws ec2 wait volume-available --volume-ids vol-0d4bd59e48c3e7d0b

# On all worker nodes
aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --instance-id i-0f648f874f31103ba --device /dev/sdf
aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --instance-id i-0c806b1b5524ac286 --device /dev/sdf
aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --instance-id i-0b4c4390f67c76e42 --device /dev/sdf

aws ec2 describe-instances --filters "Name=tag:eks:cluster-name,Values=dev" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text | tr '\n' ' ' | xargs -n 1 -P 0 aws ec2 attach-volume --volume-id vol-0d4bd59e48c3e7d0b --device /dev/sdf --instance-id

for instance_id in $(aws ec2 describe-instances --filters "Name=tag:eks:cluster-name,Values=dev" "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text); do
    az=$(aws ec2 describe-instances --instance-id $instance_id --query "Reservations[].Instances[].Placement.AvailabilityZone" --output text)
    if [ "$az" == "<availability_zone>" ]; then
        aws ec2 attach-volume --volume-id <new_volume_id> --device /dev/xvdf --instance-id $instance_id --region <region_name>
    fi
done
