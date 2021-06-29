# WAS CI/CD 파이프라인 예시 템플릿 사용 방법

## 신한 Pilot 용 가이드
> master 브랜치와 같지만 본 브랜치에는 checkfile 로직이 들어가 운영 중 소스코드 변조를 탐색해 pod를 재기동시킴 (각 was template의 liveness probe 참조)
> 다만, checkfile을 활성화하기 위해 Git Source의 최상위 path 아래 `.s2i/environment` 파일에 아래와 같은 행이 추가되어 있어야 함
> - Apache:  `CHECK_FILES=/opt/app-root/src`
> - Django:  `CHECK_FILES=/opt/app-root/src`
> - Nodejs:  `CHECK_FILES=/opt/app-root/src`
> - Tomcat:  `CHECK_FILES=/tomcat/webapps/`
> - Wildfly: `CHECK_FILES=/deployments`
```
CHECK_FILES=<변조 탐색할 파일 경로1>,<변조 탐색할 파일 경로2>,<변조 탐색할 파일 경로3 ...>
```

> TemplateInstance 생성 시 `CHECKFILE_DEST` 파라미터에 logstash 주소 입력

## 기본 제공 Pipeline Template
* WAS  
  TemplateInstance 생성 시 CI/CD를 위한 IntegrationConfig를 생성함.
    * [Apache](./apache/apache-template.yaml)
    * [Django](./django/django-template.yaml)
    * [Node.js](./nodejs/nodejs-template.yaml)
    * [Tomcat](./tomcat/tomcat-template.yaml)
    * [Wildfly](./wildfly/wildfly-template.yaml)

* WAS + DB  
  TemplateInstance 생성 시 DB Deployment 및 CI/CD를 위한 IntegrationConfig를 생성함.
    * [Node.js+MySQL](../was-db/nodejs-mysql-template.yaml)

### Template 구성
* Service for WAS Deployment
* ConfigMap for WAS Deployment
* CI/CD IntegrationConfig
* (WAS+DB Only) Secret for DB Connection (User ID/PW)
* (WAS+DB Only) Service for DB Deployment
* (WAS+DB Only) DB Deployment

### Template Input
* Parameter
    * `APP_NAME`: 어플리케이션 이름
    * `GIT_TYPE`: 소스 코드 Git 타입 (gitlab 또는 github)
    * `GIT_API_URL`: 소스 코드 Git API url (깃랩일 경우 깃랩 주소, 레포지토리 path 제외)
    * `GIT_REPOSITORY`: 소스 코드 Git 레포지토리 (e.g., root/TomcatMavenApp)
    * `GIT_TOKEN_SECRET` 소스 코드 Git 접근 토큰
    * `IMAGE_URL`: WAS+어플리케이션 이미지가 저장될 주소
    * `REGISTRY_SECRET_NAME`: 레지스트리 접근 Secret 이름 (.dockerconfigjson)
    * `WAS_PORT`: WAS 접근에 사용하는 포트 번호
    * `ServiceType`: WAS 서비스 타입 (ClusterIP/NodePort/LoadBalancer)
    * `PACKAGE_SERVER_URL`: 폐쇄망 내 패키지 서버 URL
    * `DEPLOY_ENV_JSON`: WAS Deployment에 추가될 추가 환경 변수
    * `DEPLOY_RESOURCE_CPU`: WAS Deployment 리소스 CPU
    * `DEPLOY_RESOURCE_CPU`: WAS Deployment 리소스 RAM
    * `CHECKFILE_DEST`: Checkfile 로그 남겨질 경로 (파일 or HTTP)

### CI/CD Pipeline 구성
1. S2I(Source-to-Image) Task
    1. S2I Build  
       : Source &rightarrow; Dockerfile.gen
    2. Buildah bud  
       : Dockerfile.gen &rightarrow; Application Image
    3. Buildah push  
       : Application Image &rightarrow; Remote Registry
2. Deploy Task
    1. Create YAML  
       : `deployment.yaml` 파일 생성
    2. Kubectl  
       : `deployment.yaml` 파일을 이용한 Deploy

## 예시
아래 예시는 Tomcat 어플리케이션에 대한 CI/CD 예시에 해당하며, 5가지 기본 제공 WAS에 대한 예시는 각 디렉토리에서 확인 가능.

1. Git Access Token 생성
    - For GitHub
        - Create a new bot account
        - Create an access token for the bot account  
          `https://github.com/settings/tokens > Generate a new token`  
          Scope:
            * repo
            * admin:repo_hook
            * read:user
            * user:email
    
    - For GitLab
        - Create a new bot account
        - Create an access token for the bot account
          `https://gitlab.com/-/profile/personal_access_tokens`  
          Scope:
            * api
            * read_user

2. Access Token 시크릿 생성
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: cicd-example-git-token
stringData:
  token: <TOKEN>
```

2. Git 레포지토리 생성

3. `ClusterRole`, S2I 태스크 생성 (Deployment 단계에서 사용)
```bash
kubectl apply -f https://raw.githubusercontent.com/tmax-cloud/catalog/master/was/_common/clusterrole.yaml
kubectl apply -f https://raw.githubusercontent.com/tmax-cloud/catalog/master/was/_common/task-s2i.yaml
```

4. `TemplateInstance` 생성
```yaml
apiVersion: tmax.io/v1
kind: TemplateInstance
metadata:
  name: tomcat-cicd-template-instance
  namespace: default
  annotations:
    template-version: 5.0.0
    tested-operator-version: v0.2.0
  labels:
    cicd-template-was: tomcat
spec:
  clustertemplate:
    metadata:
      name: tomcat-cicd-template
    parameters:
      - name: APP_NAME
        value: tomcat-sample-app
      - name: GIT_TYPE
        value: gitlab # gitlab 또는 github
      - name: GIT_API_URL
        value: http://<깃랩/깃헙 API URL> # e.g., http://172.22.11.13
      - name: GIT_REPOSITORY
        value: root/TomcatMavenApp # 레포지토리 Path
      - name: GIT_TOKEN_SECRET
        value: cicd-example-git-token
      - name: IMAGE_URL
        value: <이미지 URL> # 이미지 URL
      - name: REGISTRY_SECRET_NAME
        value: '' # Image Pull Secret
      - name: WAS_PORT
        value: 8080
      - name: SERVICE_TYPE
        value: LoadBalancer # ClusterIP/NodePort/LoadBalancer
      - name: PACKAGE_SERVER_URL
        value: ''
      - name: DEPLOY_ENV_JSON
        value: "{}"
      - name: DEPLOY_RESOURCE_CPU
        value: 500m
      - name: DEPLOY_RESOURCE_MEM
        value: 500Mi
      - name: CHECKFILE_DEST
        value: http://logstash.url:8080 # Or, /var/log/checkfile.log, ...

```

5. Git 소스 코드 Push
```bash
# 샘플 Git 클론&Pull
## Apache: https://github.com/microsoft/project-html-website
## Django: https://github.com/sunghyunkim3/django-realworld-example-app
## Nodejs: https://github.com/sunghyunkim3/nodejs-rest-http
## Tomcat/Wildfly: https://github.com/sunghyunkim3/TomcatMavenApp
## Nodejs+MySQL: https://github.com/sunghyunkim3/nodejs-mysql-crud
git clone https://github.com/sunghyunkim3/TomcatMavenApp
cd TomcatMavenApp
git remote add source http://<깃랩/깃헙 API URL>/<깃 레포지토리 Path>
git push source master
```

6. IntegrationJob/PipelineRun 진행사항 확인
```bash
kubectl get integrationjob
kubectl get pipelinerun
```

7. WAS Service 확인
```bash
kubectl -n default get svc tomcat-sample-app-service
```

8. PipelineRun 이 성공적으로 완료되면 WAS Deployment 구동 확인, 서비스 접속해 확인
```bash
kubectl -n default get deployment 
```

## 주의 사항
* Tomcat/Wildfly의 경우, S2I Task에서 `WAR_NAME`이라는 환경변수 지정 필요.
  Git 소스 최상위 `.s2i/environment` 파일에 `WAR_NAME=<이름>` 명시 ([참고](https://github.com/openshift/source-to-image#build-workflow))
