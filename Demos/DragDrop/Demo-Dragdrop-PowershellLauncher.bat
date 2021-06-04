@Echo off
pushd %~dp0
powershell.exe -NoProfile -executionPolicy Bypass -File %~dp0\Demo-Dragdrop-Powershell.ps1 %*

pause
