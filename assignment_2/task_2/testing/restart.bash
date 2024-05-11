#!/bin/bash

NAMESPACE=default

kubectl delete all --all
helm delete db --namespace $NAMESPACE
echo "Waiting for Helm release to be fully deleted..."
sleep 5

kubectl delete deployments,svc,pods,secrets,configmaps,pvc,pv --all --namespace $NAMESPACE
echo "Waiting for resources to be fully deleted..."
sleep 5

# kubectl delete pvc datdb-postgresql-0
kubectl delete pvc --all --namespace $NAMESPACE

helm uninstall db
# helm uninstall bitnami/postgresql