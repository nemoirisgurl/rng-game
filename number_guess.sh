#!/bin/bash

DB_USER="freecodecamp"
DB_NAME="postgres"
PSQL="psql -U $DB_USER --d $DB_NAME -t -A -c"
RN=$(( 1 + $RANDOM % 1000 ))

GET_USERNAME() {
  # get username
  echo -e "Enter your username:\n"
  read USERNAME
  # if not found
  if [[ -z "$USERNAME" ]]
  then
    # prompt again
    GET_USERNAME 
  fi 
}

GET_USERNAME