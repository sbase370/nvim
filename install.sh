#!/usr/bin/env bash

set -e

REPO_URL="https://github.com/sbase370/nvim.git"
CONFIG_DIR="$HOME/.config/nvim"
TMP_DIR="$HOME/nvim-config-install"

info() {
    echo "[INFO] $1"
}

error() {
    echo "[ERROR] $1"
    exit 1
}

detect_os() {
    if [ -f /etc/debian_version ]; then
        OS="debian"
    elif [ -f /etc/arch-release ]; then
        OS="arch"
    else
        error "Unsupported distribution"
    fi
}

install_packages_debian() {
    info "Installing packages for Debian/Ubuntu..."

    sudo apt update

    sudo apt install -y \
        neovim \
        git \
        curl \
        wget \
        unzip \
        gcc \
        g++ \
        make \
        ripgrep \
        fd-find \
        python3 \
        python3-pip \
        nodejs \
        npm \
        golang
}

install_packages_arch() {
    info "Installing packages for Arch Linux..."

    sudo pacman -Sy --noconfirm \
        neovim \
        git \
        curl \
        wget \
        unzip \
        gcc \
        make \
        ripgrep \
        fd \
        python \
        python-pip \
        nodejs \
        npm \
        go
}

clone_config() {
    info "Cloning configuration..."

    # rm -rf "$TMP_DIR"
    git clone "$REPO_URL" "$TMP_DIR"

    mkdir -p "$HOME/.config"

    rm -rf "$CONFIG_DIR"

    cp -r "$TMP_DIR/nvim" "$CONFIG_DIR"
}

main() {
    detect_os

    info "Detected OS: $OS"

    if [ "$OS" = "debian" ]; then
        install_packages_debian
    elif [ "$OS" = "arch" ]; then
        install_packages_arch
    fi

    clone_config

    info "Installation completed"
    info "Run: nvim"
}

main
