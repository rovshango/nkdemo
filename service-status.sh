#!/bin/bash

printf "\033[34mChecking grafana service.\033[0m\n"

# Get the Grafana service URL
GRAFANA_IP=$(kubectl get svc grafana --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Get your 'admin' user password
GADMIN=$(kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)

# Check if the Grafana service is running and accessible
GSTATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$GRAFANA_IP:80/login)
  if [ $GSTATUS -eq 200 ]; then
    printf "\033[32mSuccess: grafana is running and accessible.\033[0m\n"
  else
    printf "\033[31mError: grafana is not running or accessible.\033[0m\n"
    exit 1
  fi

# Check if the Grafana service is healthy
GHEALTH=$(curl -s http://$GRAFANA_IP:80/api/health | grep -o ok)
  if [ $GHEALTH == "ok" ]; then
    printf "\033[32mSuccess: grafana is healthy.\033[0m\n"
  else
    printf "\033[31mError: grafana is not healthy.\033[0m\n"
    exit 1
  fi

printf "\033[34mChecking elasticsearch service.\033[0m\n"

# Get the Elasticsearch service URL
ELASTIC_IP=$(kubectl get svc elasticsearch-master --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Retrieve elastic user's password
EPASSWD=$(kubectl get secrets --namespace=default elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d)

# Check if the Elasticsearch service is healthy
ESTATUS=$(curl -s -k --user elastic:${EPASSWD} -X GET "https://${ELASTIC_IP}:9200/_cluster/health?pretty"  | jq -r '.status')
  if [ $ESTATUS == "green" ]; then
    printf "\033[32mSuccess: elasticsearch is running, accessible and healthy.\033[0m\n"
  else
    printf "\033[31mError: elasticsearch is not running or accessible or healthy.\033[0m\n"
    exit 1
  fi

printf "\033[34mChecking mariadb service.\033[0m\n"

# Get the MariaDB service URL
#MARIADB_IP=$(kubectl get svc mariadb -o=jsonpath='{.spec.clusterIP}')

# Check if the MariaDB service is running
#curl -I http://$MARIADB_IP:3306

# Check if the MariaDB service is accessible
#mysql -h $MARIADB_IP -u myuser -p -e "SHOW DATABASES;"

# Check if the MariaDB service is healthy
#mysql -h $MARIADB_IP -u myuser -p mydatabase -e "SELECT * FROM mytable;"
