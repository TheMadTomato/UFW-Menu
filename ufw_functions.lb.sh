#!/bin/bash
#
# UFW Functions: Library of bash functions that wraps UFW and IP-Tables functionalities
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

<<<<<<< HEAD
=======
UFW_Exist () {
  echo -e "\033[32mChecking if UFW exists...\033[0m"
  if ! command -v ufw &> /dev/null; then
    # UFW is not installed
    # Call Python script to install UFW
    python3 install_check_ufw.py
  else
    echo "UFW is already installed. You may proceed."
  fi
}

>>>>>>> b39ad99a13918910d9dc7844c5b372138db6b716
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

