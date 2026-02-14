#mount the iso
try {
    $mountResult = Mount-DiskImage -ImagePath $isoPath -PassThru | Get-Volume 
}
catch {
    Write-Error "Failed to mount the ISO image. Please ensure the path is correct and you have the necessary permissions."
    write-error $_.Exception.Message
    exit 1
}

write-host "ISO mounted successfully at drive letter: $($mountResult.DriveLetter):"