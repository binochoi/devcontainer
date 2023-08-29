# 새 기기 혹은 업그레이드 할 기기의 환경을 세팅한다.

sudo sh ./installs/pwsh.sh
sudo pwsh ./scripts/installDeps.ps1 -path ./installs
sudo pwsh ./scripts/bootstrap.ps1
sudo mkdir -p /home/bino/.config/powershell/
sudo cp ./.profile.ps1 /home/bino/.config/powershell/Microsoft.PowerShell_profile.ps1
sudo chsh -s /opt/microsoft/powershell/7/pwsh bino