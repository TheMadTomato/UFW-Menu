#!/bin/bash
#
# UFW_Menu: A CLI configuration menu for ufw and iptables to automate firewall management
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Check_If_LogDir_Exist() {
  if [ ! -d "$LOG_DIR" ]; then
    sudo mkdir -p "$LOG_DIR"
    sudo chown root:root "$LOG_DIR"
    sudo chmod 755 "$LOG_DIR"
  fi
}

Logs_Info() {
  LOGS_DISK_SPACE=$(sudo du -sh "$LOG_DIR" | awk '{print $1}')
  LOGS_FILES_COUNT=$(sudo ls -1 "$LOG_DIR" | wc -l)
  LOGS_LAST_EDIT=$(sudo ls -lt "$LOG_DIR" | awk 'BEGIN {printf "%-20s %-20s\n", "FILENAME", "LAST_TIME_MODIFIED"} {printf "%-20s %-20s\n", $9, $6 " " $7 " " $8}')

  dialog --title "Logs Information" --msgbox "Logs Total Size: $LOGS_DISK_SPACE\nFiles Count: $LOGS_FILES_COUNT\nLast Edit:\n$LOGS_LAST_EDIT" 20 60
}

Backup_Logs() {
  INPUT_PATH=$(dialog --title "Enter Input Path" --inputbox "Enter the path where you want to save the logs backup:" 10 40 --stdout)
  sudo tar -czvf "$INPUT_PATH/ufw-menu-logs.tar.gz" -C /var/log ufw-menu-logs
  dialog --title "Backup Complete" --msgbox "Logs backup created successfully." 10 40
}

Delete_Logs() {
  for FILE in "$LOG_DIR"/*; do
    if [ -f "$FILE" ]; then
      dialog --title "Delete Log File" --yesno "Do you want to delete the file: $FILE?" 10 40
      RESP=$?
      if [ $RESP -eq 0 ]; then
        sudo rm "$FILE"
        dialog --title "File Deleted" --msgbox "File $FILE deleted successfully." 10 40
      else
        dialog --title "File Kept" --msgbox "File $FILE kept." 10 40
      fi
    fi
  done
}

List_Logs(){
  LOG_FILES=$(sudo ls -1 "$LOG_DIR")
  dialog --title "Log Files" --msgbox "$LOG_FILES" 10 40
}

Read_Logs() {
  List_Logs

  FILE_PATH=$(dialog --title "Enter File Name" --inputbox "Enter the name of the log file:" 10 40 --stdout)
  if [ -f "$LOG_DIR/$FILE_PATH" ]; then
    dialog --title "Log File: $FILE_PATH" --textbox "$LOG_DIR/$FILE_PATH" 40 60
  else
    dialog --title "File Not Found" --msgbox "The specified log file does not exist." 10 40
  fi
}

Logs_Management() {
  Check_If_LogDir_Exist

  while true; do
    choice=$(dialog --title "UFW Menu - Log Management" --menu "Choose an option:" 15 40 6 \
      1 "Logs Information" \
      2 "Backup Logs" \
      3 "Delete Logs" \
      4 "Read Logs" \
      5 "Return to Main Menu" \
      --stdout)

    case $choice in
      1) Logs_Info ;;
      2) Backup_Logs ;;
      3) Delete_Logs ;;
      4) Read_Logs ;;
      5) return ;;
    esac
  done
}


