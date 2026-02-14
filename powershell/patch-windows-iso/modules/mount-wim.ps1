$indexes = get-windowsimage -imagepath .\install.wim | select ImageIndex, ImageName
$indexes | Format-Table | Out-String | Write-Host
$selectedindex = read-host "The following images were found in the install.wim file. Please enter the index number of the image you want to mount"
try {
    New-Item -Path .\mount -ItemType Directory -ErrorAction Ignore | Out-Null
    mount-windowsimage -imagepath .\install.wim -index $selectedindex -Path .\mount
}
catch {
    Write-Error "Failed to mount the WIM image. Please ensure the index number is correct and you have the necessary permissions."
    write-error $_.Exception.Message
}