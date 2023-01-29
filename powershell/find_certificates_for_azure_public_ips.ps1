Get-AzSubscription | where {$_.name -notlike "*visual*"} | foreach -process {
Set-AzContext -Subscription $_.name | Out-Null
Set-AzContext -SubscriptionId $_.id | Out-null
$IPs += Get-AzPublicIPAddress | Select ipaddress, ResourceGroupName, Location
}

$ErrorActionPreference = "silentlycontinue"
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
$ips | foreach {
$ip = $_.ipaddress
$url = "https://$ip"
if ($ip -like "Not Assigned"){break}
$webRequest = [Net.HttpWebRequest]::Create($url)
$webRequest.Timeout = 100
try { $webRequest.GetResponse() | out-null } catch {}
$output = $null
$output = [PSCustomObject]@{
   ______IP_______ = $ip
   '_____Cert Start Date_____' = $webRequest.ServicePoint.Certificate.GetEffectiveDateString()
   '_____Cert End Date______' = $webRequest.ServicePoint.Certificate.GetExpirationDateString()
   '_____Cert Subject____________________' = $webRequest.ServicePoint.Certificate.subject
}
if ($output){
write-output $output
}
}