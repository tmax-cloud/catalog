## Redis Metric Standalone Template Guide
Redis Operator를 이용하는 Custom Resource(Redis) 생성 template
## Prerequisite
- k8s cluster(v1.11+)
- [redis-operator(v0.10.0)](https://ot-container-kit.github.io/redis-operator/)


## Cluster Template
- 생성
    ```shell
    kubectl apply -f template.yaml
    ```
- 확인
    - 다음 명령어 입력 후 출력여부 확인
    ```shell
    kubectl get clustertemplate | grep ot-container-kit-redis-metric-standalone-template
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
    - 다음 명령어로 확인 후 ${APP_NAME}-0의 NAME확인
    ```shell
    kubectl get pods
    ```
    - 출력결과
    ```shell
    NAME                           READY   STATUS    RESTARTS   AGE
    redis-metric-standalone-0    2/2     Running   0          33m
    ```
- 삭제
    ```shell
    kubectl delete -f instance.yaml
    ```