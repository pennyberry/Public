param (
    [string]$domainname,
    [string]$netbiosname,
    [securestring]$RestorePW
)
Install-ADDSForest -DomainName $domainname -InstallDNS:$false -CreateDNSDelegation:$false -DomainMode WinThreshold -ForestMode WinThreshold -DomainNetbiosName $netbiosname -SafeModeAdministratorPassword $RestorePW -Confirm:$false