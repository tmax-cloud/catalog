# WAS nginx with docker hub template

## Prerequisites
* k8s cluster

## Template parameter
* NGINX_HOST : nginx의 hostname (`foo.com`)
* SERVICE_TYPE : service 객체의 type (ClusterIP/NodePort/LoadBalancer)
* RESOURCE_CPU : was의 필요 CPU (500m)
* RESOURCE_MEM : was의 필요 memory (500Mi)


## 생성 예시
### For GUI
1. 사용자 또는 admin 계정으로 hypercloud console접속
2. console(개발자) 항목
    * service catalog tab click
    * 우측 상단 cluster template 생성 button click
    * nginx-template 내용 복사, 붙여넣기 후 생성 button click
    * template instance tab click
    * 우측 상단 template instance 생성 button click
    * cluster template 유형 선택, nginx-only-template 선택, parameter 값 입력 후 생성 button click

### For CLI
"{}"는 custom 가능한 항목
1. namespace
    * 적용시 논리적 격리를 위한 생성
    ``` bash
    kubectl create namespace {원하는 이름}
    ```
    * 확인
    ``` bash
    kubectl get namespace
    ```

2. cluster template
    * 생성
    ``` bash
    kubectl apply -f nginx-template.yaml
    ```
    * 확인
    ``` bash
    kubectl get clustertemplate
    ```

3. template instance
    * 생성 : nginx-instance.yaml의 parameter들을 사용자가 원하는 값으로 변경 후 file 저장, 만든 namespace에 대해 하기 명령어 적용. 
    ``` bash
    kubectl -n {만든 namespace명} apply -f nginx-instance.yaml
    ```

    * 확인
    ``` bash
    kubctl -n {만든 namespace명} get templateinstance nginx-template-instance
    ```
