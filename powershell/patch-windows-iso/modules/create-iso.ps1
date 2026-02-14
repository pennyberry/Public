New-Item -Path .\source -ItemType Directory -Force
Copy-Item -Path d:\* -Destination .\source\ -Recurse -Exclude "install.wim"
Copy-Item -Path .\install.wim -Destination .\source\sources  -Force

$etfsboot = get-item .\source\boot\etfsboot.com
$efisys = get-item .\source\efi\microsoft\boot\efisys.bin
$source = get-item .\source\
$nameofiso = "$(Get-Date -Format 'yyyy-MM-dd')-patched.iso"

try {
    $oscdimg = "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\oscdimg.exe"
    start-process -FilePath $oscdimg -ArgumentList "-m -o -u2 -udfver102 -bootdata:2#p0,e,b$($etfsboot.FullName)#pEF,e,b$($efisys.FullName) $($source.FullName) $nameofiso" -Wait -noNewWindow
    remove-item .\install.wim
    remove-item .\source -Recurse -Force
}
catch {
    Write-Host "Error creating ISO: $_.Exception.Message"
}
