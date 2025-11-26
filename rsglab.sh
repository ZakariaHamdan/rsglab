#!/bin/bash

# Follow symlinks to find real script location
SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
MODULES_DIR="$SCRIPT_DIR/modules"

# Source all modules
source "$MODULES_DIR/common.sh"
source "$MODULES_DIR/ssh.sh"
source "$MODULES_DIR/search.sh"
source "$MODULES_DIR/bind9.sh"

main_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          RSG NETWORK LAB TOOLS${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} SSH"
        echo -e "${GREEN}[2]${RESET} Search for files system-wide"
        echo -e "${GREEN}[3]${RESET} BIND9 Management"
        echo -e "${GREEN}[4]${RESET} Exit\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        read choice

        case $choice in
            1) ssh_menu ;;
            2) search_menu ;;
            3) bind9_menu ;;
            4)
                clear
                echo -e "${CYAN}Goodbye!${RESET}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option!${RESET}"
                sleep 1
                ;;
        esac
    done
}

# Start
show_welcome
main_menu