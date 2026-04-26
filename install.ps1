# MICLI Installer - One-line installation for PowerShell
# Usage: irm https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/install.ps1 | iex

Write-Host "╔═══════════════════════════════════════════╗"
Write-Host "║     MICLI - My Intelligent CLI Agent      ║"
Write-Host "╚═══════════════════════════════════════════╝"
Write-Host ""
Write-Host "Installing MICLI..."

$INSTALL_DIR = "$HOME\.micli"
New-Item -ItemType Directory -Force -Path $INSTALL_DIR | Out-Null

# Download micli.sh
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/micli.sh" -OutFile "$INSTALL_DIR\micli.sh" -UseBasicParsing
} catch {
    Write-Error "Failed to download micli.sh"
    exit 1
}

# Add to PowerShell profile
$profilePath = $PROFILE
if (-not (Test-Path $profilePath)) {
    New-Item -ItemType File -Path $profilePath -Force | Out-Null
}

$functionText = @"
function micli {
    & "$INSTALL_DIR\micli.sh"
}
"@

# Check if function already exists
if (-not (Get-Content $profilePath -Raw -ErrorAction SilentlyContinue | Select-String -Pattern "function micli")) {
    Add-Content -Path $profilePath -Value "`n# MICLI`n$functionText"
}

# Reload profile
if (Test-Path $profilePath) {
    . $profilePath
}

Write-Host ""
Write-Host "✓ MICLI installed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:"
Write-Host "  1. Run: micli --setup"
Write-Host "  2. Enter your VPS details"
Write-Host "  3. Type: micli"
Write-Host ""
Write-Host "Your AI agent is ready! 🚀" -ForegroundColor Green
