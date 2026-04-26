#!/bin/bash
# MICLI - My Intelligent CLI Agent
# Zero-config AI agent with reverse tunnel architecture
set -e
MICLI_PORT="${MICLI_PORT:-2222}"
MICLI_HOST="${MICLI_HOST:-}"
MICLI_USER="${MICLI_USER:-administrator}"
MICLI_SSH_PORT="${MICLI_SSH_PORT:-22}"
CONFIG_FILE="$HOME/.micli-config"
GREEN='\033[0;32m'
NC='\033[0m'
banner() { echo -e "${GREEN}╔═══════════════════════════════════════════╗"; echo "║     MICLI - My Intelligent CLI Agent      ║"; echo "╚═══════════════════════════════════════════╝${NC}"; }
setup_wizard() { banner; echo "MICLI Setup"; read -p "VPS Host: " host; read -p "SSH user [administrator]: " user; user=${user:-administrator}; echo "export MICLI_HOST=\"$host\"" > "$CONFIG_FILE"; echo "export MICLI_USER=\"$user\"" >> "$CONFIG_FILE"; echo "Config saved!"; }
[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
case "$1" in --setup) setup_wizard;; --help|-h) banner; echo "Usage: micli [--setup|--help]"; exit 0;; esac
[ -z "$MICLI_HOST" ] && { echo "Not configured! Run: micli --setup"; exit 1; }
banner; echo "Connecting to $MICLI_HOST..."; ssh -o StrictHostKeyChecking=no -R $MICLI_PORT:localhost:$MICLI_PORT "$MICLI_USER@$MICLI_HOST" -p "$MICLI_SSH_PORT"