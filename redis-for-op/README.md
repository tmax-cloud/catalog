## Redis with redis-operator
## Prerequisite
- k8s cluster(v1.11+)
- redis-operator(v0.10.0)
- redis-secret

## Generate Custom Resources
- redis-secret 생성
    ```shell
    kubectl apply -f redis-secret.yaml
    ```
- redis-standalone 생성
    ```shell
    kubectl apply -f standalone/redis-standalone.yaml
    ```
- redis-cluster 생성
    ```shell
    kubectl apply -f cluster/redis-cluster.yaml
    ```