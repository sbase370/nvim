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

install_if_missing_arch() {
    local package="$1"
    local command="$2"

    if ! command -v "$command" >/dev/null 2>&1; then
        info "Installing $package..."
        sudo pacman -Sy --noconfirm "$package"
    else
        info "$package already installed"
    fi
}

install_packages_arch() {
    info "Installing packages for Arch Linux..."

    install_if_missing_arch neovim nvim
    install_if_missing_arch git git
    install_if_missing_arch curl curl
    install_if_missing_arch wget wget
    install_if_missing_arch unzip unzip
    install_if_missing_arch gcc gcc
    install_if_missing_arch make make
    install_if_missing_arch ripgrep rg
    install_if_missing_arch fd fd
    install_if_missing_arch python python
    install_if_missing_arch pip pip
    install_if_missing_arch npm npm
    install_if_missing_arch go go
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
