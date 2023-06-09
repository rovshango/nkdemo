#!/bin/bash

# Uninstall services
helm uninstall grafana
helm uninstall elasticsearch
helm uninstall mariadb

printf "\033[34mDeleting eksctl-dev-addon-iamserviceaccount-kube-system-ebs-csi-controller-sa CF Stack\033[0m\n"
# Delete stack named eksctl-dev-addon-iamserviceaccount-kube-system-ebs-csi-controller-sa from CloudFourmation page
aws cloudformation delete-stack --stack-name eksctl-dev-addon-iamserviceaccount-kube-system-ebs-csi-controller-sa

printf "\033[34mDeletion of kubernetes cluster is started, please wait...\033[0m\n"
# delete eks cluster
eksctl delete cluster dev

printf "\033[34mDeletion of kubernetes cluster is finished!!!\033[0m\n"