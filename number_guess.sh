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
  else
    # get user id
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
    # if not found
    if [[ -z "$USER_ID" ]]
    then
      # insert new user name
      INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(name) VALUES ('$USERNAME')")
      # welcome
      echo Welcome, $USERNAME! It looks like this is your first time here.
    else
      # get history
      USER_HISTORY=$($PSQL "SELECT game_count, best_game_guesses FROM users WHERE name = '$USERNAME'")
      IFS="|" read GAMES BEST_RECORD <<< "$USER_HISTORY"
      # welcome back
      echo Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST_RECORD guesses.
    fi
  fi 
}

GET_USERNAME