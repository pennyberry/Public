[cmdletbinding()]
param (
    [Parameter(Mandatory=$true)][string]$isoPath
)
Set-Variable -Name isoPath -Value $isoPath -Scope Global

#install the windows adk
#check if already installed
$oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
if (Test-Path $oscdimg) {}
else {
    # https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install
    $adkUrl = "https://go.microsoft.com/fwlink/?linkid=2289980"
    $adkInstaller = "adksetup.exe"
    Invoke-WebRequest -Uri $adkUrl -OutFile $adkInstaller
    Start-Process -FilePath $adkInstaller -ArgumentList "/quiet /norestart" -Wait
    remove-item .\adksetup.exe
}

#install pswindows update module
if (Get-Module -ListAvailable -Name PSWindowsUpdate) {}
else {
    Install-Module -Name PSWindowsUpdate -Force -AllowClobber
}
Import-Module PSWindowsUpdate


#get catalog items for update search
if (Get-Module -ListAvailable -Name MSCatalogLTS) {
}
else {
    Install-Module -Name MSCatalogLTS -force
}
Import-Module MSCatalogLTS