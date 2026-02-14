[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)][string]$isoPath
)
Set-Variable -Name isoPath -Value $isoPath -Scope Global

#install the windows adk
# https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install
$adkUrl = "https://go.microsoft.com/fwlink/?linkid=2289980"
$adkInstaller = "adksetup.exe"
Invoke-WebRequest -Uri $adkUrl -OutFile $adkInstaller
Start-Process -FilePath $adkInstaller -ArgumentList "/quiet /norestart" -Wait
remove-item .\adksetup.exe

#install pswindows update module
Install-Module -Name PSWindowsUpdate -Force -AllowClobber
Import-Module PSWindowsUpdate

#get catalog items for update search
Install-Module -Name MSCatalogLTS -force
Import-Module MSCatalogLTS