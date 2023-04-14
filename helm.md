
helm install grafana grafana/grafana --set service.type=LoadBalancer
helm install elasticsearch elastic/elasticsearch --set service.type=LoadBalancer
helm install mariadb bitnami/mariadb


mariadb
RUNNING
curl -I http://<EXTERNAL-IP>:3306
ACCESSIBLE
mysql -h <EXTERNAL-IP> -u myuser -p
HEALTHY
mysql -h <EXTERNAL-IP> -u myuser -p mydatabase -e "SELECT * FROM mytable;"