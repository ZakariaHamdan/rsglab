#!/bin/bash

# DNS config paths
RESOLV_CONF="/etc/resolv.conf"
RESOLVED_CONF="/etc/systemd/resolved.conf"
NSSWITCH_CONF="/etc/nsswitch.conf"
HOSTS_FILE="/etc/hosts"

dns_service_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          DNS Service Management${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} systemd-resolved status"
        echo -e "${GREEN}[2]${RESET} Restart systemd-resolved"
        echo -e "${GREEN}[3]${RESET} Flush DNS cache"
        echo -e "${GREEN}[4]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1)
                clear_queue
                clear
                echo -e "${CYAN}Running: sudo systemctl status systemd-resolved${RESET}\n"
                sudo systemctl status systemd-resolved
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            2)
                clear_queue
                clear
                echo -e "${YELLOW}Restarting systemd-resolved...${RESET}"
                echo -e "${CYAN}Running: sudo systemctl restart systemd-resolved${RESET}\n"
                sudo systemctl restart systemd-resolved
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}systemd-resolved restarted successfully!${RESET}"
                else
                    echo -e "${RED}Failed to restart systemd-resolved!${RESET}"
                fi
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            3)
                clear_queue
                clear
                echo -e "${YELLOW}Flushing DNS cache...${RESET}"
                echo -e "${CYAN}Running: sudo systemd-resolve --flush-caches${RESET}\n"
                sudo systemd-resolve --flush-caches
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}DNS cache flushed successfully!${RESET}"
                else
                    echo -e "${RED}Failed to flush DNS cache!${RESET}"
                fi
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
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

dns_config_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          DNS Configuration Files${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} resolv.conf"
        echo -e "${GREEN}[2]${RESET} systemd resolved.conf"
        echo -e "${GREEN}[3]${RESET} nsswitch.conf"
        echo -e "${GREEN}[4]${RESET} hosts"
        echo -e "${GREEN}[5]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select file: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1) file_action_menu "$RESOLV_CONF" ;;
            2) file_action_menu "$RESOLVED_CONF" ;;
            3) file_action_menu "$NSSWITCH_CONF" ;;
            4) file_action_menu "$HOSTS_FILE" ;;
            5) return ;;
            *)
                echo -e "${RED}Invalid option: $choice${RESET}"
                clear_queue
                sleep 1
                ;;
        esac
    done
}

dns_testing_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          DNS Testing${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} Quick test (common domains)"
        echo -e "${GREEN}[2]${RESET} Test specific domain"
        echo -e "${GREEN}[3]${RESET} DNS trace"
        echo -e "${GREEN}[4]${RESET} Test against specific nameserver"
        echo -e "${GREEN}[5]${RESET} Show current DNS server"
        echo -e "${GREEN}[6]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1)
                clear_queue
                clear
                echo -e "${YELLOW}Testing common domains...${RESET}\n"
                for domain in labgate.lab.local google.com cloudflare.com; do
                    echo -e "${CYAN}Running: dig +short $domain${RESET}"
                    dig +short $domain
                    echo ""
                done
                echo -e "${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            2)
                clear_queue
                clear
                echo -en "${YELLOW}Enter domain to test: ${RESET}"
                read domain
                if [ -n "$domain" ]; then
                    clear
                    echo -e "${CYAN}Running: dig $domain${RESET}\n"
                    dig $domain
                    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                    read
                fi
                ;;
            3)
                clear_queue
                clear
                echo -en "${YELLOW}Enter domain for DNS trace: ${RESET}"
                read domain
                if [ -n "$domain" ]; then
                    clear
                    echo -e "${CYAN}Running: dig +trace $domain${RESET}\n"
                    dig +trace $domain
                    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                    read
                fi
                ;;
            4)
                clear_queue
                clear
                echo -en "${YELLOW}Enter nameserver IP: ${RESET}"
                read ns
                echo -en "${YELLOW}Enter domain to test: ${RESET}"
                read domain
                if [ -n "$ns" ] && [ -n "$domain" ]; then
                    clear
                    echo -e "${CYAN}Running: dig @$ns $domain${RESET}\n"
                    dig @$ns $domain
                    echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                    read
                fi
                ;;
            5)
                clear_queue
                clear
                echo -e "${CYAN}Running: systemd-resolve --status | grep \"DNS Servers\" -A 5${RESET}\n"
                echo -e "${YELLOW}Current DNS configuration:${RESET}\n"
                systemd-resolve --status | grep "DNS Servers" -A 5
                echo -e "\n${YELLOW}Press Enter to continue...${RESET}"
                read
                ;;
            6)
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

dns_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          DNS Management${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} Service Management"
        echo -e "${GREEN}[2]${RESET} Configuration Files"
        echo -e "${GREEN}[3]${RESET} DNS Testing"
        echo -e "${GREEN}[4]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1) dns_service_menu ;;
            2) dns_config_menu ;;
            3) dns_testing_menu ;;
            4) return ;;
            *)
                echo -e "${RED}Invalid option: $choice${RESET}"
                clear_queue
                sleep 1
                ;;
        esac
    done
}