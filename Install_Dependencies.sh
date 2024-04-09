#!/bin/bash
#
# Dependencies Check and Install: Check if UFW and Dialog libs are installed
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Check_If_Installed() {
  command -v $1 &>/dev/null 
  if [[ $? -eq 0 ]]; then 
    printf "%s is installed on this system" $1 
    return
  elif [[ $? -eq 127 ]]; then
    printf "%s is not installed on this system" $1 
    printf "\nPreparing for install..."
    sudo apt install $1 -y 
    if [[ $? -eq 0 ]]; then echo "Install Complete";fi 
  else 
    printf "Unexpected Error."
  fi

}


