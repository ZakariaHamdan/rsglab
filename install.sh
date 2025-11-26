#!/bin/bash

CYAN='\033[96m'
GREEN='\033[92m'
RED='\033[91m'
RESET='\033[0m'

echo -e "${CYAN}RSG Lab Tools Installer${RESET}\n"

# Get script directory
INSTALL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "Installing from: ${GREEN}$INSTALL_DIR${RESET}"

# Check if modules exist
if [ ! -d "$INSTALL_DIR/modules" ]; then
    echo -e "${RED}Error: modules/ directory not found!${RESET}"
    exit 1
fi

# Make main script executable
echo -e "Setting permissions..."
chmod +x "$INSTALL_DIR/rsglab.sh"

# Create symlink
echo -e "Creating system-wide command..."
sudo ln -sf "$INSTALL_DIR/rsglab.sh" /usr/local/bin/rsglab

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Installation complete!${RESET}\n"
    echo -e "Run '${CYAN}rsglab${RESET}' from anywhere to start."
else
    echo -e "${RED}✗ Installation failed!${RESET}"
    exit 1
fi