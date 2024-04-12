#!/bin/bash
#
# UFW_Menu: A CLI configuration menu for ufw and iptables to automate firewall managment
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Check_If_LogDir_Exist() {
 if [ ! -d "/tmp/ufw-menu-logs" ]; then
     mkdir -p /tmp/ufw-menu-logs
 fi
}

Logs_Info() {
  LOGS_DISK_SPACE=$(ls -l /tmp/ufw-menu-logs/ | awk '{sum+=$5} END {print sum}')
  LOGS_FILES_COUNT=$(ls -1 /tmp/ufw-menu-logs/ | wc -l)
  LOGS_LAST_EDIT=$(ls -l /tmp/ufw-menu-logs/ | awk 'BEGIN{printf "%-20s %-20s\n", "FILENAME", "LAST_TIME_MODIFIED"} {printf "%-20s %-20s\n", $9, $8}')

  dialog --title "Logs Information" --msgbox "Logs Total Size: $LOGS_DISK_SPACE Bytes\nFiles Count: $LOGS_FILES_COUNT\nLast Edit:\n$LOGS_LAST_EDIT" 10 40
}

Backup_Logs() {
  INPUT_PATH=$(dialog --title "Enter Input Path" --inputbox "Enter the path where you want to save the logs backup:" 10 40 --stdout)
  tar -czvf "$INPUT_PATH/ufw-menu-logs.tar.gz" -C /tmp ufw-menu-logs
  dialog --title "Backup Complete" --msgbox "Logs backup created successfully." 10 40
}

Delete_Logs() {
  for FILE in /tmp/ufw-menu-logs/*; do
    if [ -f "$FILE" ]; then
      dialog --title "Delete Log File" --yesno "Do you want to delete the file: $FILE?" 10 40
      RESP=$?
      if [ $RESP -eq 0 ]; then
        rm "$FILE"
        dialog --title "File Deleted" --msgbox "File $FILE deleted successfully." 10 40
      else
        dialog --title "File Kept" --msgbox "File $FILE kept." 10 40
      fi
    fi
  done
}

List_Logs(){
  LOG_FILES=$(ls -1 /tmp/ufw-menu-logs/)
  dialog --title "Log Files" --msgbox "$LOG_FILES" 10 40
}

Read_Logs() {
  List_Logs

  FILE_PATH=$(dialog --title "Enter File Name" --inputbox "Enter the name of the log file:" 10 40 --stdout)
  if [ -f "/tmp/ufw-menu-logs/$FILE_PATH" ]; then
    dialog --title "Log File: $FILE_PATH" --textbox "/tmp/ufw-menu-logs/$FILE_PATH" 20 60
  else
    dialog --title "File Not Found" --msgbox "The specified log file does not exist." 10 40
  fi
}

Logs_Managment() {
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