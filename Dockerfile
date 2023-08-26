FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-22.04

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN sudo apt-get update

ARG USERNAME=bino
ARG PASSWORD=asas
ARG UID=1001
ARG GID=$UID

RUN mkdir /devtools
COPY . /devtools

RUN sh /devtools/installs/pwsh.sh
# RUN pwsh /devtools/scripts/installDeps.ps1 -path ./installs

RUN pwsh -c Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN pwsh -c Install-Module -Scope AllUsers Bino.Bootstrap
RUN pwsh -c Install-Module -Scope AllUsers Bino.PersonalAliases
RUN pwsh -c Install-Module -Scope AllUsers QuiteShortAliases

RUN mkdir /workspaces
WORKDIR /workspaces
RUN sudo chown -R "$UID:$UID" /workspaces
##########################################
########## create new user ###############
##########################################
RUN pwsh /devtools/scripts/createUser.ps1 \
    -username $USERNAME \
    -pw $PASSWORD \
    -UID $UID \
    -GID $GID
USER $USERNAME

RUN mkdir -p /home/bino/.config/powershell/
COPY ./.profile.ps1 /home/bino/.config/powershell/Microsoft.PowerShell_profile.ps1
WORKDIR /workspaces
