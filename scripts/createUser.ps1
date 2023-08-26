param(
    [string]$username,
    [string]$pw,
    [string]$GID,
    [string]$UID
)

sudo groupadd --gid $GID $username
sudo useradd --uid $UID --gid $GID -ms $(which pwsh) $username
sudo echo ($username + ':' + $pw) | chpasswd
sudo echo "$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$username
sudo chmod 0440 /etc/sudoers.d/$username
sudo usermod -aG sudo $username