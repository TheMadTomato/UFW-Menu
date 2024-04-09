#!/bin/bash
#
# UFW_Menu: A CLI configuration menu for ufw and iptables to automate firewall managment
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

set -uo pipefail
source "/home/$USER/UFW-Menu/ufw_functions.lb.sh"
source "/home/$USER/UFW-Menu/ICMP_Block.sh"
source "/home/$USER/UFW-Menu/UFW_Rules_Management.lb.sh"
source "/home/$USER/UFW-Menu/Install_Dependencies.sh"

# Check if Requirments are installed  
# Check_If_Installed dialog
# Check_If_Installed ufw 

while true; do
    CHOICE=$(dialog --clear --backtitle "UFW Configuration Menu" --title "UFW Menu" --menu "Choose one of the following options:" 15 60 4 \
    1 "Start UFW" \
    2 "Check UFW Status" \
    3 "Disable UFW" \
    4 "Manage UFW Rules" \
    5 "Manage Incoming ICMP Requests" \
    6 "Quit" 2>&1 >/dev/tty)

    clear
    case $CHOICE in
        1)
            UFW_Start
            ;;
        2)
            UFW_Status_Check
            ;;
        3)
            UFW_Stop
            ;;
        4)
            Rules_Managment_Menu
            ;;
        5)
            Manage_ICMP
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
    esac
    read -p "Press enter to continue"
done



