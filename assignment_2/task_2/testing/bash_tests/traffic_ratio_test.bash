# Starts tunnel in another terminal so we can extract external IPs
gnome-terminal -- bash -c "minikube tunnel; exec bash"

echo "Waiting for minikube tunnel..."
sleep 10

GradesIp=""
EnrollmentsIp=""

# Wait for the external IPs to be assigned
while [[ -z "$GradesIp" || -z "$EnrollmentsIp" ]]; do
    GradesIp=$(kubectl get svc grades-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    EnrollmentsIp=$(kubectl get svc enrollments-app-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    if [[ -z "$GradesIp" || -z "$EnrollmentsIp" ]]; then
        echo "Waiting for external IPs..."
        sleep 5
    fi
done

echo "Grades Service IP: $GradesIp"
echo "Enrollments Service IP: $EnrollmentsIp"

GRADES_BASE_URL="http://${GradesIp}"
ENROLLMENTS_BASE_URL="http://${EnrollmentsIp}"

TOTAL_REQUESTS=100
RATIO=10  # Ratio universitygrades:university (10:1)

success_count=0

for (( i=1; i<=$TOTAL_REQUESTS; i++ ))
do
  if (( $i % ($RATIO + 1) == 0 ))
  then
    # enrollments requests
    response=$(curl -o /dev/null -s -w "%{http_code}\n" "${ENROLLMENTS_BASE_URL}:80/swagger-ui/index.html")
    if [[ "$response" -eq 200 ]]; then
      echo "Request to University Enrollments success."
      ((success_count++))
    else
      echo "Failed to send request to University Enrollments."
    fi
  else
    # Grades requests
    response=$(curl -o /dev/null -s -w "%{http_code}\n" "${GRADES_BASE_URL}:8080/swagger-ui/index.html")
    if [[ "$response" -eq 200 ]]; then
      echo "Request to University Grades success."
      ((success_count++))
    else
      echo "Failed to send request to University Grades."
    fi
  fi
done

echo "-------------------------------------"
echo "Total successful requests sent: $success_count out of $TOTAL_REQUESTS"
echo "-------------------------------------"