#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ Doc's Barber Shop Scheduler ~~~~~\n\n"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo $1
  fi
  echo -e "Please select a service number below:\n\n1) Haircut\n2) Beard Trim\n3) Razor Shave"
  read SERVICE_ID_SELECTED
  # check if ID is valid
  if [[ $SERVICE_ID_SELECTED != [1-3] ]]
  then
    # if not valid
    MAIN_MENU "I could not find that service. What would you like today?"
  fi
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat is your phone number?"
  # read customer phone number
  read CUSTOMER_PHONE
  # check for customer account
  CUSTOMER_ID_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID_RESULT ]]
  then
    # if no account ask for Name
    echo -e "\nI  couldn't find that phone number. What is your name?"
    read CUSTOMER_NAME
    # add customer to database
    ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    # get new customer ID
    CUSTOMER_ID_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID_RESULT")
  fi
  # read what time they'd like their appointment for
  echo -e "What time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  # add appointment to database
  ADD_APP_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_RESULT, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  # let customer know their appointment details
  echo -e "\nI have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  exit
}
MAIN_MENU