# VS Code Template Guide


1. Template 생성
```bash
kubectl apply -f template.yaml
```

2. TemplateInstance 생성
```bash
kubectl apply -f instance.yaml
```
apiVersion: tmax.io/v1
kind: TemplateInstance
metadata:
name: vscode-template-instance
spec:
clustertemplate:
metadata:
name: vscode-template
parameters:
- name: APP_NAME
value: vscode-test-deploy
- name: STORAGE
value: 30Gi
- name: STORAGE_CLASS
value: csi-cephfs-sc
- name: SERVICE_TYPE
value: LoadBalancer

## Parameter 설명
- APP_NAME
: VS Code용 Deployment 제목

- STORAGE
: VS Code용 PersistentVolumeClaim 크기

- STORAGE_CLASS
: VS Code용 PVC의 Storage Class (default: csi-cephfs-sc)

- SERVICE_TYPE
: VS Code용 서비스 종류 (ClusterIP/NodePort/LoadBalancer/Ingress)
  - TODO : INGRESS 지원