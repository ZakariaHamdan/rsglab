#!/bin/bash

ALIAS_FILE="$HOME/.rsglab_aliases"
BASHRC="$HOME/.bashrc"

init_alias_file() {
    if [ ! -f "$ALIAS_FILE" ]; then
        cat > "$ALIAS_FILE" << 'EOF'
# RSG Lab Tool Managed Aliases
# Do not edit manually - use rsglab to manage

EOF
    fi
    
    # Check if bashrc sources our alias file
    if ! grep -q "rsglab_aliases" "$BASHRC" 2>/dev/null; then
        cat >> "$BASHRC" << 'EOF'

# Source RSG Lab managed aliases
[ -f ~/.rsglab_aliases ] && source ~/.rsglab_aliases
EOF
        return 1  # Signal bashrc was updated
    fi
    return 0
}

view_aliases() {
    clear
    show_zak_banner
    echo -e "${CYAN}${BOLD}==================================================${RESET}"
    echo -e "${CYAN}${BOLD}          Current Aliases${RESET}"
    echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
    
    local count=0
    while IFS= read -r line; do
        if [[ ! $line =~ ^# ]] && [[ -n $line ]]; then
            ((count++))
            echo -e "${GREEN}[$count]${RESET} $line"
        fi
    done < "$ALIAS_FILE"
    
    if [ $count -eq 0 ]; then
        echo -e "${YELLOW}No aliases configured yet.${RESET}"
    fi
    
    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
    read
}

create_alias() {
    clear
    show_zak_banner
    echo -e "${CYAN}${BOLD}==================================================${RESET}"
    echo -e "${CYAN}${BOLD}          Create New Alias${RESET}"
    echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
    
    echo -en "${YELLOW}Enter alias name: ${RESET}"
    read alias_name
    
    if [ -z "$alias_name" ]; then
        echo -e "${RED}Alias name cannot be empty!${RESET}"
        sleep 2
        return
    fi
    
    # Validate alias name (alphanumeric, underscore, dash)
    if [[ ! $alias_name =~ ^[a-zA-Z0-9_-]+$ ]]; then
        echo -e "${RED}Invalid alias name! Use only letters, numbers, _, -${RESET}"
        sleep 2
        return
    fi
    
    # Check if already exists
    if grep -q "^alias $alias_name=" "$ALIAS_FILE" 2>/dev/null; then
        echo -e "${RED}Alias '$alias_name' already exists!${RESET}"
        sleep 2
        return
    fi
    
    echo -en "${YELLOW}Enter command: ${RESET}"
    read command
    
    if [ -z "$command" ]; then
        echo -e "${RED}Command cannot be empty!${RESET}"
        sleep 2
        return
    fi
    
    # Add to file
    echo "alias $alias_name='$command'" >> "$ALIAS_FILE"
    
    # Source for current shell
    source "$ALIAS_FILE" 2>/dev/null
    
    echo -e "\n${GREEN}✓ Alias created successfully!${RESET}"
    echo -e "${CYAN}$alias_name='$command'${RESET}"
    echo -e "\n${YELLOW}Note: Reload shell or run 'source ~/.bashrc' for new sessions.${RESET}"
    sleep 3
}

delete_alias() {
    clear
    show_zak_banner
    echo -e "${CYAN}${BOLD}==================================================${RESET}"
    echo -e "${CYAN}${BOLD}          Delete Alias${RESET}"
    echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
    
    # Build array of aliases
    local aliases=()
    while IFS= read -r line; do
        if [[ ! $line =~ ^# ]] && [[ -n $line ]]; then
            aliases+=("$line")
        fi
    done < "$ALIAS_FILE"
    
    if [ ${#aliases[@]} -eq 0 ]; then
        echo -e "${YELLOW}No aliases to delete.${RESET}"
        sleep 2
        return
    fi
    
    # Display
    for i in "${!aliases[@]}"; do
        echo -e "${GREEN}[$((i+1))]${RESET} ${aliases[$i]}"
    done
    
    echo -en "\n${YELLOW}Enter number to delete (0 to cancel): ${RESET}"
    read num
    
    if [ "$num" -eq 0 ] 2>/dev/null; then
        return
    fi
    
    if [ "$num" -ge 1 ] 2>/dev/null && [ "$num" -le "${#aliases[@]}" ]; then
        local to_delete="${aliases[$((num-1))]}"
        
        # Rebuild file without this line
        local temp_file=$(mktemp)
        while IFS= read -r line; do
            if [ "$line" != "$to_delete" ]; then
                echo "$line" >> "$temp_file"
            fi
        done < "$ALIAS_FILE"
        
        mv "$temp_file" "$ALIAS_FILE"
        
        echo -e "\n${GREEN}✓ Alias deleted!${RESET}"
        echo -e "${YELLOW}Reload shell to apply changes.${RESET}"
        sleep 2
    else
        echo -e "\n${RED}Invalid number!${RESET}"
        sleep 2
    fi
}

aliases_menu() {
    init_alias_file
    local setup=$?
    
    if [ $setup -eq 1 ]; then
        clear
        show_zak_banner
        echo -e "${YELLOW}First-time setup complete!${RESET}"
        echo -e "${YELLOW}Added alias sourcing to ~/.bashrc${RESET}"
        echo -e "\n${CYAN}Run: source ~/.bashrc${RESET}"
        echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
        read
    fi
    
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          Alias Management${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} View aliases"
        echo -e "${GREEN}[2]${RESET} Create alias"
        echo -e "${GREEN}[3]${RESET} Delete alias"
        echo -e "${GREEN}[4]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1) view_aliases ;;
            2) create_alias ;;
            3) delete_alias ;;
            4) return ;;
            *)
                echo -e "${RED}Invalid option!${RESET}"
                sleep 1
                ;;
        esac
    done
}