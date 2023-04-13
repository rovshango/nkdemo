#!/bin/bash

# Define the microservices that you want to check
SERVICES=("service-1" "service-2" "service-3")

# Loop through each microservice and check its status
for service in "${SERVICES[@]}"; do
  echo "Checking status of $service..."

  # Get the service's IP address
  SERVICE_IP=$(kubectl get svc $service -o=jsonpath='{.spec.clusterIP}')

  # Check if the service is running and accessible
  STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://$SERVICE_IP:8080/health)

  if [ $STATUS -eq 200 ]; then
    echo "Service $service is running and accessible"
  else
    echo "Error: Service $service is not running or accessible"
    exit 1
  fi

  # Check if the service is healthy
  HEALTH=$(curl -s http://$SERVICE_IP:8080/health)

  if [[ $HEALTH == *"status\":\"UP"* ]]; then
    echo "Service $service is healthy"
  else
    echo "Error: Service $service is not healthy"
    exit 1
  fi
done

echo "All microservices are running correctly!"
