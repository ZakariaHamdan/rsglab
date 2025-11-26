#!/bin/bash

# ANSI color codes
CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
BOLD='\033[1m'
RESET='\033[0m'

show_zak_banner() {
    echo -e "${CYAN}${BOLD}"
    cat << "EOF"
  ███████╗ █████╗ ██╗  ██╗
  ╚══███╔╝██╔══██╗██║ ██╔╝
    ███╔╝ ███████║█████╔╝ 
   ███╔╝  ██╔══██║██╔═██╗ 
  ███████╗██║  ██║██║  ██╗
  ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
EOF
    echo -e "${RESET}"
}

show_welcome() {
    clear
    show_zak_banner
    echo -e "${GREEN}==================================================${RESET}"
    echo -e "${YELLOW}${BOLD}        NETWORK LAB TOOLS${RESET}"
    echo -e "${GREEN}        ALL RIGHTS RESERVED${RESET}"
    echo -e "${GREEN}==================================================${RESET}\n"
    echo -e "${YELLOW}Press Enter to continue (auto-continue in 4s)...${RESET}"
    read -t 4
}