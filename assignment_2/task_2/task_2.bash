#!/bin/bash

minikube delete
minikube start

kubectl apply -f postgresql_setup/persistentVolume.yaml
kubectl apply -f postgresql_setup/persistentVolumeClaim.yaml
helm install postgresdb --namespace default bitnami/postgresql -f postgresql_setup/values.yaml

kubectl apply -f postgresql_setup/secret.yaml
kubectl apply -f postgresql_setup/configmap.yaml

kubectl apply -f university_app/deployment.yaml
kubectl apply -f university_grades/deployment.yaml
