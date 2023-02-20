param (
    [Parameter(Mandatory=$true)] [string]$domainname,
    [Parameter(Mandatory=$true)] [string]$username,
    [Parameter(Mandatory=$true)] [string]$dnsip,
    [Parameter(Mandatory=$true)] [securestring]$password
)
$adapter = Get-NetAdapter -Name "Ethernet" 
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)

Set-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex -ServerAddresses ($dnsip) # Replace with the IP addresses of your DNS servers
Get-DnsClientServerAddress -InterfaceIndex $adapter.ifIndex
Set-CertificateAutoEnrollmentPolicy -PolicyState Enabled -EnableTemplateCheck -EnableMyStoreManagement -context Machine
Add-Computer -DomainName $domainname -Credential $cred -Restart