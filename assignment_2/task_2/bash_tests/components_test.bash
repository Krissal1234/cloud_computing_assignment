#!/bin/bash

NAMESPACE="default"
POSTGRES_HELM_RELEASE="postgresdb"
UNIVERSITY_APP_DEPLOYMENT="enrollments-app"
GRADES_APP_DEPLOYMENT="grades-app"

successful_checks=0
failed_checks=0

check_postgres_with_helm (){
    if helm status $1 -n $NAMESPACE; then
        echo "$1 has successfully deployed."
        ((successful_checks++))
    else
        echo "Failed to deploy $1."
        ((failed_checks++))
    fi
}

check_k8s_resource (){
    local RESOURCE=$1
    local NAME=$2
    if kubectl get $RESOURCE $NAME -n $NAMESPACE &> /dev/null; then
        echo "$RESOURCE $NAME has deployed correctly."
        ((successful_checks++))
    else
        echo "$RESOURCE $NAME deployment failed."
        ((failed_checks++))
    fi
}

check_postgres_with_helm $POSTGRES_HELM_RELEASE
check_k8s_resource secret postgres-secret
check_k8s_resource configmap postgres-config
check_k8s_resource pv "$(kubectl get pv | grep $NAMESPACE | awk '{print $1}')"
check_k8s_resource pvc postgres-pvc
check_k8s_resource deployments $UNIVERSITY_APP_DEPLOYMENT
check_k8s_resource deployments $GRADES_APP_DEPLOYMENT

# Print summary of results
echo "-------------------------------------"
echo "Deployment Summary:"
echo "Successful checks: $successful_checks"
echo "Failed checks: $failed_checks"
echo "-------------------------------------"

if [ $failed_checks -ne 0 ]; then
    echo "Some resources failed to deploy correctly."
    exit 1
fi

echo "All components are deployed successfully."
