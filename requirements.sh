#!/bin/bash

printf "\033[34mStarting...\033[0m\n"

# install cli tools
sudo yum install git telnet jq -y

# setup eksctl command line tool
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/bin
eksctl version || exit 1

# setup kubectl command line tool
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.16.8/2020-04-16/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
rm -rf kubectl

printf "\033[34mFinished!!!\033[0m\n"
