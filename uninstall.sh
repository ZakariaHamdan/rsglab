#!/bin/bash

CYAN='\033[96m'
GREEN='\033[92m'
RED='\033[91m'
RESET='\033[0m'

echo -e "${CYAN}RSG Lab Tools Uninstaller${RESET}\n"

sudo rm -f /usr/local/bin/rsglab

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Uninstalled successfully!${RESET}"
else
    echo -e "${RED}✗ Uninstall failed!${RESET}"
    exit 1
fi