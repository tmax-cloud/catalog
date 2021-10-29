# java-source2build 사용 가이드

## 구성 요소 및 버전
* java 8 ([jdk-8u212](https://www.oracle.com/java/technologies/javase/8u212-relnotes.html))
* maven ([apache-maven-3.8.3](https://dlcdn.apache.org/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz))
* gradle ([gradle-7.2](https://services.gradle.org/distributions/gradle-7.2-bin.zip))

## Prerequisites

### git repository

* java-source2build 사용하기 전 아래의 과정을 통해 사용자의 git repository 정보를 준비한다.

  * Case 1. 사용자의 git repository 가 public 인 경우
  
    ![image](figure/public_repo.png)
  
  * Case 2. 사용자의 git repository 가 private 인 경우 (Token 필요)
   
    ![image](figure/private_repo_1.png)

    ![image](figure/private_repo_2.png)

    ![image](figure/private_repo_3.png)

    ![image](figure/private_repo_4.png)

    ![image](figure/private_repo_5.png)

    ![image](figure/private_repo_6.png)

    * Case 2-1. github의 user ID
  
      ![image](figure/userID.png)


## Parameter 설명

* POD_NAME
  * Pod의 이름
  * Default value: java-s2b-pod
  
* GIT_REPO
  * 사용자의 git repository 
  * 위의 Prerequisites: Case 1 참조
  
* GIT_TOKEN
  * **private repository**일 경우에만 입력
  * private repository를 git clone 하기위한 token
  * 위의 Prerequisites: Case 2 참조
  
* GIT_ID
  * **private repository**일 경우에만 입력
  * github의 user ID
  * Prerequisites: Case 2-1 참조

* USR_BUILD_CMD
  * 빌드 시 필요한 command
  * build command 입력시 **각 커맨드 뒤에 꼭 ';' 붙여야 합니다**
  * <예시> USR_BUILD_CMD = mvn compile; mvn package; mvn install;

* USR_RUN_CMD
  * 실행 시 필요한 command
  * run command 입력시 **각 커맨드 뒤에 꼭 ';' 붙여야 합니다**
  * <예시> USR_RUN_CMD = java -cp hello-world.jar hello.HelloWorld;

