#!/bin/bash

set -e

echo "=== Installing required development tools ==="

function is_installed() {
    command -v "$1" >/dev/null 2>&1
}

sudo apt update

# Docker
if is_installed docker; then
    echo "[✓] Docker is already installed"
else
    echo "[...] Installing Docker..."
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "[+] Docker installed"
fi

# Docker-compose
if is_installed docker-compose; then
    echo "[✓] Docker Compose is already installed"
else
    echo "[...] Installing Docker Compose..."
    sudo apt install -y docker-compose
    echo "[+] Docker Compose installed"
fi

# Python
REQUIRED_PYTHON="3.9"
if is_installed python3; then
    PY_VERSION=$(python3 -c 'import platform; print(platform.python_version())')
    if [[ "$(printf '%s\n' "$REQUIRED_PYTHON" "$PY_VERSION" | sort -V | head -n1)" = "$REQUIRED_PYTHON" ]]; then
        echo "[✓] Python3 ($PY_VERSION) is installed and meets version requirement"
    else
        echo "[!] Python3 version is $PY_VERSION, which is older than required ($REQUIRED_PYTHON)"
    fi
else
    echo "[...] Installing Python3..."
    sudo apt install -y python3
    echo "[+] Python3 installed"
fi

# Pip3
if is_installed pip3; then
    echo "[✓] pip3 is already installed"
else
    echo "[...] Installing pip3..."
    sudo apt install -y python3-pip
    echo "[+] pip3 installed"
fi

# Django
if python3 -m django --version >/dev/null 2>&1; then
    echo "[✓] Django is already installed"
else
    echo "[...] Installing Django via pip..."
    pip3 install django
    echo "[+] Django installed"
fi

