#!/bin/bash

printf "\033[34mChecking grafana service.\033[0m\n"

# Get the Grafana service URL
GRAFANA_IP=$(kubectl get svc grafana --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Get your 'admin' user password
GADMIN=$(kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)

# Get grafana pod status
GSTATUS=$(kubectl get pods --selector=app.kubernetes.io/name=grafana -o jsonpath='{.items[*].status.phase}')

# Check if the Grafana service is running
if [ ${GSTATUS} == "Running" ]; then
  printf "\033[32mSuccess: grafana is running.\033[0m\n"
else
  printf "\033[31mError: grafana is not running.\033[0m\n"
fi

# Check if the Grafana service is accessible
GACCESS=$(curl -s -o /dev/null -w "%{http_code}" http://$GRAFANA_IP:80/login)
  if [ $GACCESS -eq 200 ]; then
    printf "\033[32mSuccess: grafana is accessible.\033[0m\n"
  else
    printf "\033[31mError: grafana is not accessible.\033[0m\n"
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

# Get elasticseach pods' status
ESTATUS=$(kubectl get pods --selector=app=elasticsearch-master -o jsonpath='{.items[*].status.phase}')

# Get the Elasticsearch service URL
ELASTIC_IP=$(kubectl get svc elasticsearch-master --output jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Retrieve elastic user's password
EPASSWD=$(kubectl get secrets --namespace=default elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d)

# Check if the Elasticsearcg service is running
if [ ${GSTATUS} == "Running Running Running" ]; then
  printf "\033[32mSuccess: elasticsearch is running.\033[0m\n"
else
  printf "\033[31mError: elasticsearch is not running.\033[0m\n"
fi

# Check if the Elasticsearch service is accessible healthy
EACCESS=$(curl -s -k --user elastic:${EPASSWD} -X GET "https://${ELASTIC_IP}:9200/_cluster/health?pretty"  | jq -r '.status')
  if [ $EACCESS == "green" ]; then
    printf "\033[32mSuccess: elasticsearch is accessible and healthy.\033[0m\n"
  else
    printf "\033[31mError: elasticsearch is accessible or healthy.\033[0m\n"
    exit 1
  fi

printf "\033[34mChecking mariadb service. Please wait...\033[0m\n"

MYSQL_HOST="mariadb.default.svc.cluster.local"
MYSQL_USER="root"
MYSQL_PASSWORD=$(kubectl get secret --namespace default mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
MYSQL_DATABASE="my_database"
MYSQL_STATUS=$(kubectl get pods --selector=app.kubernetes.io/name=mariadb -o jsonpath='{.items[*].status.phase}')

# Check if the MySQL service is accessible with provided credentials
if [ ${MYSQL_STATUS} == "Running" ]; then
  printf "\033[32mSuccess: mariadb is running.\033[0m\n"
else
  printf "\033[31mError: mariadb is not running.\033[0m\n"
fi

# Check if the MySQL service is accessible with provided credentials
if ! kubectl run mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:10.6.12-debian-11-r16 --namespace default --command -- mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" $MYSQL_DATABASE > /dev/null; then
  printf "\033[31mError: mariadb is not accessible.\033[0m\n"
  exit 1
else
  printf "\033[32mSuccess: mariadb is accessible.\033[0m\n"
fi

# Check if the MySQL service is healthy
if ! kubectl run mariadb-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mariadb:10.6.12-debian-11-r16 --namespace default --command -- mysqlcheck -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD --check $MYSQL_DATABASE > /dev/null; then
  printf "\033[31mError: mariadb is not healthy.\033[0m\n"
  exit 1
else
  printf "\033[32mSuccess: mariadb is healthy.\033[0m\n"
fi