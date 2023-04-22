$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64' -OutFile c:\temp\vscode.exe
Start-Process 'C:\temp\vscode.exe' -ArgumentList '/silent /norestart' -Wait