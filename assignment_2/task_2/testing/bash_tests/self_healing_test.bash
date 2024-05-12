#!/bin/bash

### SELF HEALING TESTS ###

GRADES_POD=$(kubectl get pods -l app=grades-app -o jsonpath="{.items[0].metadata.name}")
ENROLLMENTS_POD=$(kubectl get pods -l app=enrollments-app -o jsonpath="{.items[0].metadata.name}")

echo "Deleting Grades App Pod: $GRADES_POD"
kubectl delete pod $GRADES_POD
echo "Deleting Enrollments App Pod: $ENROLLMENTS_POD"
kubectl delete pod $ENROLLMENTS_POD

echo "Waiting for new pods..."
# sleep 30

# fetch the newly spawned pod
NEW_GRADES_POD_NAME=$(kubectl get pods -l app=grades-app -o jsonpath="{.items[0].metadata.name}")
NEW_ENROLLMENTS_POD_NAME=$(kubectl get pods -l app=enrollments-app -o jsonpath="{.items[0].metadata.name}")


echo "-------------------------------------"
if [ "$GRADES_POD" != "$NEW_GRADES_POD_NAME" ]; then
    echo "New Grades App pod has been created: $NEW_GRADES_POD_NAME"
else
    echo "Grades App pod recreation failed or is delayed."
fi

if [ "$ENROLLMENTS_POD" != "$NEW_ENROLLMENTS_POD_NAME" ]; then
    echo "New Enrollments App pod has been created: $NEW_ENROLLMENTS_POD_NAME"
else
    echo "Enrollments App pod recreation failed or is delayed."
fi

echo "-------------------------------------"