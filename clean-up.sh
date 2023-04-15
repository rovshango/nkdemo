#!/bin/bash

# Delete stack named eksctl-dev-addon-iamserviceaccount-kube-system-ebs-csi-controller-sa from CloudFourmation page
aws cloudformation delete-stack --stack-name eksctl-dev-addon-iamserviceaccount-kube-system-ebs-csi-controller-sa

# delete eks cluster
eksctl delete cluster dev