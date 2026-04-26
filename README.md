# MICLI - My Intelligent CLI Agent

**Zero-config AI agent with reverse tunnel architecture**

Just type `micli` and start talking to your AI agent running on your VPS!

## 🚀 Quick Install

### Linux/macOS (Bash)
```bash
curl -fsSL https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/install.sh | bash
```

Or with wget:
```bash
wget -qO- https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/install.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/install.ps1 | iex
```

## 📋 What is MICLI?

MICLI creates a reverse SSH tunnel from your VPS back to your local machine, allowing you to:
- Run AI agents on your VPS that can control your local terminal
- Access your VPS tools and compute from any machine
- Maintain a persistent AI development environment
- Zero configuration after initial setup

## 🛠️ Usage

### First Time Setup
```bash
micli --setup
```

Enter your VPS details when prompted.

### Launch Your AI Agent
```bash
micli
```

That's it! The reverse tunnel establishes and your VPS-based AI agent can now interact with your local terminal.

## 🔧 Configuration

MICLI uses environment variables (stored in `~/.micli-config`):

- `MICLI_HOST` - Your VPS hostname or IP (default: required)
- `MICLI_USER` - SSH username (default: administrator)
- `MICLI_SSH_PORT` - SSH port (default: 22)
- `MICLI_PORT` - Reverse tunnel port (default: 2222)

## 🏗️ Architecture

```
┌─────────────┐                    ┌─────────────┐
│ Local Machine│                    │     VPS     │
│             │                    │             │
│  $ micli    │ ─── SSH ─────────▶ │  Agent      │
│             │                    │             │
│             │ ◀──── Tunnel ───── │             │
│  Terminal   │    (port 2222)     │  AI Tools   │
└─────────────┘                    └─────────────┘
```

When you type `micli`:
1. Local machine establishes SSH connection to VPS
2. Creates reverse tunnel (`-R 2222:localhost:2222`)
3. VPS can now reach back to local machine on port 2222
4. AI agent on VPS has full access to local terminal

## 📦 Manual Installation

### Linux/macOS
```bash
# Download
curl -L https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/micli.sh -o ~/.micli/micli.sh
chmod +x ~/.micli/micli.sh

# Add alias
echo 'alias micli="$HOME/.micli/micli.sh"' >> ~/.bashrc
source ~/.bashrc
```

### Windows (PowerShell)
```powershell
# Create directory
New-Item -ItemType Directory -Force -Path $HOME\.micli

# Download script
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/KELUSHAEL/MICLI/main/micli.sh" -OutFile "$HOME\.micli\micli.sh"

# Add to profile
Add-Content -Path $PROFILE -Value "function micli { & `"$HOME\.micli\micli.sh`" }"
```

## 🔐 Security Notes

- MICLI uses SSH key-based authentication (recommended) or password auth
- Reverse tunnel only allows VPS to reach back to your local machine
- No external services or cloud dependencies
- Your data stays between your machines

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a PR

## 📄 License

MIT License - See LICENSE file

---

**Made with ❤️ by KELUSHAEL**
