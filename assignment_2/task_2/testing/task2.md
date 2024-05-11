# Task 2 questions

## 2a

### ConfigMap
A ConfigMap is an API object that is used to store configurations in key-value pairs for application code. This makes applications easy to move across different environments without altering the application code. It is important that confidential data is not stored in these configuration files

### Secrets
Secrets are used to store and manage sensitive information such as passwords, ssh keys and O'Auth tokens. This practice ensures that sensitive data is not exposed in the application

### Persistent Volumes
Persistent volumes are used for managing storage in kubernetes. PVs are resources in the cluster that store data persistently, this means that the data survives beyond the life of individual pods. 

PVCs
These are requests for storage by the user, specifying size and access modes such as read write for a single user.



### Helm installation
We specified different yaml files for each api object, with configuration stored
in a configMap, postgres password stored in the secret


Output:
Pod:
this pod is the postgresql database server running inside the k8s cluster

Services:
helm provided two services
both are cluster ip, meaning that they are only accessible within the cluster

postgres-postgresql: This is the main service that other applications within your cluster would use to connect to the PostgreSQL database. It routes traffic to the running PostgreSQL pod(s).

postgres-postgresql-hl (headless service): This is used for service discovery purposes and does not perform load balancing or have a single IP. Pods connect to each other using this service when they need to communicate directly without the intervention of load balancing, useful in stateful applications like databases for peer discovery and management.