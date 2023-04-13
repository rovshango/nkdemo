---
§  Step 1: Install Kubernetes
You will need to install Kubernetes on a target environment such as a virtual machine or a cloud instance. You can use a tool such as kubeadm to set up a Kubernetes cluster, or you can use a cloud provider's managed Kubernetes service such as Amazon Elastic Kubernetes Service (EKS), Google Kubernetes Engine (GKE), or Microsoft Azure Kubernetes Service (AKS).
§  Step 2: Deploy Microservices
Once you have a running Kubernetes cluster, you will need to deploy the microservices on top of it. You can use Helm charts to deploy MariaDB, Grafana, and Elasticsearch on the Kubernetes cluster. Helm is a package manager for Kubernetes that allows you to define, install, and upgrade Kubernetes applications using a declarative configuration.
§  Step 3: Write a Script
Next, you will need to write a script to check the status of the microservices and verify that they are running correctly. The script should check that the microservices are running, accessible, and healthy.
§  Step 4: Run a Script
Finally, you will need to run the script and ensure that all microservices are running and accessible. You can run the script locally or on the Kubernetes cluster, and you should verify that the output of the script matches the expected status of the microservices.


cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
sudo apt-get update && sudo apt-get install -y containerd.io
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd
sudo swapoff -a

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /etc/apt/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --kubernetes-version 1.24.0
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get nodes
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml

kubeadm token create --print-join-command
