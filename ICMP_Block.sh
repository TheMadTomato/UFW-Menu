#!/bin/bash
#
# ICMP Block: A function to make UFW disable ICMP request for elevating security by obscurity 
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Block_ICMP() {
  read -p "Do you want to disable ICMP therefor blocking ping requests to this server? (y|n): " CHOICE

  declare BACKUP_DATE=`date '+%Y%m%d_%H%M%S'`

  if [[ $CHOICE == "y" || $CHOICE == "Y" ]]; then 
    printf "Taking a backup file of the original /etc/ufw/before.rules...\n"
    sudo cp /etc/ufw/before.rules /etc/ufw/before.rules_${BACKUP_DATE}

    sudo sed -i '34,37s/ACCEPT/DROP/g' /etc/ufw/before.rules

    sudo ufw reload
  elif [[ $CHOICE == "n" || $CHOICE == "N" ]]; then 
    printf "Canceling..."
  else 
    printf "Error $LINENO:$0: Invalid Input."
    return 192
  fi 
}

Unblock_ICMP() {
  read -p "Do you want to enable ICMP therefor blocking ping requests to this server? (y|n): " CHOICE

  declare BACKUP_DATE=`date '+%Y%m%d_%H%M%S'`

  if [[ $CHOICE == "y" || $CHOICE == "Y" ]]; then 
    printf "Taking a backup file of the original /etc/ufw/before.rules...\n"
    sudo cp /etc/ufw/before.rules /etc/ufw/before.rules_${BACKUP_DATE}

    sudo sed -i '34,37s/DROP/ACCEPT/g' /etc/ufw/before.rules

    sudo ufw reload
  elif [[ $CHOICE == "n" || $CHOICE == "N" ]]; then 
    printf "Canceling..."
  else 
    printf "Error $LINENO:$0: Invalid Input."
    return 192 
  fi 
}

Manage_ICMP() {
  CHOICE=$(dialog --clear --backtitle "Manage ICMP" --title "ICMP Menu" --menu "Choose one of the following options:" 15 60 4 \
  1 "Block ICMP to the Server" \
  2 "Unblock ICMP to the Server" \
  3 "Return to Main Menu" 2>&1 >/dev/tty)

  case $CHOICE in 
    1) 
      Block_ICMP
      ;;
    2)
      Unblock_ICMP
      ;;
    3) 
      # bash /home/$USER/Linux_Proj/ufw_menu.sh
      return
      ;;
  esac
  dialog --clear
}

