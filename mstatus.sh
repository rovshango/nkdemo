#!/bin/bash

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