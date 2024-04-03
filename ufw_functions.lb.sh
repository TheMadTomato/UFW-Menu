#!/bin/bash 
#
# UFW Functions: Library of bash functions that wraps UFW and IP-Tables functionalities
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

UFW_Exist (){
  printf "\033[32mChecking if UFW exists...\033[0m\n"
  # Scrap the default error message
  sudo ufw &> /dev/null 
  # if not exist error: 127  install ufw 
  if [[ $? -eq 127 ]]; then 
    # For Debian based systems 
    sudo apt install ufw -y &> /dev/null 
    if [[ $? -eq 0 ]]; then 
      printf "UFW is now installed.\n You may proceed."
    fi
  elif [[ $? -eq 1 ]]; then 
    printf "UFW is already installed. To stop the process of checking if UFW is installed comment the UFW_Exist function in ufw_menu.sh"
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


