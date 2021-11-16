# Redis Template Guide

1. Template 생성
    ```bash
    kubectl apply -f redis-template.yaml
    ```

2. TemplateInstance 생성
    ```bash
    kubectl apply -f redis-instance.yaml
    ```

## Parameter 설명
- REDIS_PASSWORD
  - Redis 비밀번호

## Redis 사용법

1. Redis 컨테이너 내부 접속
    ```bash
    kubectl exec -it `kubectl get pod --selector=app=redis -n redis -o jsonpath='{$.items[0].metadata.name}'` -n redis -- bash
    ```
2. redis-cli 실행
    ```bash
    redis-cli -a "mypassword"
    ```


3. 데이터 저장/조회 예시 (string 타입)
    * key value 저장
        ```
        127.0.0.1:6379> set my-key my-value
        OK
        ```
    * value 조회
        ```
        127.0.0.1:6379> get my-key
        "my-value"
        ```
    * key 전체 목록 조회
        ```
        127.0.0.1:6379> keys *
        1) "my-key"
        ```
    * 공식 문서  
      - https://redis.io/commands#string