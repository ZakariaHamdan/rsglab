#!/bin/bash

# BIND9 config paths
BIND_DIR="/etc/bind"
ZONES_DIR="$BIND_DIR/zones"
NAMED_CONF="$BIND_DIR/named.conf"
NAMED_CONF_OPTIONS="$BIND_DIR/named.conf.options"
NAMED_CONF_LOCAL="$BIND_DIR/named.conf.local"
NAMED_CONF_DEFAULT="$BIND_DIR/named.conf.default-zones"

check_bind9_config() {
    clear
    show_zak_banner
    echo -e "${YELLOW}Testing BIND9 configuration...${RESET}\n"
    echo -e "${CYAN}==================================================${RESET}"
    
    local errors=0
    
    echo -e "${YELLOW}Checking named.conf...${RESET}"
    if sudo named-checkconf; then
        echo -e "${GREEN}✓ Main configuration is valid${RESET}\n"
    else
        echo -e "${RED}✗ Main configuration has errors${RESET}\n"
        ((errors++))
    fi
    
    echo -e "${YELLOW}Checking zone files...${RESET}"
    
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*zone[[:space:]]+\"([^\"]+)\" ]]; then
            zone_name="${BASH_REMATCH[1]}"
            zone_file=""
            while IFS= read -r subline; do
                if [[ $subline =~ file[[:space:]]+\"([^\"]+)\" ]]; then
                    zone_file="${BASH_REMATCH[1]}"
                    break
                fi
                if [[ $subline =~ \}\; ]]; then
                    break
                fi
            done
            
            if [ -n "$zone_file" ]; then
                if [[ ! $zone_file =~ ^/ ]]; then
                    zone_file="$BIND_DIR/$zone_file"
                fi
                
                echo -en "  Checking zone ${CYAN}$zone_name${RESET}... "
                if sudo named-checkzone "$zone_name" "$zone_file" > /dev/null 2>&1; then
                    echo -e "${GREEN}✓${RESET}"
                else
                    echo -e "${RED}✗${RESET}"
                    sudo named-checkzone "$zone_name" "$zone_file"
                    ((errors++))
                fi
            fi
        fi
    done < "$NAMED_CONF_LOCAL"
    
    echo -e "\n${CYAN}==================================================${RESET}"
    
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}All checks passed successfully!${RESET}"
    else
        echo -e "${RED}Found $errors error(s) in configuration!${RESET}"
    fi
    
    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
    read
}

file_action_menu() {
    local file_path=$1
    local file_name=$(basename "$file_path")
    
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          File: $file_name${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} cat"
        echo -e "${GREEN}[2]${RESET} vim"
        echo -e "${GREEN}[3]${RESET} nano"
        echo -e "${GREEN}[4]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        
        choice=$(get_menu_choice)
        
        case $choice in
            1)
                clear_queue
                clear
                cat "$file_path"
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            2)
                clear_queue
                sudo vim "$file_path"
                ;;
            3)
                clear_queue
                sudo nano "$file_path"
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Invalid option: $choice${RESET}"
                clear_queue
                sleep 1
                ;;
        esac
    done
}

bind9_service_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          BIND9 Service Management${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} Restart BIND9"
        echo -e "${GREEN}[2]${RESET} Status"
        echo -e "${GREEN}[3]${RESET} Test configuration"
        echo -e "${GREEN}[4]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1)
                clear_queue
                clear
                echo -e "${YELLOW}Restarting BIND9...${RESET}\n"
                sudo systemctl restart named
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}BIND9 restarted successfully!${RESET}"
                else
                    echo -e "${RED}Failed to restart BIND9!${RESET}"
                fi
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            2)
                clear_queue
                clear
                sudo systemctl status named
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            3)
                check_bind9_config
                ;;
            4)
                return
                ;;
            *)
                echo -e "${RED}Invalid option: $choice${RESET}"
                clear_queue
                sleep 1
                ;;
        esac
    done
}

bind9_zones_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          BIND9 Zone Files${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        
        zone_files=($ZONES_DIR/db.*)
        
        if [ ${#zone_files[@]} -eq 0 ] || [ ! -e "${zone_files[0]}" ]; then
            echo -e "${RED}No zone files found in $ZONES_DIR${RESET}"
            echo -e "\n${YELLOW}Press Enter to go back...${RESET}"
            read
            return
        fi
        
        local i=1
        for zone_file in "${zone_files[@]}"; do
            zone_name=$(basename "$zone_file")
            echo -e "${GREEN}[$i]${RESET} $zone_name"
            ((i++))
        done
        echo -e "${GREEN}[$i]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select zone file: ${RESET}"
        choice=$(get_menu_choice)
        
        if [ "$choice" -eq "$i" ] 2>/dev/null; then
            return
        elif [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -lt "$i" ]; then
            selected_file="${zone_files[$((choice-1))]}"
            file_action_menu "$selected_file"
        else
            echo -e "${RED}Invalid option: $choice${RESET}"
            clear_queue
            sleep 1
        fi
    done
}

bind9_config_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          BIND9 Configuration Files${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} named.conf"
        echo -e "${GREEN}[2]${RESET} named.conf.options"
        echo -e "${GREEN}[3]${RESET} named.conf.local"
        echo -e "${GREEN}[4]${RESET} named.conf.default-zones"
        echo -e "${GREEN}[5]${RESET} Zone files (zones/db.*)"
        echo -e "${GREEN}[6]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select file: ${RESET}"
        
        choice=$(get_menu_choice)
        
        case $choice in
            1) file_action_menu "$NAMED_CONF" ;;
            2) file_action_menu "$NAMED_CONF_OPTIONS" ;;
            3) file_action_menu "$NAMED_CONF_LOCAL" ;;
            4) file_action_menu "$NAMED_CONF_DEFAULT" ;;
            5) bind9_zones_menu ;;
            6) return ;;
            *)
                echo -e "${RED}Invalid option: $choice${RESET}"
                clear_queue
                sleep 1
                ;;
        esac
    done
}

bind9_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          BIND9 Management${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} Service Management"
        echo -e "${GREEN}[2]${RESET} Configuration Files"
        echo -e "${GREEN}[3]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1) bind9_service_menu ;;
            2) bind9_config_menu ;;
            3) return ;;
            *)
                echo -e "${RED}Invalid option: $choice${RESET}"
                clear_queue
                sleep 1
                ;;
        esac
    done
}