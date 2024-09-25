#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU() {
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  else 
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  fi
  SERVICE=$($PSQL "select * from services")
  if [[ $SERVICE ]]
  then
    echo "$SERVICE" | while read SERVICE_ID BAR NAME
    do 
      echo "$SERVICE_ID) $NAME"
    done
  fi

  #select service
  read SERVICE_ID_SELECTED
  SERVICE_AVAILABILITY=$($PSQL "select name from services where service_id = $SERVICE_ID_SELECTED")
  if [[ $SERVICE_AVAILABILITY ]]
  then
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    
    #get phone number
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    
    #if phone number not exist
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi
    
    #set appointment time
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE_AVAILABILITY, $CUSTOMER_NAME"
    read SERVICE_TIME
    INSERT_APPOINTMENT_RESULT=$($PSQL "insert into appointments(time, customer_id,service_id) values('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")
    echo -e "\nI have put you down for a$SERVICE_AVAILABILITY at $SERVICE_TIME,$CUSTOMER_NAME."

  else
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
}

SERVICE_SELECTED(){
  echo Service selected
}
EXIT(){
  echo Thank you
}

MAIN_MENU