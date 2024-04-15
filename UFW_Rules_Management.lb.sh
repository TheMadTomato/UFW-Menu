#!/bin/bash
#
# UFW Rules Managment: A library of bash functions to manage UFW rules and policies
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$


UFW_Allow_Service() {
  SERVICE_PATTERN='^((([0-9a-z]+)-?([0-9a-z]+)?)|([0-9]{1,5}))'
  SERVICES=$(dialog --title "Allow Service" --inputbox "Enter the service name(s) or port number(s) to allow (separated by spaces):" 10 60 --stdout)

  for SERVICE in $SERVICES; do
    if ! [[ $SERVICE =~ $SERVICE_PATTERN ]]; then
      printf "Error $LINENO:$0: Invalid Input."
      return 192
    fi
    if [[ $? -eq 0 ]]; then
      echo "[$(date)]: Allow Service:$SERVICE" >> /tmp/ufw-menu-logs/allowed_rules.log 
    else
      echo "[$(date)]: Allow Service:$SERVICE:FAILED" >> /tmp/ufw-menu-logs/allowed_rules.log 
    fi
    sudo ufw allow $SERVICE > allowed.txt 
    dialog --title "Allow Service" --textbox allowed.txt 22 70
    rm allowed.txt
  done
}

UFW_Block_Service() {
  SERVICE_PATTERN='^((([0-9a-z]+)-?([0-9a-z]+)?)|([0-9]{1,5}))'
  SERVICES=$(dialog --title "Deny Service" --inputbox "Enter the service name(s) or port number(s) to deny (separated by spaces):" 10 60 --stdout)

  for SERVICE in $SERVICES; do
    if ! [[ $SERVICE =~ $SERVICE_PATTERN ]]; then
      printf "Error $LINENO:$0: Invalid Input."
      return 192
    fi 
    if [[ $? -eq 0 ]]; then
      echo "[$(date)]: Deny Service:$SERVICE" >> /tmp/ufw-menu-logs/denied_rules.log 
    else 
      echo "[$(date)]: Deny Service:$SERVICE:FAILED" >> /tmp/ufw-menu-logs/denied_rules.log 
    fi
    sudo ufw deny $SERVICE > blocked.txt 
    dialog --title "Deny Service" --textbox blocked.txt 22 70 
    rm blocked.txt
  done
}

UFW_View_Services() {
  echo "[$(date)]: Service Viewed" >> /tmp/ufw-menu-logs/viewed_rules.log
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
        printf "Error $LINENO:$0: Invalid Input."
        return 192
      fi
      echo "[$(date)] >>>" >> /tmp/ufw-menu-logs/delete_rules.log
      sudo ufw delete $RULE_NUMBER <<< "y" &>> /tmp/ufw-menu-logs/delete_rules_log
    done

    if [[ $? -eq 0 ]]; then
      dialog --title "Delete Rule" --msgbox "Rules deleted successfully." 10 40
    else
      dialog --title "Delete Rule" --msgbox "Error encountered. Please check the delete_rules_log file in the /tmp/ufw-menu-logs directory for more details." 10 60
      return
    fi

  break 
  done
}

Default_Rules_Setup() {
  # Display starting message
  dialog --title "Default Rules Setup" --msgbox "Starting default rules setup..." 10 40

  # Deny incoming traffic
  echo "$(date) - Applying default rules: Deny incoming traffic" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw default deny incoming > /dev/null

  # Allow outgoing traffic
  echo "$(date) - Applying default rules: Allow outgoing traffic" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw default allow outgoing > /dev/null

  # Allow typical ports
  echo "$(date) - Applying default rules: Allow SSH" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw allow ssh > /dev/null
  echo "$(date) - Applying default rules: Allow HTTP" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw allow http > /dev/null
  echo "$(date) - Applying default rules: Allow port 8080" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw allow 8080 > /dev/null
  echo "$(date) - Applying default rules: Allow HTTPS" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw allow https > /dev/null

  # Deny vulnerable ports
  echo "$(date) - Applying default rules: Deny port 23" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw deny 23 > /dev/null
  echo "$(date) - Applying default rules: Deny port 445" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw deny 445 > /dev/null
  echo "$(date) - Applying default rules: Deny port 1433" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw deny 1433 > /dev/null
  echo "$(date) - Applying default rules: Deny port 3306" >> /tmp/ufw-menu-logs/default_rule.log
  sudo ufw deny 3306 > /dev/null

  # Display finishing message
  dialog --title "Default Rules Setup" --msgbox "Default rules setup completed." 10 40

  echo "$(date) - Default rules applied successfully" >> /tmp/ufw-menu-logs/default_rule.log
}

UFW_Reset_Rules() {
  dialog --title "Reset Rules" --yesno "Are you sure you want to reset all UFW rules?" 10 40
  RESPONSE=$?
  if [ $RESPONSE -eq 0 ]; then
    echo "[$(date)] >>>" >> /tmp/ufw-menu-logs/reset.log
    sudo ufw reset <<< "y" &>> /tmp/ufw-menu-logs/reset.log
    dialog --title "Reset Rules" --msgbox "UFW rules have been reset." 10 40
  fi
}

Rules_Managment_Menu() {
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

