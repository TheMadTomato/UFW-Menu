#!/bin/bash
#
# UFW Functions: Library of bash functions that wraps UFW and IP-Tables functionalities
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

UFW_Exist () {
  echo -e "\033[32mChecking if UFW exists...\033[0m"
  if ! command -v ufw &> /dev/null; then
    # UFW is not installed
    # For Debian based systems
    sudo apt install ufw -y &> /dev/null
    if [[ $? -eq 0 ]]; then
      echo "UFW is now installed. You may proceed."  # Inform the dummy user that UFW is installed
    else
      echo "Failed to install UFW."  # Inform the dummy user that UFW installation failed
    fi
  else
    echo "UFW is already installed. To stop the process of checking if UFW is installed, comment out the UFW_Exist function in ufw_menu.sh."  # Inform a stupid user that UFW is already installed
  fi
}

UFW_Start () {
  sudo ufw enable > ufw_start.txt
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
  dialog --title "UFW Stop" --textbox ufw_stop.txt 22 70
  rm ufw_stop.txt
}

# UFW_Manage_Rule () {
#
# }

