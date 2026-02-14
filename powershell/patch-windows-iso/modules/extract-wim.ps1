$letter = get-diskimage -ImagePath $isoPath | get-volume
copy-item -Path "$($letter.DriveLetter):\sources\install.wim" -Destination .\install.wim
#unset readonly attribute if set
if ((get-item .\install.wim).IsReadOnly) {
    (get-item .\install.wim).IsReadOnly = $false
}