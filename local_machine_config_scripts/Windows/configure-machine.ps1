start-transcript c:\temp\transcript.txt
$hypervstate = (Get-WindowsOptionalFeature -online -FeatureName Microsoft-Hyper-V).State
if ($hypervstate -ne "Enabled" ) {
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -norestart   
}
$adstate = (Get-WindowsCapability -online -Name Rsat.ActiveDirectory.DS-LDS.Tools*).State
if ($adstate -ne "Installed" ) {
    Add-WindowsCapability -Online -Name Rsat.ActiveDirectory.DS-LDS.Tools*   
}

if(-Not (test-path 'C:\Users\Public\Desktop\Remote Desktop Connection Manager.exe')) { 
    Invoke-WebRequest -Uri https://download.sysinternals.com/files/RDCMan.zip -OutFile c:\temp\RDCMan.zip
    Expand-Archive -Path c:\temp\RDCMan.zip -destination c:\temp\RDCMan -force
    Move-Item c:\temp\RDCMan\RDCMan.exe -Destination 'C:\Users\Public\Desktop\Remote Desktop Connection Manager.exe' -Force
}
if (-Not (get-package "Microsoft Visual Studio Code")) {
    $ProgressPreference = 'SilentlyContinue' ; Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64' -OutFile c:\temp\vscode.exe
    Start-Process 'C:\temp\vscode.exe' -ArgumentList '/silent /norestart'
}

stop-transcript