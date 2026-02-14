
#check if the script is running with admin privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as an administrator. Please restart PowerShell with elevated privileges."
    exit
}
# Get the script's directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$modulesDir = Join-Path $scriptDir "modules"


& $modulesDir\install-dependencies.ps1
& $modulesDir\mount-image.ps1
& $modulesDir\extract-wim.ps1
& $modulesDir\mount-wim.ps1
& $modulesDir\patch-wim.ps1
& $modulesDir\unmount-wim.ps1
& $modulesDir\create-iso.ps1
& $modulesDir\unmount-image.ps1