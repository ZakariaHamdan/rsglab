#!/bin/bash

search_menu() {
    clear
    show_zak_banner
    echo -e "${GREEN}==================================================${RESET}"
    echo -e "${YELLOW}System-wide File Search${RESET}"
    echo -e "${GREEN}==================================================${RESET}\n"
    echo -en "${YELLOW}Enter filename pattern: ${RESET}"
    read pattern
    
    if [ -n "$pattern" ]; then
        echo -e "\n${CYAN}Searching for: $pattern${RESET}"
        echo -e "${CYAN}This may take a moment...${RESET}\n"
        
        results=$(find / -name "$pattern" 2>/dev/null)
        
        if [ -n "$results" ]; then
            echo -e "${GREEN}Found:${RESET}\n"
            echo "$results"
        else
            echo -e "${RED}No files found matching '$pattern'${RESET}"
        fi
    else
        echo -e "${RED}No pattern entered!${RESET}"
    fi
    
    echo -e "\n${YELLOW}Press Enter to return to menu...${RESET}"
    read
}