#!/bin/bash
#
# Advanced UFW Rules: A menu for more forging advanced UFW rules 
#
# Anthony Debbas, Charbel Rahme, Paul A. Estephan, Peter G. Chalhoub
# CVS:$Header$

Choose_Policy() {
  CHOICE=$(dialog --clear --title "Policy" --menu "Choose one of the following options: " 15 60 5 \
    1 "Allow" \
    2 "Deny" \
    3 "Reject" \
    4 "Limit" \
    5 "Return to Main Menu"--stdout)
  
  case $CHOICE in 
    1) 
      POLICY="allow"
      ;;
    2)
      POLICY="deny"
      ;;
    3)
      POLICY="reject"
      ;; 
    4)
      POLICY="limit"
      ;;
    5)
      return
      ;;
  esac
}
Choose_Direction() {
  CHOICE=$(dialog --title "Direction" --menu "Choose one of the following options: " 15 60 5 \
    1 "In" \
    2 "Out" \
    3 "Both" \
    4 "Return to Main Menu" --stdout)

  case $CHOICE in 
    1) 
      DIRECTION="in"
      ;;
    2) 
      DIRECTION="out"
      ;;
    3) 
      DIRECTION=("in" "out")
      ;;
    4)
      return
      ;;
  esac
}

Choose_Interfaces() {
  ls -1 /sys/class/net > INT
  LIST_INT=$(cat INT)
  CHOICE=$(dialog --title "Interfaces" --menu "Choose one of the following options: " 15 60 7 \
    1 "All interfaces" \
    $(awk '{print NR+1, $0}' INT) \
    $(( $(wc -l < INT) + 2 )) "Return to Main Menu" --stdout)

  case $CHOICE in 
    1)
      INTERFACES=""
      ;;
    *)
      INTERFACES=$(sed -n "$((CHOICE-1))p" INT)
      ;;
  esac
}

Service_Log_Choice() {
  CHOICE=$(dialog --title "Log" --menu "Choose one of the following options: " 15 60 7 \ 
    1 "Do Not Log" \
    2 "Ligt Log" \ 
    3 "Full Log" 
    4 "Return to Main Menu" --stdout)

    case $CHOICE in 
      1)
        LOG="off"
        ;;
      2)
        LOG="low"
        ;;
      3)
        LOG="full"
        ;;
      4)
        return
        ;;
    esac
}

Choose_Protocol() {
  CHOICE=$(dialog --title "Protocol" --menu "Choose one of the following options: " 15 60 7 \
    1 "TCP" \
    2 "UDP" \
    3 "Both" \
    4 "Return to Main Menu" --stdout )
  
  case $CHOICE in 
    1)
      PROTO="tcp"
      ;;
    2)
      PROTO="udp"
      ;;
    3)
      PROTO=""
      ;;
    4)
      return
      ;;
    esac
}

From_IP() {
  CHOICE=$(dialog --title "From IP" --menu "Choose one of the following options: " 15 60 3 \
    1 "Enter specific IP address" \
    2 "Any IP address" \
    3 "Return to Main Menu"  --stdout)

  case $CHOICE in 
    1)
      IP_PATTERN='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
      while true; do
        FROM_IP=$(dialog --inputbox "Enter the IP address: " 8 40 --stdout)
        
        if [[ $FROM_IP =~ $IP_PATTERN ]]; then
          break
        else
          dialog --msgbox "Invalid IP address. Please try again." 8 40
        fi
      done
      ;;
    2)
      FROM_IP="any"
      ;;
    3)
      return
      ;;
  esac
}

From_IP
