# Strimzi In-cluster With Meric Kafka Template Guide

## Prerequisite
- https://github.com/tmax-cloud/install-kafka-operator를 통해 strimzi cluster operator가 설치 되어 있어야 합니다.
- Prometheus 및 Grafana가 설치 되어 잇어야한다.

## Description
- Strimzi Kafka Operator를 통해 띄운 No ssl, Metric 수집 In cluster 전용 kafka template입니다.
- K8s Cluster 내부에서만 Pub/Sub이 가능하고, 가능한 주소는 
- ${APP_NAME}-kafka-bootstrap.${NAMESPACE}:9092  입니다.


1. Template 생성
```bash
kubectl apply -f template.yaml
```

2. TemplateInstance 생성
```bash
kubectl apply -f instance.yaml
```

## Parameter 설명
- APP_NAME  
  - Kafka App 제목

- KAFKA_REPLICA_COUNT  
  - Kafka Broker 갯수

- ZOOKEEPER_REPLICA_COUNT  
  - Zookeepr 갯수

- KAFKA_STORAGE
  - Kafka용 PVC의 크기 (default: 5Gi)

- ZOOKEEPER_STORAGE
  - Zookeeper용 PVC의 크기 (default: 1Gi)

- STORAGE_CLASS  
  - Kafka용 PVC의 Storage Class (default: csi-cephfs-sc)

- KAFKA_RESOURCE_CPU  
  - Kafka 컨테이너 cpu 리소스 request/limit (default: 1)

- KAFKA_RESOURCE_MEM  
  - Kafka 컨테이너 memory 리소스 request/limit (default: 1Gi)

- ZOOKEEPER_RESOURCE_CPU  
  - Zookeeper 컨테이너 cpu 리소스 request/limit (default: 1)

- ZOOKEEPER_RESOURCE_MEM  
  - Zookeeper 컨테이너 memory 리소스 request/limit (default: 1Gi)

- DEFAULT_TOPIC
  - Kafka 생성시 만들어질 토픽 (default: tmax)

## Publisher / Consumer 구현 예시

- Publisher : https://github.com/tmax-cloud/hyperauth/blob/main/src/main/java/com/tmax/hyperauth/eventlistener/kafka/producer/KafkaProducer.java
  - Simple : kubectl -n kafka run kafka-producer -ti --image=quay.io/strimzi/kafka:0.25.0-kafka-2.8.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list ${APP_NAME}-kafka-bootstrap.${NAMESPACE}:9092 --topic tmax
- Consumer : https://github.com/tmax-cloud/hyperauth/blob/main/src/main/java/com/tmax/hyperauth/eventlistener/kafka/consumer/EventConsumer.java
  - Simple : kubectl -n kafka run kafka-consumer -ti --image=quay.io/strimzi/kafka:0.25.0-kafka-2.8.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server ${APP_NAME}-kafka-bootstrap.${NAMESPACE}:9092 --topic tmax --from-beginning

### Grafana Dashboard 예시
- Kafka Exporter
  - https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/grafana-dashboards/strimzi-kafka-exporter.json
- Kafka Broker
  - https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/grafana-dashboards/strimzi-kafka.json
- Zookeeper
  - https://github.com/strimzi/strimzi-kafka-operator/blob/main/examples/metrics/grafana-dashboards/strimzi-zookeeper.json 
