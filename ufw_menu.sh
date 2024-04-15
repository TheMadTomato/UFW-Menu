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
source "/home/$USER/UFW-Menu/Log_Managment.lb.sh"

Check_If_LogDir_Exist

# Check if Requirments are installed  
# Check_If_Installed dialog
# Check_If_Installed ufw 

while true; do
    CHOICE=$(dialog --clear --backtitle "UFW Configuration Menu" --title "UFW Menu" --menu "Choose one of the following options:" 15 60 5 \
    1 "Disable/Enable UFW" \
    2 "Check UFW Status" \
    3 "Manage UFW Rules" \
    4 "Manage Incoming ICMP Requests" \
    5 "Manage Logs" \
    6 "Quit" --stdout)

    clear
    case $CHOICE in
        1)
            UFW_ON_OFF
            ;;
        2)
            UFW_Status_Check
            ;;
        3)
            Rules_Managment_Menu
            ;;
        4)
            Manage_ICMP
            ;;
        5)
            Logs_Managment
            ;;
        6)
            echo "Exiting..."
            exit 0
            ;;
    esac
    read -p "Press enter to continue"
done

