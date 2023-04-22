Invoke-WebRequest -Uri https://download.sysinternals.com/files/RDCMan.zip -OutFile c:\temp\RDCMan.zip
Expand-Archive -Path c:\temp\RDCMan.zip -destination c:\temp\RDCMan -force
Move-Item c:\temp\RDCMan\RDCMan.exe -Destination 'C:\Users\Public\Desktop\Remote Desktop Connection Manager.exe' -Force