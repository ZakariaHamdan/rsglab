#!/bin/bash

ssh_menu() {
    while true; do
        clear
        show_zak_banner
        echo -e "${CYAN}${BOLD}==================================================${RESET}"
        echo -e "${CYAN}${BOLD}          SSH Connections${RESET}"
        echo -e "${CYAN}${BOLD}==================================================${RESET}\n"
        echo -e "${GREEN}[1]${RESET} SSH to Lab Gateway (PC-G)"
        echo -e "${GREEN}[2]${RESET} SSH to Lab Manager (PC-M)"
        echo -e "${GREEN}[3]${RESET} Back\n"
        echo -e "${CYAN}==================================================${RESET}"
        echo -en "${YELLOW}Select option: ${RESET}"
        choice=$(get_menu_choice)
        
        case $choice in
            1)
                clear_queue
                clear
                echo -e "${GREEN}Connecting to labgate...${RESET}\n"
                echo -e "ssh rsg@labgate"
                ssh rsg@labgate
                ;;
            2)
                clear
                echo -e "${GREEN}Connecting to labmngr...${RESET}\n"
                echo -e "ssh rsg@labmngr"
                ssh soc@labmngr
                ;;
            3)
                return
                ;;
            *)
                echo -e "${RED}Invalid option!${RESET}"
                sleep 1
                ;;
        esac
    done
}