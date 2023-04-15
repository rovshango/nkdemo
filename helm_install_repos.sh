#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
sleep 3

helm install grafana grafana/grafana --set service.type=LoadBalancer
sleep 5
helm install elasticsearch elastic/elasticsearch --set service.type=LoadBalancer
sleep 5
helm install mariadb bitnami/mariadb
sleep 5

echo "Finished"