#!/bin/bash
#
# UFW Functions: Library of bash functions that wraps UFW and IP-Tables functionalities
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

UFW_Start () {
  sudo ufw enable > ufw_start.txt
  echo "[$(date)]: UFW enabled" >> /tmp/ufw-menu-logs/ufw_status.log
  dialog --title "UFW Start" --textbox ufw_start.txt 22 70
  rm ufw_start.txt
}

UFW_Status_Check () {
  sudo systemctl status ufw > ufw_status.txt
  dialog --title "UFW Status" --textbox ufw_status.txt 22 70
  rm ufw_status.txt
}

UFW_Stop () {
  sudo ufw disable > ufw_stop.txt
  echo "[$(date)]: UFW disabled" >> /tmp/ufw-menu-logs/ufw_status.log
  dialog --title "UFW Stop" --textbox ufw_stop.txt 22 70
  rm ufw_stop.txt
}


UFW_ON_OFF () {
  CHOICE=$(dialog --clear --backtitle "UFW Disable/Enable Menu" --title "Disable/Enable Menu" --menu "Choos One of the following options:" 15 60 4 \
  1 "Enable UFW" \
  2 "Disable UFW" \
  3 "Return to Main Menu" --stdout)

  clear
  case $CHOICE in 
    1) 
      UFW_Start
      ;;
    2) 
      UFW_Stop
      ;;
    3) 
      return
      ;; 
  esac
}

