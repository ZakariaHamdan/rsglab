#!/bin/bash

# ANSI color codes
CYAN='\033[96m'
GREEN='\033[92m'
YELLOW='\033[93m'
RED='\033[91m'
BOLD='\033[1m'
RESET='\033[0m'

declare -a CMD_QUEUE=()

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

# Parse command sequence like "4,2,3" or "4.2.3" or "4 2 3"
parse_commands() {
    local input="$1"
    # Replace commas and dots with spaces, remove extra spaces
    local cleaned=$(echo "$input" | tr ',.' ' ' | tr -s ' ')
    echo $cleaned
}

# Get next choice (from queue or user input)
get_menu_choice() {
    local choice
    
    if [ ${#CMD_QUEUE[@]} -gt 0 ]; then
        # Use first item from queue
        choice=${CMD_QUEUE[0]}
        CMD_QUEUE=("${CMD_QUEUE[@]:1}")
        echo -e "${CYAN}→ Auto-selecting: $choice${RESET}"
        sleep 0.3
        echo "$choice"
    else
        # Normal prompt - FIX: was calling itself recursively!
        read choice
        
        # Check if it contains multiple commands
        if [[ $choice =~ [,.[:space:]] ]]; then
            CMD_QUEUE=($(parse_commands "$choice"))
            if [ ${#CMD_QUEUE[@]} -gt 0 ]; then
                local first=${CMD_QUEUE[0]}
                CMD_QUEUE=("${CMD_QUEUE[@]:1}")
                echo -e "${CYAN}→ Executing sequence: $choice${RESET}"
                sleep 0.3
                echo "$first"
                return
            fi
        fi
        echo "$choice"
    fi
}

clear_queue() {
    CMD_QUEUE=()
}