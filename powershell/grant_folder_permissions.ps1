$path = read-host -Prompt "Enter a local path to apply permissions. e.g. d:\path\abc"
$ModifySecuritygroupname = read-host -Prompt "Enter a user/group that will get modify permissions"
$ReadSecuritygroupname = read-host -Prompt "Enter a user/group that will get read permissions"

get-item $path\* | foreach {
$sharename = $_.Name

$modifyrule = new-object security.accesscontrol.filesystemaccessrule "$ModifySecuritygroupname", "Modify", 'ContainerInherit,ObjectInherit', 'None', allow
$readrule = new-object security.accesscontrol.filesystemaccessrule "$ReadSecuritygroupname", "ReadAndExecute", 'ContainerInherit,ObjectInherit', 'None', allow
$permissions = Get-Acl -Path $_
$permissions.AddAccessRule($modifyrule)
$permissions.AddAccessRule($readrule)
Write-Host granting $modifyrule.IdentityReference and $readrule.IdentityReference access to folder $sharename
Set-Acl -Path $_ -AclObject $permissions
}