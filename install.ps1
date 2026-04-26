# MICLI Installer - One-line installation for PowerShell
# Usage: irm https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/install.ps1 | iex

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ███╗██╗  ██╗██╗  ██╗ ██████╗ ██╗    ██╗         ║
║   ████╗ ████║██║  ██║██║  ██║██╔═══██╗██║    ██║         ║
║   ██╔████╔██║███████║███████║██║   ██║██║ █╗ ██║         ║
║   ██║╚██╔╝██║██╔══██║██╔══██║██║   ██║██║███╗██║         ║
║   ██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝         ║
║   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝          ║
║                                                           ║
║          My Intelligent CLI Agent                         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host ""
Write-Host "Installing MICLI..." -ForegroundColor Green

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
    $MICLI_HOST = "108.181.162.206"
    $MICLI_USER = "administrator"
    $MICLI_PORT = "2222"
    $SSH_KEY = "$HOME\.ssh\id_ed25519"
    
    # Show banner
    Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║   ███╗   ███╗██╗  ██╗██╗  ██╗ ██████╗ ██╗    ██╗         ║
║   ████╗ ████║██║  ██║██║  ██║██╔═══██╗██║    ██║         ║
║   ██╔████╔██║███████║███████║██║   ██║██║ █╗ ██║         ║
║   ██║╚██╔╝██║██╔══██║██╔══██║██║   ██║██║███╗██║         ║
║   ██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝         ║
║   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝          ║
║                                                           ║
║          My Intelligent CLI Agent                         ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

    # Auto-setup if SSH key doesn't exist
    if (-not (Test-Path $SSH_KEY)) {
        Write-Host ""
        Write-Host "⚠ First run - setting up passwordless SSH..." -ForegroundColor Yellow
        Write-Host "Generating SSH key..." -ForegroundColor Cyan
        ssh-keygen -t ed25519 -f $SSH_KEY -N ""
        Write-Host ""
        Write-Host "✓ SSH key generated!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Now copy your public key to the VPS:" -ForegroundColor Yellow
        Write-Host "  type $SSH_KEY.pub" -ForegroundColor White
        Write-Host ""
        Write-Host "Then SSH to VPS and add to ~/.ssh/authorized_keys" -ForegroundColor Yellow
        Write-Host "Or run: ssh-copy-id -i $SSH_KEY.pub $MICLI_USER@$MICLI_HOST" -ForegroundColor White
        Write-Host ""
        Write-Host "After that, just type: micli" -ForegroundColor Green
        return
    }
    
    # Show status
    Write-Host ""
    Write-Host "┌─────────────────────────────────────────────────┐" -ForegroundColor Yellow
    Write-Host "│  Status: ● Connected" -ForegroundColor Green
    Write-Host "│  VPS:    $MICLI_HOST" -ForegroundColor Cyan
    Write-Host "│  User:   $MICLI_USER" -ForegroundColor Cyan
    Write-Host "│  Tunnel: port $MICLI_PORT" -ForegroundColor Cyan
    Write-Host "└─────────────────────────────────────────────────┘" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "➜  Connecting to $MICLI_HOST..." -ForegroundColor Green
    Write-Host ""
    
    ssh -i $SSH_KEY -o StrictHostKeyChecking=no -R 2222:localhost:2222 "$MICLI_USER@$MICLI_HOST"
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

# Check if SSH key exists
if (-not (Test-Path "$HOME\.ssh\id_ed25519")) {
    Write-Host "Setting up passwordless SSH..." -ForegroundColor Yellow
    ssh-keygen -t ed25519 -f "$HOME\.ssh\id_ed25519" -N ""
    Write-Host ""
    Write-Host "Now copy your public key to the VPS:" -ForegroundColor Yellow
    Write-Host "  type $HOME\.ssh\id_ed25519.pub" -ForegroundColor White
    Write-Host ""
    Write-Host "Then SSH to VPS and add to ~/.ssh/authorized_keys" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "After that, just type: micli" -ForegroundColor Green
} else {
    Write-Host "✓ SSH key found" -ForegroundColor Green
    Write-Host ""
    Write-Host "Just type: micli" -ForegroundColor Green
}
