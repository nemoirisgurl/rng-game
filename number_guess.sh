#!/bin/bash

DB_USER="freecodecamp"
DB_NAME="postgres"
PSQL="psql -U $DB_USER -d $DB_NAME -t -A -c"
RN=$(( 1 + $RANDOM % 1000 ))

GET_USERNAME() {
  echo -e "Enter your username:\n"
  read USERNAME
}

GET_USERNAME