## Redis Metric Cluster Template Guide
Redis Operator를 이용하는 Custom Resource(RedisCluster exporter) 생성 template
## Prerequisite
- k8s cluster(v1.11+)
- [redis-operator(v0.9.0)](https://ot-container-kit.github.io/redis-operator/)


## Cluster Template
- 생성
    ```shell
    kubectl apply -f template.yaml
    ```
- 확인
    - 다음 명령어 입력 후 출력여부 확인
    ```shell
    kubectl get clustertemplate | grep ot-container-kit-redis-metric-cluster-template
    ```
- 삭제
    ```shell
    kubectl delete -f template.yaml
    ```

## Template Instance
- 생성
    ```shell
    kubectl apply -f instance.yaml
    ```
- 확인
    - 다음 명령어로 확인 후 { APP_NAME }-leader-0, { APP_NAME }-follower-0등의 NAME확인
    ```shell
    kubectl get pods
    ```
    - 출력결과 1
    ```shell
    NAME                             READY   STATUS              RESTARTS   AGE
    redis-metric-cluster-follower-0  0/2     ContainerCreating   0          5s
    redis-metric-cluster-leader-0    0/2     ContainerCreating   0          6s
    ```

    - 출력결과 2
    ```shell
    NAME                              READY   STATUS    RESTARTS   AGE
    redis-metric-cluster-follower-0   2/2     Running   0          112s
    redis-metric-cluster-follower-1   2/2     Running   0          89s
    redis-metric-cluster-follower-2   2/2     Running   0          58s
    redis-metric-cluster-leader-0     2/2     Running   0          113s
    redis-metric-cluster-leader-1     2/2     Running   0          76s
    redis-metric-cluster-leader-2     2/2     Running   0          37s
    ```
- 삭제
    ```shell
    kubectl delete -f instance.yaml
    ```
