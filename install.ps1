# MICLI Installer - One-line installation for PowerShell
# Usage: irm https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/install.ps1 | iex

Write-Host "╔═══════════════════════════════════════════╗"
Write-Host "║     MICLI - My Intelligent CLI Agent      ║"
Write-Host "╚═══════════════════════════════════════════╝"
Write-Host ""
Write-Host "Installing MICLI..." -ForegroundColor Cyan

$INSTALL_DIR = "$HOME\.micli"
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null

# Download micli.sh
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/micli.sh" -OutFile "$INSTALL_DIR\micli.sh" -UseBasicParsing
    Write-Host "✓ Downloaded micli.sh" -ForegroundColor Green
} catch {
    Write-Error "Failed to download micli.sh"
    exit 1
}

# Create PowerShell wrapper function
$micliFunction = @'
function micli {
    param($arg)
    $configFile = "$HOME\.micli-config"
    if ($arg -eq "--setup") {
        $vpsHost = Read-Host "VPS Host"
        $user = Read-Host "SSH user [administrator]"
        if ([string]::IsNullOrWhiteSpace($user)) { $user = "administrator" }
        Set-Content -Path $configFile -Value "MICLI_HOST=$vpsHost" -Encoding utf8
        Add-Content -Path $configFile -Value "MICLI_USER=$user" -Encoding utf8
        Write-Host "✓ Config saved!" -ForegroundColor Green
        Write-Host "Run 'micli' to connect" -ForegroundColor Green
        return
    }
    if ($arg -eq "--help" -or $arg -eq "-h") {
        Write-Host "Usage: micli [--setup|--help]"
        return
    }
    if (-not (Test-Path $configFile)) {
        Write-Host "✗ Not configured! Run: micli --setup" -ForegroundColor Red
        return
    }
    $micliHost = (Get-Content $configFile | Select-String "^MICLI_HOST=" | ForEach-Object { $_.Line.Split('=')[1] })[0]
    $micliUser = (Get-Content $configFile | Select-String "^MICLI_USER=" | ForEach-Object { $_.Line.Split('=')[1] })[0]
    if (-not $micliHost) {
        Write-Host "✗ Config error! Run: micli --setup" -ForegroundColor Red
        return
    }
    Write-Host "╔═══════════════════════════════════════════╗"
    Write-Host "║     MICLI - My Intelligent CLI Agent      ║"
    Write-Host "╚═══════════════════════════════════════════╝"
    Write-Host "Connecting to $micliHost..." -ForegroundColor Green
    ssh -o StrictHostKeyChecking=no -R 2222:localhost:2222 "$micliUser@$micliHost"
}
'@

# Add to PowerShell profile
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

# Remove existing micli function if present
$content = Get-Content $profilePath -Raw -ErrorAction SilentlyContinue
if ($content -match '(?s)function micli \{.*?\}') {
    $content = $content -replace '(?s)function micli \{.*?\}', ''
    $content | Out-File -FilePath $profilePath -Encoding utf8
}

# Add new function
Add-Content -Path $profilePath -Value "`n# MICLI - My Intelligent CLI Agent`n$micliFunction"

# Reload profile
. $profilePath

Write-Host ""
Write-Host "✓ MICLI installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Run: micli --setup"
Write-Host "  2. Enter your VPS details (e.g., 108.181.162.206)"
Write-Host "  3. Type: micli"
Write-Host ""
Write-Host "Your AI agent is ready! 🚀" -ForegroundColor Green
