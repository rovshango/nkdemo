#!/bin/bash

MYSQL_HOST="mariadb.default.svc.cluster.local"
MYSQL_USER="root"
MYSQL_PASSWORD=$(kubectl get secret --namespace default mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
MYSQL_DATABASE="my_database"

# Check if the MySQL service is accessible with provided credentials
if ! mysql -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD -e "SELECT 1;" $MYSQL_DATABASE; then
  echo "Unable to connect to MySQL service"
  exit 1
fi

# Check if the MySQL service is healthy
if ! mysqlcheck -h $MYSQL_HOST -u $MYSQL_USER -p$MYSQL_PASSWORD --check $MYSQL_DATABASE; then
  echo "MySQL service is not healthy"
  exit 1
fi

echo "MySQL service is running, accessible and healthy"
exit 0