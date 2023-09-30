# 새 기기 혹은 업그레이드 할 기기의 환경을 세팅한다.

if [ "$USER" != "root" ]; then
    echo "이 스크립트는 root 권한이 필요함."
    exit 1
fi

sudo sh ./installs/pwsh.sh
sudo pwsh ./scripts/installDeps.ps1 -path ./installs
sudo pwsh ./scripts/bootstrap.ps1
sudo mkdir -p /home/$SUDO_USER/.config/powershell/
sudo cp ./.profile.ps1 /home/$SUDO_USER/.config/powershell/Microsoft.PowerShell_profile.ps1
sudo chsh -s /opt/microsoft/powershell/7/pwsh $SUDO_USER