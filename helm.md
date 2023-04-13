curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod +x get_helm.sh
./get_helm.sh

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add elastic https://helm.elastic.co

helm install mariadb bitnami/mariadb
helm install grafana grafana/grafana
helm install elasticsearch elastic/elasticsearch


replicas: 2
persistence:
  enabled: false
mariadb:
  rootUser:
    password: mysecretpassword
  db:
    name: mydatabase
    user: myuser
    password: mypassword


helm install my-mariadb bitnami/mariadb -f values.yaml




grafana
RUNNIG:
curl -I http://<EXTERNAL-IP>:3000
ACCESSIBLE:
curl http://<EXTERNAL-IP>:3000/api/health
HEALTHY
curl http://<EXTERNAL-IP>:3000/api/health | grep -o '"status":"ok"'

elastic
RUNNIG
curl -I http://<EXTERNAL-IP>:9200
ACCESSIBLE
curl http://<EXTERNAL-IP>:9200/_cluster/health?pretty
HEALTHY
curl http://<EXTERNAL-IP>:9200/_cluster/health | grep -o '"status":"green"'

mariadb
RUNNING
curl -I http://<EXTERNAL-IP>:3306
ACCESSIBLE
mysql -h <EXTERNAL-IP> -u myuser -p
HEALTHY
mysql -h <EXTERNAL-IP> -u myuser -p mydatabase -e "SELECT * FROM mytable;"