#!/bin/bash
#
# UFW Functions: Library of bash functions that wraps UFW and IP-Tables functionalities
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

UFW_Start () {
  local temp_file
  temp_file=$(mktemp)

  if sudo ufw enable > "$temp_file" 2>&1; then
    local status="success"
    local message="UFW enabled"
  else
    local status="failure"
    local message="Failed to enable UFW"
  fi

  echo "[$(date)]: $message" | sudo tee -a "$LOG_DIR/ufw_status.log"
  dialog --title "UFW Start" --textbox "$temp_file" 22 70
  rm "$temp_file"
}

UFW_Status_Check () {
  local temp_file
  temp_file=$(mktemp)

  sudo systemctl status ufw > "$temp_file" 2>&1
  dialog --title "UFW Status" --textbox "$temp_file" 22 70
  rm "$temp_file"
}

UFW_Stop () {
  local temp_file
  temp_file=$(mktemp)

  if sudo ufw disable > "$temp_file" 2>&1; then
    local status="success"
    local message="UFW disabled"
  else
    local status="failure"
    local message="Failed to disable UFW"
  fi

  echo "[$(date)]: $message" | sudo tee -a "$LOG_DIR/ufw_status.log"
  dialog --title "UFW Stop" --textbox "$temp_file" 22 70
  rm "$temp_file"
}

UFW_ON_OFF () {
  CHOICE=$(dialog --clear --backtitle "UFW Disable/Enable Menu" --title "Disable/Enable Menu" --menu "Choose one of the following options:" 15 60 4 \
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

