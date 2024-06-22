#!/bin/bash
#
# UFW Rules Management: A library of bash functions to manage UFW rules and policies
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

UFW_Allow_Service() {
  SERVICE_PATTERN='^((([0-9a-z]+)-?([0-9a-z]+)?)|([0-9]{1,5}))'
  SERVICES=$(dialog --title "Allow Service" --inputbox "Enter the service name(s) or port number(s) to allow (separated by spaces):" 10 60 --stdout)

  for SERVICE in $SERVICES; do
    if ! [[ $SERVICE =~ $SERVICE_PATTERN ]]; then
      dialog --msgbox "Error: Invalid input for service name or port number." 10 40
      echo "[$(date)]: Invalid input for service name or port number: $SERVICE" | sudo tee -a "$LOG_DIR/allowed_rules.log"
      return 192
    fi

    if sudo ufw allow $SERVICE > allowed.txt; then
      echo "[$(date)]: Allowed service: $SERVICE" | sudo tee -a "$LOG_DIR/allowed_rules.log"
      dialog --title "Allow Service" --textbox allowed.txt 22 70
    else
      echo "[$(date)]: Failed to allow service: $SERVICE" | sudo tee -a "$LOG_DIR/allowed_rules.log"
      dialog --msgbox "Failed to allow service: $SERVICE" 10 40
    fi
    rm allowed.txt
  done
}

UFW_Block_Service() {
  SERVICE_PATTERN='^((([0-9a-z]+)-?([0-9a-z]+)?)|([0-9]{1,5}))'
  SERVICES=$(dialog --title "Deny Service" --inputbox "Enter the service name(s) or port number(s) to deny (separated by spaces):" 10 60 --stdout)

  for SERVICE in $SERVICES; do
    if ! [[ $SERVICE =~ $SERVICE_PATTERN ]]; then
      dialog --msgbox "Error: Invalid input for service name or port number." 10 40
      echo "[$(date)]: Invalid input for service name or port number: $SERVICE" | sudo tee -a "$LOG_DIR/denied_rules.log"
      return 192
    fi

    if sudo ufw deny $SERVICE > blocked.txt; then
      echo "[$(date)]: Denied service: $SERVICE" | sudo tee -a "$LOG_DIR/denied_rules.log"
      dialog --title "Deny Service" --textbox blocked.txt 22 70
    else
      echo "[$(date)]: Failed to deny service: $SERVICE" | sudo tee -a "$LOG_DIR/denied_rules.log"
      dialog --msgbox "Failed to deny service: $SERVICE" 10 40
    fi
    rm blocked.txt
  done
}

UFW_View_Services() {
  echo "[$(date)]: Services viewed" | sudo tee -a "$LOG_DIR/viewed_rules.log"
  sudo ufw status numbered > services.txt
  dialog --title "UFW Services" --textbox services.txt 22 70
  rm services.txt
}

UFW_Delete_Rule() {
  UFW_View_Services

  while true; do
    RULE_NUMBERS=$(dialog --title "Delete Rule" --inputbox "Enter the number(s) of the rule(s) to delete (separated by spaces, in reverse order), or type 'back' to go back to view services:" 10 60 --stdout)

    if [ "$RULE_NUMBERS" == "back" ]; then
      UFW_View_Services
      continue
    fi

    for RULE_NUMBER in $RULE_NUMBERS; do
      if ! [[ $RULE_NUMBER =~ ^[0-9]+$ ]]; then
        dialog --msgbox "Error: Invalid rule number." 10 40
        echo "[$(date)]: Invalid rule number: $RULE_NUMBER" | sudo tee -a "$LOG_DIR/delete_rules.log"
        return 192
      fi
      sudo ufw delete $RULE_NUMBER <<< "y" &>> "$LOG_DIR/delete_rules.log"
    done

    if [[ $? -eq 0 ]]; then
      dialog --title "Delete Rule" --msgbox "Rules deleted successfully." 10 40
      echo "[$(date)]: Deleted rules: $RULE_NUMBERS" | sudo tee -a "$LOG_DIR/delete_rules.log"
    else
      dialog --title "Delete Rule" --msgbox "Error encountered. Please check the delete_rules.log file in the $LOG_DIR directory for more details." 10 60
      return
    fi

    break 
  done
}

Default_Rules_Setup() {
  dialog --title "Default Rules Setup" --msgbox "Starting default rules setup..." 10 40

  {
    echo "$(date) - Applying default rules: Deny incoming traffic"
    sudo ufw default deny incoming > /dev/null

    echo "$(date) - Applying default rules: Allow outgoing traffic"
    sudo ufw default allow outgoing > /dev/null

    echo "$(date) - Applying default rules: Allow SSH"
    sudo ufw allow ssh > /dev/null

    echo "$(date) - Applying default rules: Allow HTTP"
    sudo ufw allow http > /dev/null

    echo "$(date) - Applying default rules: Allow port 8080"
    sudo ufw allow 8080 > /dev/null

    echo "$(date) - Applying default rules: Allow HTTPS"
    sudo ufw allow https > /dev/null

    echo "$(date) - Applying default rules: Deny port 23"
    sudo ufw deny 23 > /dev/null

    echo "$(date) - Applying default rules: Deny port 445"
    sudo ufw deny 445 > /dev/null

    echo "$(date) - Applying default rules: Deny port 1433"
    sudo ufw deny 1433 > /dev/null

    echo "$(date) - Applying default rules: Deny port 3306"
    sudo ufw deny 3306 > /dev/null

    echo "$(date) - Default rules applied successfully"
  } | sudo tee -a "$LOG_DIR/default_rule.log"

  dialog --title "Default Rules Setup" --msgbox "Default rules setup completed." 10 40
}

UFW_Reset_Rules() {
  dialog --title "Reset Rules" --yesno "Are you sure you want to reset all UFW rules?" 10 40
  if [ $? -eq 0 ]; then
    echo "[$(date)] >>> Resetting UFW rules" | sudo tee -a "$LOG_DIR/reset.log"
    sudo ufw reset <<< "y" &>> "$LOG_DIR/reset.log"
    dialog --title "Reset Rules" --msgbox "UFW rules have been reset." 10 40
  fi
}

Rules_Management_Menu() {
  CHOICE=$(dialog --clear --backtitle "Manage Rules" --title "Rules Management Menu" --menu "Choose one of the following options:" 15 60 6 \
  "1" "Allow Service" \
  "2" "Block Service" \
  "3" "View Services" \
  "4" "Delete Rule" \
  "5" "Reset Rules" \
  "6" "Load Default Rules" \
  "7" "Return to Main Menu" --stdout )

  case $CHOICE in
    1)
      UFW_Allow_Service
      ;;
    2)
      UFW_Block_Service
      ;;
    3)
      UFW_View_Services
      ;;
    4)
      UFW_Delete_Rule
      ;;
    5)
      UFW_Reset_Rules
      ;;
    6)
      Default_Rules_Setup
      ;;
    7)
      return
      ;;
  esac
}

