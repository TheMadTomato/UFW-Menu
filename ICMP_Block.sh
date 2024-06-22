#!/bin/bash
#
# ICMP Block: A function to make UFW disable ICMP requests for elevating security by obscurity 
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Block_ICMP() {
  CHOICE=$(dialog --stdout --title "Block ICMP" --yesno "Do you want to disable ICMP therefore blocking ping requests to this server?" 7 60)

  local backup_date
  backup_date=$(date '+%Y%m%d_%H%M%S')

  if [ $? -eq 0 ]; then 
    dialog --infobox "Taking a backup of the original /etc/ufw/before.rules..." 5 50
    sudo cp /etc/ufw/before.rules /etc/ufw/before.rules_${backup_date}
    echo "[$(date)]: /etc/ufw/before.rules backup is created" | sudo tee -a "$LOG_DIR/ICMP.log"

    sudo sed -i '34,37s/ACCEPT/DROP/g' /etc/ufw/before.rules
    echo "[$(date)]: /etc/ufw/before.rules is edited; Ping is Blocked" | sudo tee -a "$LOG_DIR/ICMP.log"

    sudo ufw reload
    dialog --msgbox "ICMP requests have been blocked. /etc/ufw/before.rules has been updated." 7 60
  else 
    dialog --msgbox "Canceling..." 5 30
  fi 
}

Unblock_ICMP() {
  CHOICE=$(dialog --stdout --title "Unblock ICMP" --yesno "Do you want to enable ICMP therefore allowing ping requests to this server?" 7 60)

  local backup_date
  backup_date=$(date '+%Y%m%d_%H%M%S')

  if [ $? -eq 0 ]; then 
    dialog --infobox "Taking a backup of the original /etc/ufw/before.rules..." 5 50
    sudo cp /etc/ufw/before.rules /etc/ufw/before.rules_${backup_date}
    echo "[$(date)]: /etc/ufw/before.rules backup is created" | sudo tee -a "$LOG_DIR/ICMP.log"

    sudo sed -i '34,37s/DROP/ACCEPT/g' /etc/ufw/before.rules
    echo "[$(date)]: /etc/ufw/before.rules is edited; Ping is Unblocked" | sudo tee -a "$LOG_DIR/ICMP.log"

    sudo ufw reload
    dialog --msgbox "ICMP requests have been enabled. /etc/ufw/before.rules has been updated." 7 60
  else 
    dialog --msgbox "Canceling..." 5 30
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
      return
      ;;
  esac
  dialog --clear
}

