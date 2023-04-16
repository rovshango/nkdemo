#!/bin/bash

helm install grafana grafana/grafana --set service.type=LoadBalancer
sleep 5
helm install elasticsearch elastic/elasticsearch --set service.type=LoadBalancer
sleep 5
helm install mariadb bitnami/mariadb
sleep 5