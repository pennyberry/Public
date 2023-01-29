Get-AzSubscription | where {$_.name -notlike "*visual*"} | foreach -process {
Set-AzContext -Subscription $_.name | Out-Null
Get-AzKeyVault | foreach -Process {
$secret = Get-AzKeyVaultSecret -VaultName $_.vaultname -AsPlainText
$secret | foreach -Process {
$value = Get-AzKeyVaultSecret -VaultName $_.VaultName -AsPlainText -Name $_.Name
$table = [pscustomobject] @{
secretname = $_.Name
VaultName = $_.VaultName
Expiration = $_.Expires
Value = $value
}
$table | Export-Csv $env:USERPROFILE\desktop\export.csv -Append -NoTypeInformation
}
}
}