#!/bin/bash
set -e

# Function to install paru if not already installed
install_paru() {
    echo "paru is not installed. Installing paru from AUR..."
    # Install dependencies if needed
    sudo pacman -S --needed git base-devel --noconfirm
    # Clone the paru repository, build, and install
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si --noconfirm
    cd ..
    rm -rf paru
}

# Check if paru is installed
if ! command -v paru &> /dev/null; then
    install_paru
else
    echo "paru is already installed."
fi

# Install packages listed in necessary_packages.txt
if [[ -f "necessary_packages.txt" ]]; then
    echo "Installing packages from necessary_packages.txt..."
    paru -S --needed $(<necessary_packages.txt)
else
    echo "necessary_packages.txt not found."
fi

# Enable and start services listed in services.txt
if [[ -f "services.txt" ]]; then
    echo "Enabling and starting services from services.txt..."
    sudo systemctl enable --now $(<services.txt)
else
    echo "services.txt not found."
fi

echo "Installation and service setup complete."

