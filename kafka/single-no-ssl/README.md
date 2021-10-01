# GitLab Template Guide

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
: Kafka App 제목

- IS_EXTERNAL
: kafka가 설치된 Cluster 외부에서 Pub/Sub 할 경우 : "true" ( 설치를 진행한 Namespace의 ${APP_NAME}-kafka service의 External IP:9092를 통해 통신가능  ex) 172.22.6.19:9092 ) 
: kafka가 설치왼 Cluster 내부에서 Pub/Sub 할 경우 : "false" ( ${APP_NAME}-kafka.${NAMESPACE}를 통해 통신가능 ex) test1-kafka.kafka:9092 )

- KAFKA_STORAGE
: Kafka용 PVC의 크기 (default: 5Gi)

- STORAGE_CLASS  
: Kafka용 PVC의 Storage Class (default: csi-cephfs-sc)

- KAFKA_RESOURCE_CPU  
: Kafka 컨테이너 cpu 리소스 request/limit (default: 1)

- KAFKA_RESOURCE_MEM  
: Kafka 컨테이너 memory 리소스 request/limit (default: 1Gi)

- ZOOKEEPER_RESOURCE_CPU  
: Zookeeper 컨테이너 cpu 리소스 request/limit (default: 1)

- ZOOKEEPER_RESOURCE_MEM  
: Zookeeper 컨테이너 memory 리소스 request/limit (default: 1Gi)

- DEFAULT_TOPIC
: Kafka 생성시 만들어질 토픽 (default: tmax)

## Publisher / Consumer 구현 예시

Publisher : https://github.com/tmax-cloud/hyperauth/blob/main/src/main/java/com/tmax/hyperauth/eventlistener/kafka/producer/KafkaProducer.java

Consumer : https://github.com/tmax-cloud/hyperauth/blob/main/src/main/java/com/tmax/hyperauth/eventlistener/kafka/consumer/EventConsumer.java

