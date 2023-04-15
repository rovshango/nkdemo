#!/bin/bash

printf "\033[34mStarting...\033[0m\n"

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
sleep 3

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
helm repo update
sleep 3

printf "\033[34mFinished!!!\033[0m\n"