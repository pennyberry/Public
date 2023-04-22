Invoke-WebRequest -Uri https://download.sysinternals.com/files/RDCMan.zip -OutFile c:\temp\RDCMan.zip;
Expand-Archive -Path c:\temp\RDCMan.zip -destination c:\temp\RDCMan -force;
Move-Item c:\temp\RDCMan\RDCMan.exe -Destination 'C:\Users\Public\Desktop\Remote Desktop Connection Manager.exe' -Force;
$ProgressPreference = 'SilentlyContinue' ; Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64' -OutFile c:\temp\vscode.exe;
Start-Process 'C:\temp\vscode.exe' -ArgumentList '/silent /norestart' -Wait