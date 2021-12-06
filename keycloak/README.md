# Keycloak Template Guide

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
  - Keycloak App 제목

- KEYCLOAK_VERSION
  - Keycloak Container Image Version
  - https://quay.io/repository/keycloak/keycloak?tab=tags 참고

- KEYCLOAK_STORAGE
  - Postgresql용 PVC의 크기 (default: 5Gi)

- STORAGE_CLASS  
  - Postgresql용 PVC의 Storage Class (default: csi-cephfs-sc)

- KEYCLOAK_RESOURCE_CPU  
  - Keycloak 컨테이너 cpu 리소스 request/limit (default: 1)

- KEYCLOAK_RESOURCE_MEM  
  - Keycloak 컨테이너 memory 리소스 request/limit (default: 1Gi)

- POSTGRESQL_RESOURCE_CPU  
  - Postgresql 컨테이너 cpu 리소스 request/limit (default: 1)

- POSTGRESQL_RESOURCE_MEM  
  - Postgresql 컨테이너 memory 리소스 request/limit (default: 1Gi)

## Keycloak Admin Console 접속
- {KEYCLOAK_EXTERNAL_IP} = kubectl describe service ${APP_NAME}-keycloak -n {KEYCLOAK_NAMESPACE} | grep 'LoadBalancer Ingress' | cut -d ' ' -f7
- https://{KEYCLOAK_EXTERNAL_IP} 로 Keycloak Admin Console 접속

