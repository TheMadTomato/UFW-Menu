#!/bin/bash
#
# UFW Rules Managment: A library of bash functions to manage UFW rules and policies
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

# List_Available_Service () {
#
# }

UFW_Allow_Service() {
  SERVICE_PATTERN='^((([0-9a-z]+)-?([0-9a-z]+)?)|([0-9]{1,5}))'
  SERVICES=$(dialog --title "Allow Service" --inputbox "Enter the service name(s) or port number(s) to allow (separated by spaces):" 10 60 --stdout)

  for SERVICE in $SERVICES; do
    if ! [[ $SERVICE =~ $SERVICE_PATTERN ]]; then
      printf "Error $LINENO:$0: Invalid Input."
      return 192
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
    sudo ufw deny $SERVICE > blocked.txt 
    dialog --title "Deny Service" --textbox blocked.txt 22 70 
    rm blocked.txt
  done
}

UFW_View_Services() {
  sudo ufw status numbered > services.txt 
  dialog --title "UFW Services" --textbox services.txt 22 70
  rm services.txt 
}

UFW_Delete_Rule() {
  set noglobber
  UFW_View_Services

  while true; do
    RULE_NUMBERS=$(dialog --title "Delete Rule" --inputbox "Enter the number(s) of the rule(s) to delete (separated by spaces), or type 'back' to go back to view services:" 10 60 --stdout)

    if [ "$RULE_NUMBERS" == "back" ]; then
      UFW_View_Services
      continue
    fi

    if [ ! -d "/tmp/ufw-menu-logs" ]; then
      mkdir -p /tmp/ufw-menu-logs
    fi

    for RULE_NUMBER in $RULE_NUMBERS; do
      if ! [[ $RULE_NUMBER =~ ^[0-9]+$ ]]; then
        printf "Error $LINENO:$0: Invalid Input."
        return 192
      fi 

      sudo ufw delete $RULE_NUMBER <<< "y" &> /tmp/ufw-menu-logs/delete_rules_log
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

Rules_Managment_Menu() {
  CHOICE=$(dialog --clear --backtitle "Manage Rules" --title "Rules Management Menu" --menu "Choose one of the following options:" 15 60 5 \
  "1" "Allow Service" \
  "2" "Block Service" \
  "3" "View Services" \
  "4" "Delete Rule" \
  "5" "Exit" 2>&1 >/dev/tty )

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
      return
      ;;
  esac
}

