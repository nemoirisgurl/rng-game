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
<<<<<<< HEAD
<<<<<<< HEAD
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
=======
    USER_IDT=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
>>>>>>> f8a0366... append users
=======
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
>>>>>>> e4b75d7... save user data
    # if not found
    if [[ -z "$USER_ID" ]]
    then
      # insert new user name
      INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(name) VALUES ('$USERNAME')")
      # welcome
      echo Welcome, $USERNAME! It looks like this is your first time here.
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> e4b75d7... save user data
    else
      # get history
      USER_HISTORY=$($PSQL "SELECT game_count, best_game_guesses FROM users WHERE name = '$USERNAME'")
      IFS="|" read GAMES BEST_RECORD <<< "$USER_HISTORY"
      # welcome back
      echo Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST_RECORD guesses.
<<<<<<< HEAD
=======
>>>>>>> f8a0366... append users
=======
>>>>>>> e4b75d7... save user data
    fi
  fi 
}

GAME() {
  # start game
  echo -e $1
  read GUESS
  # if integer between 1-1000
  if [[ ($GUESS -ge 1 || $GUESS -le 1000) && $GUESS =~ ^[0-9]+$ ]]
  then
    # give hints
    echo $RN
  else
    # ask to guess valid number
    GAME "\nThat is not an integer, guess again:"
  fi
}

GET_USERNAME
GAME "\nGuess the secret number between 1 and 1000:"