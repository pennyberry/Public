param (
    [Parameter(Mandatory=$true)] [string]$domainname,
    [Parameter(Mandatory=$true)] [string]$netbiosname,
    [Parameter(Mandatory=$true)] [securestring]$RestorePW
)
Install-ADDSForest -DomainName $domainname -InstallDNS:$false -CreateDNSDelegation:$false -DomainMode WinThreshold -ForestMode WinThreshold -DomainNetbiosName $netbiosname -SafeModeAdministratorPassword $RestorePW -Confirm:$false