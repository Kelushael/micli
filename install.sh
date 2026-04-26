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
    echo "export PATH=\$PATH:$INSTALL_DIR" >> "$SHELL_CONFIG"
    
    # Source the config
    if [ -n "$BASH_VERSION" ]; then
        source "$SHELL_CONFIG" 2>/dev/null || true
    elif [ -n "$ZSH_VERSION" ]; then
        source "$SHELL_CONFIG" 2>/dev/null || true
    fi
fi

echo ""
echo "✓ MICLI installed successfully!"
echo ""
echo "Next steps:"
echo "  1. Run: micli --setup"
echo "  2. Enter your VPS details"
echo "  3. Type: micli"
echo ""
echo "Your AI agent is ready! 🚀"
