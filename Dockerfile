FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-22.04

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# install gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-cli -y
# install ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok

RUN sudo apt-get update

# install pwsh:latest
RUN sudo apt-get install -y wget apt-transport-https software-properties-common ; wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb" ; sudo dpkg -i packages-microsoft-prod.deb ; rm packages-microsoft-prod.deb ; sudo apt-get update ; sudo apt-get install -y powershell

# install docker
RUN sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN sudo apt update; sudo apt install -y docker-ce docker-ce-cli containerd.io

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
RUN apt install -y nodejs
RUN npm install -g yarn

RUN pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN pwsh -c Install-Module -Scope AllUsers Bino.Bootstrap
RUN pwsh -c Install-Module -Scope AllUsers Bino.PersonalAliases
RUN pwsh -c Install-Module -Scope AllUsers QuiteShortAliases

ARG USERNAME=bino
ARG PASSWORD=asas
ARG UID=1001
ARG GID=$UID

WORKDIR /workspaces
RUN sudo chown -R "$UID:$UID" /workspaces
##########################################
########## create new user ###############
##########################################
RUN sudo groupadd --gid $GID $USERNAME
RUN sudo useradd --uid $UID --gid $GID -ms $(which pwsh) $USERNAME
RUN sudo echo "$USERNAME:$PASSWORD" | chpasswd
RUN sudo echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USERNAME \
&& sudo chmod 0440 /etc/sudoers.d/$USERNAME
RUN sudo usermod -aG sudo $USERNAME
USER $USERNAME

RUN mkdir -p /home/bino/.config/powershell/
COPY ./.profile.ps1 /home/bino/.config/powershell/Microsoft.PowerShell_profile.ps1
WORKDIR /workspaces
