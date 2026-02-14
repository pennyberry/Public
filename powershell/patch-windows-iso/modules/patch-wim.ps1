#get version of windows
$windowsversion = (get-item .\mount\windows\system32\ntoskrnl.exe).VersionInfo.ProductVersion

try {
    $availableUpdates = Get-MSCatalogUpdate -Search "26200" | Select-Object -First 1
    $availableUpdates | Save-MSCatalogUpdate -Destination ".\" -DownloadAll    
}
catch {
    Write-Host "No updates found for this version of windows. Please check the version and try again."
    write-host "$_.Exception.Message"
}

#patch the wim with the downloaded updates
get-item .\*.msu | ForEach-Object {
    $update = $_.FullName
    Write-Host "Installing update: $update"
    Add-WindowsPackage -Path .\mount -PackagePath $update    
}

remove-item .\*.msu