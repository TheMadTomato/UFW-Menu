#!/bin/bash
#
# Dependencies Check and Install: Check if UFW and Dialog libs are installed
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Check_If_Installed() {
  PACKAGE=$1
  if command -v $PACKAGE &>/dev/null; then
    echo "$PACKAGE is installed on this system" >> /tmp/dependency_check.log
    return 0
  else
    echo "$PACKAGE is not installed on this system" >> /tmp/dependency_check.log
    dialog --title "Dependency Check" --msgbox "$PACKAGE is not installed. Preparing to install..." 10 40
    sudo apt update && sudo apt install -y $PACKAGE
    if [[ $? -eq 0 ]]; then
      echo "Installation of $PACKAGE complete" >> /tmp/dependency_check.log
      dialog --title "Dependency Check" --msgbox "Installation of $PACKAGE complete." 10 40
      return 0
    else
      echo "Failed to install $PACKAGE" >> /tmp/dependency_check.log
      dialog --title "Dependency Check" --msgbox "Failed to install $PACKAGE. Please check the logs." 10 40
      return 1
    fi
  fi
}

Dependency_Check() {
  # Check and install dependencies
  dialog --title "Dependency Check" --infobox "Checking for dependencies..." 10 40
  sleep 1

  Check_If_Installed ufw
  UFW_STATUS=$?
  Check_If_Installed dialog
  DIALOG_STATUS=$?

  if [[ $UFW_STATUS -eq 0 && $DIALOG_STATUS -eq 0 ]]; then
    dialog --title "Dependency Check" --msgbox "All dependencies are installed. Continuing with the script..." 10 40
  else
    dialog --title "Dependency Check" --msgbox "Some dependencies could not be installed. Please check the log for details." 10 40
    exit 1
  fi
}



