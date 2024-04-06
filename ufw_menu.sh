#!/bin/bash
#
# UFW_Menu: A CLI configuration menu for ufw and iptables to automate firewall managment
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

# Function to install dialog
install_dialog() {
    echo "Installing dialog..."
    python3 install_dialog.py  # Call the Python script to install dialog
}

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
    install_dialog  # Install dialog if not installed
fi

set -ueo pipefail
source "/home/$USER/UFW-Menu/ufw_functions.lb.sh"
source "/home/$USER/UFW-Menu/ICMP_Block.sh"

# Check if UFW is installed on the system
UFW_Exist

while true; do
    CHOICE=$(dialog --clear --backtitle "UFW Configuration Menu" --title "UFW Menu" --menu "Choose one of the following options:" 15 60 4 \
    1 "Start UFW" \
    2 "Check UFW Status" \
    3 "Disable UFW" \
    4 "List UFW Rules" \
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
            sudo ufw status numbered
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

