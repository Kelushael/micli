#!/bin/bash
# MICLI - My Intelligent CLI Agent
# Zero-config AI agent with reverse tunnel architecture
# Just type 'micli' and you're connected!

# Default VPS configuration (customize these)
MICLI_HOST="${MICLI_HOST:-108.181.162.206}"
MICLI_USER="${MICLI_USER:-administrator}"
MICLI_SSH_PORT="${MICLI_SSH_PORT:-22}"
MICLI_PORT="${MICLI_PORT:-2222}"

# SSH key for passwordless auth
SSH_KEY="$HOME/.ssh/id_ed25519"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_banner() {
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║   ███╗   ███╗██╗  ██╗██╗  ██╗ ██████╗ ██╗    ██╗         ║"
    echo "║   ████╗ ████║██║  ██║██║  ██║██╔═══██╗██║    ██║         ║"
    echo "║   ██╔████╔██║███████║███████║██║   ██║██║ █╗ ██║         ║"
    echo "║   ██║╚██╔╝██║██╔══██║██╔══██║██║   ██║██║███╗██║         ║"
    echo "║   ██║ ╚═╝ ██║██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝         ║"
    echo "║   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝          ║"
    echo "║                                                           ║"
    echo "║          My Intelligent CLI Agent                         ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝${NC}"
}

show_status() {
    echo -e "${YELLOW}┌─────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│${NC}  Status: ${GREEN}● Connected${NC}"
    echo -e "${YELLOW}│${NC}  VPS:    ${CYAN}$MICLI_HOST${NC}"
    echo -e "${YELLOW}│${NC}  User:   ${CYAN}$MICLI_USER${NC}"
    echo -e "${YELLOW}│${NC}  Tunnel: ${CYAN}port $MICLI_PORT${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────┘${NC}"
}

# Auto-setup if SSH key doesn't exist
if [ ! -f "$SSH_KEY" ]; then
    show_banner
    echo ""
    echo -e "${RED}⚠ First run - setting up passwordless SSH...${NC}"
    echo ""
    ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" -q
    echo ""
    echo -e "${GREEN}✓ SSH key generated!${NC}"
    echo ""
    echo -e "${YELLOW}Now copy your public key to the VPS:${NC}"
    echo -e "  ${CYAN}ssh-copy-id -i $SSH_KEY.pub $MICLI_USER@$MICLI_HOST${NC}"
    echo ""
    echo -e "${YELLOW}Or manually:${NC}"
    echo "  1. Run: ${CYAN}cat $SSH_KEY.pub${NC}"
    echo "  2. SSH to VPS: ${CYAN}ssh $MICLI_USER@$MICLI_HOST${NC}"
    echo "  3. Add to ~/.ssh/authorized_keys on VPS"
    echo ""
    echo -e "${GREEN}Then just type: ${CYAN}micli${NC}"
    exit 1
fi

show_banner
show_status
echo ""
echo -e "${GREEN}➜  Connecting to $MICLI_HOST...${NC}"
echo ""

# Establish reverse tunnel
ssh -i "$SSH_KEY" \
    -o StrictHostKeyChecking=no \
    -o ServerAliveInterval=60 \
    -o ServerAliveCountMax=3 \
    -R $MICLI_PORT:localhost:$MICLI_PORT \
    "$MICLI_USER@$MICLI_HOST" -p "$MICLI_SSH_PORT"