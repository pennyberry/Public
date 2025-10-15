<#
.SYNOPSIS
    Load environment variables from env-vars.env in the same folder.

.DESCRIPTION
    Supports lines like:
        KEY=VALUE
        export KEY="value with spaces"
        # comments and blank lines are ignored
    By default sets variables in the Process scope. Use -Scope User to persist to user environment.

#>

param(
        [ValidateSet('Process','User','Machine')]
        [string]$Scope = 'Process',
        [switch]$Verbose
)

# locate env file next to this script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$envFile = Join-Path $scriptDir 'env-vars.env'

if (-not (Test-Path $envFile)) {
        Write-Error "env-vars.env not found in $scriptDir"
        exit 1
}

Get-Content -Raw $envFile -ErrorAction Stop | ForEach-Object {
        $content = $_
        foreach ($rawLine in $content -split "`r?`n") {
                $line = $rawLine.Trim()
                if ([string]::IsNullOrWhiteSpace($line) -or $line.StartsWith('#') -or $line.StartsWith(';')) { continue }

                # match optional "export ", KEY, =, then value (value may contain =)
                if ($line -match '^(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)$') {
                        $name = $matches[1]
                        $valuePart = $matches[2]

                        # If value is quoted, preserve inner content; otherwise strip inline comment after unquoted value
                        if ($valuePart.Length -ge 2 -and ($valuePart[0] -eq '"' -and $valuePart[-1] -eq '"' -or $valuePart[0] -eq "'" -and $valuePart[-1] -eq "'")) {
                                # remove surrounding quotes
                                $quoteChar = $valuePart[0]
                                $value = $valuePart.Substring(1, $valuePart.Length - 2)
                                if ($quoteChar -eq '"') {
                                        # unescape common sequences in double quotes
                                        $value = $value -replace '\\n', "`n" -replace '\\r', "`r" -replace '\\t', "`t" -replace '\\"', '"' -replace '\\\\', '\'
                                }
                        } else {
                                # remove inline comment (#) only if not inside quotes (we're unquoted here)
                                $value = ($valuePart -split '\s+#', 2)[0].Trim()
                        }
                        write-host setting env variable $name to scope $Scope
                        [System.Environment]::SetEnvironmentVariable($name, $value, $Scope)
                        if ($Verbose) { Write-Output "Set $name=`"$value`" (Scope=$Scope)" }
                } else {
                        Write-Verbose "Ignoring line: $line"
                }
        }
}