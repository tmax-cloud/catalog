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
- REDIS_NAME
  - Redis 인스턴스의 이름. {REDIS_NAME}-redis의 형식으로 생성 됨
- REDIS_PASSWORD
  - Redis 비밀번호

## Redis 사용법

1. Redis 컨테이너 내부 진입 및 redis 접속
    ```bash
    kubectl exec -it `kubectl get pod --selector=app={인스턴스 이름}-redis -n {네임스페이스} -o jsonpath='{$.items[0].metadata.name}'` -n {네임스페이스} -- redis-cli -a "{패스워드}"
    ```

2. 데이터 저장/조회 예시 (string 타입)
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

## Grafana Dashboard 예시
- Redis Exporter
  - https://github.com/oliver006/redis_exporter/blob/master/contrib/grafana_prometheus_redis_dashboard.json
  * 비고 : ${DS_PROMETHEUS}를 prometheus로 치환해야 함

## Redis Insight 적용
- Redis Insight
  - [redis-insight-template](../redis-insight/) 참고
