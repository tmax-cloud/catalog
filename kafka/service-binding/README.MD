# Strimzi TLS / Non-TLS ServiceBinding Kafka Template Guide

## Prerequisite
- https://github.com/tmax-cloud/install-kafka-operator를 통해 cluster operator, bindable operator가 설치 되어 있어야 합니다.
- RedHat Service Binding Operator가 설치되어있어야 합니다.  
  (https://github.com/redhat-developer/service-binding-operator/releases/latest/download/release.yaml)
- Service Binding Operator에 kafka.strimzi.io/v1beta2 Kafka ClusterRole을 추가합니다.  
  ```bash
  kubectl apply -f strimzi-kafka-sbo-clusterrole.yaml
  ```

## Description
- Strimzi kafka Operator를 통해 Internal, Non-tls/tls 설정이 가능한 kafka template 입니다
- Service Binding Operator를 통해 kafka 연결정보를 연결하고자하는 application 내부에 자동 주입시킬 수 있습니다.

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
  - Zookeeper용 PVC의 크기 (default: 5Gi)

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

## Service Binding 연결
- ServiceBinding resource를 사용하여 kafka 연결정보를 연결하고자하는 application 내부로 주입합니다.  
  [strimzi-kafka-service-binding.yaml]  
  
```bash
apiVersion: binding.operators.coreos.com/v1alpha1
kind: ServiceBinding
metadata:
  name: kafka-service-binding
spec:
  bindAsFiles: true                       ## TLS 연결인 경우 true, NON-TLS 인 경우 false
  namingStrategy: '{{ .name | upper }}'
  application:
    version: v1                           ##연결하고자 하는 resource(application) version
    group: apps                           ##연결하고자 하는 resource(application) group
    kind: StatefulSet                     ##연결하고자 하는 resource(application) kind 지정
    name: tomcat-example                  ##연결하고자 하는 resource(application) name 지정
  services:
  - version: v1beta2
    group: kafka.strimzi.io
    kind: Kafka
    name: ${APP_NAME}                     ##kafka app name 지정
```

```bash
kubectl apply -f strimzi-kafka-service-binding.yaml
```

- 정상적으로 binding이 되면 아래와 같이 확인 가능합니다.
```
NAME                    READY     REASON              AGE
kafka-service-binding   True      ApplicationsBound   21h
```

- 생성되는 ${APP_NAME}-service-binding-credentials Secret 의 key/value가 연결하고자 하는 application 내부로 주입됩니다.  

## Service-Binding-credential Secret Key/value 설명  
  #### NON-TLS
  ###### *Application의 container env로 주입*
  - PLAIN_INTERNAL_BOOSTRAP_SERVERS
    - kafka bootstrap server ip adresss  
  #### TLS  
  ###### *Application 내부 file로 주입*  
  - TLS_INTERNAL_BOOSTRAP_SERVERS
    - kafka bootstrap server ip adresss
  - ca.p12
    - pkcs#12 archive file + public key
  - ca.password
    - ca.p12 인증서 password
  - ca.crt
    - cluster certificate

## 추가) TLS 연결
- 단방향 TLS 인증으로 kafka와 application을 연결합니다.
### Prerequisite
- serviceBinding.yaml의 bindAsFile 항목이 true 로 설정되어있어야 합니다.  

### 인증서 등록 밎 설정하기
1. application 내부의 /binding/${serviceBinding}/ 폴더에 binding 연결정보 파일이 생성됩니다.  
2. CA.CRT 파일로 truststore를 생성, certificate를 등록합니다.  
   ex). java keytool  
   ```bash
   keytool -import -alias [truststore 별칭] -file CA.CRT -keystore [truststore이름] -storetype [JKS/PKCS12]
   ```
   입력 후 truststore password 설정  
3. 구성한 kafka consumer/producer 정보에 truststore location, type을 추가합니다.  
   ex). springboot/application.yml  
   - trust-store-location: /WEB-INF/classes/sslkey/client.truststore.jks
   - trust-store-password: tmax@23
   - trust-store-type: JKS  
4. TLS_INTERNAL_BOOTSTRAP_SERVER 파일 내부의 server ip를 참조하여 kafka에 연결합니다.
