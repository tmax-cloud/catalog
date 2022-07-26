## Redis Proxy Template Guide
redis cluster 에 대해 redirection처리를 해주는 redis proxy에 대한 생성 template
## Prerequisite
- k8s cluster(v1.11+)
- redis cluster


## Cluster Template
- 생성
    ```shell
    kubectl apply -f template.yaml
    ```
- 확인
    - 다음 명령어 입력 후 출력여부 확인
    ```shell
    kubectl get clustertemplate | grep redis-proxy-template
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
    - 다음 명령어로 확인
    ```shell
    kubectl get pods
    ```
    - 출력결과 1
    ```shell
    redis-proxy-5958bc8d45-g7tg7   1/1     Running   0          7m8s
    redis-proxy-5958bc8d45-j8xwh   1/1     Running   0          7m8s
    redis-proxy-5958bc8d45-xzhvb   1/1     Running   0          7m8s
    ```

    - 생성된 service 확인
    ```shell
    kubectl get svc
    ```
    - service type을 ClusterIP로 했을 때 출력결과 
    ```shell
    NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)     AGE
    redis-proxy-service  ClusterIP   10.96.25.113    <none>        7777/TCP    84s
    ```

    - service type을 NodePort로 했을 때 출력결과 
    ```shell
    NAME                 TYPE     CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
    redis-proxy-service  NodePort 10.96.235.78 <none>        7777:31971/TCP   7m17s
    ```

    - service type을 LoadBalancer로 했을 때 출력결과 
    ```shell
    NAME                 TYPE          CLUSTER-IP      EXTERNAL-IP     PORT(S)          AGE
    redis-proxy-service  LoadBalancer  10.96.249.132   192.168.9.144   7777:31808/TCP   83s
    ```
- 삭제
    ```shell
    kubectl delete -f instance.yaml
    ```
