FROM mcr.microsoft.com/vscode/devcontainers/base:0-ubuntu-22.04

ARG USERNAME=bino
ARG PASSWORD=asas
ARG UID=1001
ARG GID=$UID

RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN sudo apt update
RUN sudo apt install sudo

RUN mkdir /devtools
WORKDIR /devtools
COPY . .

RUN sh ./installs/pwsh.sh
RUN pwsh ./scripts/createUser.ps1 \
    -username $USERNAME \
    -pw $PASSWORD \
    -UID $UID \
    -GID $GID
RUN sudo sh ./setup.sh

RUN mkdir /workspaces
RUN sudo chown -R "$UID:$UID" /workspaces
USER $USERNAME

WORKDIR /workspaces
