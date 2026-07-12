#this script will upload all gitignored env-vars.env files to vault for backup. It will prompt for the repo path and vault token.

$ErrorActionPreference = "Stop"

#$repoRoot = git rev-parse --show-toplevel
$repoRoot = Read-Host "Enter the repository path to upload env-vars.env files to vault - e.g. C:\Users\...\..."
$repoName = Split-Path $repoRoot -Leaf
$vaultBase = "$repoName"

# 
$vaultAddress = Read-Host "Enter your vault address - https://your-vault-address.domain.tld"
$env:VAULT_ADDR = $vaultAddress
#login to vault
$vaultToken = Read-Host "Enter your vault token - login to vault with oidc - top right click copy token..."
vault login $vaultToken


Push-Location $repoRoot
try {
    # Find gitignored env-vars.env files
    $files = git ls-files --others --ignored --exclude-standard -- '**/env-vars.env'

    if (-not $files) {
        Write-Host "No gitignored env-vars.env files found."
        return
    }

    foreach ($f in $files) {
        $vaultPath = "$vaultBase/$($f -replace '\\','/')"
        Write-Host "Backing up: $f -> $vaultPath"
        vault kv put -mount=kv $vaultPath "content=@$f"
    }
}
finally {
    Pop-Location
}