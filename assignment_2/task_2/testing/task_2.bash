
# kubectl apply -f postgresql_setup/secret.yaml
# kubectl apply -f postgresql_setup/configmap.yaml
# kubectl apply -f postgresql_setup/persistentVolume.yaml
# kubectl apply -f postgresql_setup/persistentVolumeClaim.yaml

# helm install postgresdb \
  # --namespace default \
  # --set postgresqlPassword="pass",postgresqlDatabase=universitydb\
  # bitnami/postgresql

# helm install db bitnami/postgresql

# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update
# minikube delete
# minikube start
# helm install test bitnami/postgresql -f postgresql_setup/values.yaml
 #-f postgresql_setup/values.yaml --namespace $NAMESPACE

# list all secrests: kubectl get secrets -o json | jq '.items[] | {name: .metadata.name,data: .data|map_values(@base64d)}'

# --set postgresqlPassword=pass,postgresqlUsername=postgres,postgresqlDatabase=universitydb
# kubectl exec -it <postgres-pod-name> -- psql -U postgres -W



# kubectl apply -f university_app/deployment.yaml
# kubectl apply -f university_grades/deployment.yaml


# To get the password for "postgres" run:

#     export POSTGRES_PASSWORD=$(kubectl get secret --namespace default test-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

# To connect to your database run the following command:

#     kubectl run test-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:latest --env="PGPASSWORD=$POSTGRES_PASSWORD" \
#       --command -- psql --host test-postgresql -U postgres -d postgres -p 5432


# Set up the environment
# kubectl apply -f postgresql_setup/secret.yaml
# kubectl apply -f postgresql_setup/configmap.yaml
# kubectl apply -f postgresql_setup/persistentVolume.yaml
# kubectl apply -f postgresql_setup/persistentVolumeClaim.yaml

# Initialize Helm repository
# helm repo add bitnami https://charts.bitnami.com/bitnami
# helm repo update

# Start minikube (optional, depends if using minikube or not)
minikube delete
minikube start

kubectl apply -f postgresql_setup/secret.yaml
kubectl apply -f postgresql_setup/configmap.yaml
kubectl apply -f postgresql_setup/persistentVolume.yaml
kubectl apply -f postgresql_setup/persistentVolumeClaim.yaml

# Install PostgreSQL with specific settings
helm install postgresdb --namespace default bitnami/postgresql -f postgresql_setup/values.yaml
 # --set postgresqlPassword="pass",postgresqlDatabase=universitydb\
  # bitnami/postgresql

# Get the password for "postgres" user
# PASSWORD=$(kubectl get secret --namespace default postgresdb-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)

# sed -i "s/REPLACE_PASSWORD/${PASSWORD}/g" university_app/deployment.yaml

# kubectl run postgresdb-postgresql-client --rm --tty -i --restart='Never' --namespace default \
#   --image docker.io/bitnami/postgresql:latest --env="PGPASSWORD=$PASSWORD" \
#   --command -- psql --host postgresdb-postgresql -U postgres -p 5432 <<EOF
# CREATE DATABASE IF NOT EXISTS universitydb;
# \q
# EOF

kubectl apply -f university_app/deployment.yaml
# kubectl apply -f university_grades/deployment.yaml
# kubectl apply -f university_grades/deployment.yaml

# Connect to your database and create a table
