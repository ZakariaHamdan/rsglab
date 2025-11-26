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
source "$MODULES_DIR/dns.sh"

# Update function
update_rsglab() {
    clear
    echo -e "${CYAN}${BOLD}Updating RSG Lab Tools...${RESET}\n"
    
    cd "$SCRIPT_DIR"
    
    # Check if in git repo
    if [ ! -d ".git" ]; then
        echo -e "${RED}Error: Not a git repository!${RESET}"
        echo -e "Please reinstall from GitHub."
        exit 1
    fi
    
    # Stash local changes if any
    if ! git diff-index --quiet HEAD --; then
        echo -e "${YELLOW}Stashing local changes...${RESET}"
        git stash
    fi
    
    echo -e "${YELLOW}Pulling latest changes...${RESET}"
    git pull
    
    if [ $? -eq 0 ]; then
        # Fix permissions
        chmod +x rsglab.sh install.sh uninstall.sh 2>/dev/null
        echo -e "${GREEN}✓ Update complete!${RESET}\n"
        echo -e "Changes will take effect on next run."
    else
        echo -e "${RED}✗ Update failed!${RESET}"
        exit 1
    fi
}

# Direct SSH shortcuts
ssh_direct() {
    local target=$1
    case $target in
        gate|labgate|gateway)
            clear
            echo -e "${GREEN}Connecting to Lab Gateway...${RESET}\n"
            ssh rsg@labgate
            ;;
        manager|labmngr|labmanager)
            clear
            echo -e "${GREEN}Connecting to Lab Manager...${RESET}\n"
            ssh soc@labmngr
            ;;
        *)
            echo -e "${RED}Unknown SSH target: $target${RESET}"
            echo -e "Usage: rsglab ssh [gate|manager]"
            exit 1
            ;;
    esac
}

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
        echo -e "${GREEN}[4]${RESET} DNS Management"
        echo -e "${GREEN}[5]${RESET} Exit\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        read choice

        case $choice in
            1) ssh_menu ;;
            2) search_menu ;;
            3) bind9_menu ;;
            4) dns_menu ;;
            5)
                clear
                echo -e "${CYAN}Goodbye!${RESET}"
                exit 0
                ;;
        esac
    done
}

# Parse command-line arguments
case "$1" in
    update)
        update_rsglab
        ;;
    ssh)
        if [ -z "$2" ]; then
            ssh_menu
        else
            ssh_direct "$2"
        fi
        ;;
    help|--help|-h)
        clear
        show_zak_banner
        echo -e "${CYAN}Usage:${RESET}"
        echo -e "  rsglab                    - Interactive menu"
        echo -e "  rsglab update             - Update to latest version"
        echo -e "  rsglab ssh gate           - SSH to Lab Gateway"
        echo -e "  rsglab ssh manager        - SSH to Lab Manager"
        echo -e "\n${CYAN}Aliases:${RESET}"
        echo -e "  gate: labgate, gateway"
        echo -e "  manager: labmngr, labmanager"
        ;;
    "")
        # No arguments - show menu directly
        main_menu
        ;;
    *)
        echo -e "${RED}Unknown command: $1${RESET}"
        echo -e "Run 'rsglab help' for usage."
        exit 1
        ;;
esac