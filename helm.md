
helm install mariadb bitnami/mariadb
helm install grafana grafana/grafana --set service.type=NodePort
helm install elasticsearch elastic/elasticsearch


          volumeMounts:
            - name: data
              mountPath: /bitnami/mariadb
            - name: config
              mountPath: /opt/bitnami/mariadb/conf/my.cnf
              subPath: my.cnf
      volumes:
        - name: config
          configMap:
            name: my-release-mariadb
  volumeClaimTemplates:
    - metadata:
        name: data
        labels: 
          app.kubernetes.io/name: mariadb
          app.kubernetes.io/instance: my-release
          app.kubernetes.io/component: primary
      spec:
        accessModes:
          - "ReadWriteOnce"
        resources:
          requests:
            storage: "8Gi"
no persistent volumes available for this claim and no storage class is set

   kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
   grafana.default.svc.cluster.local
   export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace default port-forward $POD_NAME 3000

1. Watch all cluster members come up.
  $ kubectl get pods --namespace=default -l app=elasticsearch-master -w
2. Retrieve elastic user's password.
  $ kubectl get secrets --namespace=default elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
3. Test cluster health using Helm test.
  $ helm --namespace=default test elasticsearch

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