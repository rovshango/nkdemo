#!/bin/bash

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add elastic https://helm.elastic.co

helm install grafana grafana/grafana --set service.type=LoadBalancer
helm install elasticsearch elastic/elasticsearch --set service.type=LoadBalancer
helm install mariadb bitnami/mariadb