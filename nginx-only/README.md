# WAS docker hub official `nginx` image with template

## Prerequisites
* k8s cluster

## Template parameter
* NGINX_HOST : nginx의 hostname (`foo.com`)
* SERVICE_TYPE : service 객체의 type (ClusterIP/NodePort/LoadBalancer)
* RESOURCE_CPU : was의 필요 CPU (500m)
* RESOURCE_MEM : was의 필요 memory (500Mi)


## 생성 예시
### For GUI
`mskim`이라는 `namespace`생성 이후 scenario
1. 사용자 또는 admin 계정으로 hypercloud console접속 <br/>
   ![login](https://user-images.githubusercontent.com/22141521/143807368-f9f1791c-1300-4d36-8cbf-25f4b556752f.png)
   <br/>
   <br/>
2. console(개발자) 항목 선택
   ![1](https://user-images.githubusercontent.com/22141521/143808755-1e0f9106-cc4c-4d61-ae42-9ff90e8528b2.png)

3. service catalog tab 선택, cluster template tab 선택, 우측 상단 cluster template 생성 button click
   ![2](https://user-images.githubusercontent.com/22141521/143808756-f8d7ac0a-1b7d-497e-a37d-3b571a6e2414.png)
    
4. nginx-template 내용 복사, 붙여넣기 후 생성 button click
   ![3](https://user-images.githubusercontent.com/22141521/143808751-2c9d3d54-0519-4314-b766-eb022d7ee9a9.png)

   ![4](https://user-images.githubusercontent.com/22141521/143808752-24371a41-9e0b-4dc2-8eb0-a89fcabb4a66.png)

5. template instance tab 선택, 우측 상단 template instance 생성 button click
   ![5](https://user-images.githubusercontent.com/22141521/143809988-8f7e766d-d12a-4575-8a3e-0a37b672f3f8.png)

6. cluster template 유형 선택, nginx-only-template 선택
   ![6](https://user-images.githubusercontent.com/22141521/143809983-5be8a4bb-c7b3-4622-88a9-901f240b0ecb.png)

7. parameter 값 입력 후 생성 button click
   ![7](https://user-images.githubusercontent.com/22141521/143809986-446837cc-4ce1-45be-9040-11c867a747aa.png)

   ![8](https://user-images.githubusercontent.com/22141521/143809987-efecdfd3-32bc-4700-a635-1abbedf72fbe.png)

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

## 삭제 예시
### For GUI
1. cluster template 삭제
![del1](https://user-images.githubusercontent.com/22141521/143810737-f295c4ec-b856-4ff5-8585-e0794e4a838b.png)
2. template instance 삭제
![del2](https://user-images.githubusercontent.com/22141521/143810740-7ae349d6-61cd-4b89-a6c4-64d1bfbc116e.png)

### For CLI
1. cluster template 삭제
``` bash
kubectl -n {만든 namespace명} delete -f nginx-template.yaml
```
2. cluster instance 삭제
``` bash
kubectl -n {만든 namespace명} delete -f nginx-instance.yaml
```

### 기타 생성 확인 가능 사항
LoadBalance type으로 생성한 service 객체의 EXTERNAL-IP를 url로 browser 접속 후 확인
