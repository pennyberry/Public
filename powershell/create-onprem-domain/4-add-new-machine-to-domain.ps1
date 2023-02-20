param (
    [string]$domainname,
    [string]$username,
    [securestring]$password
)
$cred = New-Object System.Management.Automation.PSCredential ($username, $password)
Add-Computer -DomainName $domainname -Credential $cred -Restart