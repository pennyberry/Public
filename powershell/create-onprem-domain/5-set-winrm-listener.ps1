$hostname = hostname
certutil -pulse
$thumbprint = (Get-ChildItem "Cert:\LocalMachine\My" | where {$_.Subject -like "*$hostname*"}).thumbprint
Enable-PSRemoting -Force -SkipNetworkProfileCheck
New-Item -Path WSMan:\Localhost\Listener -Transport HTTPS -Address * -CertificateThumbprint $thumbprint -Force
Set-NetFirewallProfile -Profile Domain -Enabled False