#!/bin/bash
# MICLI Installer - One-line installation for Linux/macOS
set -e

echo "╔═══════════════════════════════════════════╗"
echo "║     MICLI - My Intelligent CLI Agent      ║"
echo "╚═══════════════════════════════════════════╝"
echo ""
echo "Installing MICLI..."

INSTALL_DIR="$HOME/.micli"
mkdir -p "$INSTALL_DIR"

# Download micli.sh
if command -v curl &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/micli.sh -o "$INSTALL_DIR/micli.sh"
elif command -v wget &> /dev/null; then
    wget -q https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/micli.sh -O "$INSTALL_DIR/micli.sh"
else
    echo "Error: curl or wget required"
    exit 1
fi

chmod +x "$INSTALL_DIR/micli.sh"

# Add to shell config
SHELL_CONFIG=""
if [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "" >> "$SHELL_CONFIG"
    echo "# MICLI" >> "$SHELL_CONFIG"
    echo "alias micli='$INSTALL_DIR/micli.sh'" >> "$SHELL_CONFIG"
    source "$SHELL_CONFIG" 2>/dev/null || true
fi

echo ""
echo "✓ MICLI installed!"
echo ""

# Check if SSH key exists
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo "Setting up passwordless SSH..."
    ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N ""
    echo ""
    echo "Now copy your key to the VPS:"
    echo "  ssh-copy-id -i $HOME/.ssh/id_ed25519.pub administrator@108.181.162.206"
    echo ""
    echo "Then just type: micli"
else
    echo "✓ SSH key found"
    echo ""
    echo "Just type: micli"
fi
