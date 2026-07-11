#!/bin/bash
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "Welcome to My Salon, how can I help you?\n"
  fi

  echo -e "1) cut\n2) color\n3) perm\n4) style\n5) trim"
  
  read SERVICE_ID_SELECTED
  if (( $SERVICE_ID_SELECTED > 0 && $SERVICE_ID_SELECTED <= 5 ))
  then
    case $SERVICE_ID_SELECTED in
    '1')SERVICE='cut';;
    '2')SERVICE='color';;
    '3')SERVICE='perm';;
    '4')SERVICE='style';;
    '5')SERVICE='trim';;
    esac
    PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    else 
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id='$CUSTOMER_ID'")
    fi

    echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE name='$SERVICE'")
    APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID,'$SERVICE_TIME')")

    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  else 
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
}
MAIN_MENU