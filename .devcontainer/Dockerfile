# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.166.1/containers/ubuntu/.devcontainer/base.Dockerfile

# [Choice] Ubuntu version: bionic, focal
ARG VARIANT="bionic"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

# install node via nvm
ENV NODE_VERSION="12.22.7"
    
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version
# required for access to node-gyp
RUN npm config set user 0

# install various npm packages
RUN npm install -g \
    serverless \
    serverless-pseudo-parameters \
    db-migrate \
    db-migrate-mysql \
    anypoint-cli \
    migrate-mongo

# install apt packages
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    software-properties-common \
    expect \
    jq \
    pwgen


# install github cli
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y

# install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

# install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && sudo apt update && sudo apt install terraform -y

# Install Ansible
RUN sudo add-apt-repository --yes --update ppa:ansible/ansible \
    && sudo apt install ansible -y

# json2hcl
RUN curl -SsL https://github.com/kvz/json2hcl/releases/download/v0.0.6/json2hcl_v0.0.6_linux_amd64 \
    | sudo tee /usr/local/bin/json2hcl > /dev/null && sudo chmod 755 /usr/local/bin/json2hcl && json2hcl -version

ARG REGULA_VERSION="1.5.0"
# json2hcl
RUN wget "https://github.com/fugue/regula/releases/download/v${REGULA_VERSION}/regula_${REGULA_VERSION}_Linux_x86_64.tar.gz" && \
    tar -xf "regula_${REGULA_VERSION}_Linux_x86_64.tar.gz" && \
    mv regula /usr/local/bin && \
    rm "regula_${REGULA_VERSION}_Linux_x86_64.tar.gz" && \
    echo hello

# load bashrc
ADD .bashrc /root/.bashrc