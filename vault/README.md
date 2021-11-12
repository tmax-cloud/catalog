# Vault Template Guide

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
  - Vault App 제목

- NAMESPACE
  - Vault 가 설치될 Namespace

- KAFKA_STORAGE
  - Kafka용 PVC의 크기 (default: 5Gi)

- SERVICE_TYPE
  - Vault Server Service Type (default: ClusterIP) ClusterIP / LoadBalancer
  - LaodBalancer 선택시 Vault Web UI 사용가능

- STORAGE_CLASS  
  - Vault용 PVC의 Storage Class (default: csi-cephfs-sc)

- VAULT_RESOURCE_CPU  
  - Vault 컨테이너 cpu 리소스 request/limit (default: 250m)

- VAULT_RESOURCE_MEM  
  - Vault 컨테이너 memory 리소스 request/limit (default: 256Mi)

## VAULt Root Token 확인
- Vault Pod Log 확인

## VAULT Web UI 접속
- Vault Server Service LoadBalancer IP 확인
- http://{Vault_external_ip}:8200 으로 접속
- Log에서 확인한 oot_token 사용
