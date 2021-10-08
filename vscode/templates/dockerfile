FROM codercom/code-server

RUN sudo apt update && \
    sudo apt install -y wget build-essential &&  sudo apt install unzip zip

# install JDK & MAVEN
RUN sudo apt install -y default-jdk
RUN sudo apt-get install -y maven

# install SDKMAN
RUN curl -s https://get.sdkman.io | bash
RUN /bin/bash -c "source /home/coder/.sdkman/bin/sdkman-init.sh; sdk version; sdk install springboot; sdk install gradle;"


# install extenions
RUN code-server --install-extension vscjava.vscode-java-pack &&\
    code-server --install-extension pivotal.vscode-boot-dev-pack


CMD ["code-server", "--auth", "none", "--bind-addr", "0.0.0.0:8080", "."]
