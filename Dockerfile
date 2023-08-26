FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-22.04

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime

ARG USERNAME=bino
ARG PASSWORD=asas
ARG UID=1001
ARG GID=$UID

RUN mkdir -p /home/bino/devtools
COPY . /home/bino/devtools
WORKDIR /home/bino/devtools

RUN sudo apt-get update
RUN sh ./installs/pwsh.sh

RUN pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN pwsh -c Install-Module -Scope AllUsers Bino.Bootstrap
RUN pwsh -c Install-Module -Scope AllUsers Bino.PersonalAliases
RUN pwsh -c Install-Module -Scope AllUsers QuiteShortAliases

RUN mkdir /workspaces
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

RUN mkdir -p /home/bino/.config/powershell/
COPY ./.profile.ps1 /home/bino/.config/powershell/Microsoft.PowerShell_profile.ps1

USER $USERNAME
WORKDIR /workspaces
