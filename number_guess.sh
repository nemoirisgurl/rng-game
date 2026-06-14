#!/bin/bash

DB_USER="freecodecamp"
DB_NAME="postgres"
PSQL="psql -U $DB_USER --d $DB_NAME -t -A -c"
RN=$(( 1 + $RANDOM % 1000 ))
TIME_GUESSED=0

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
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
      # welcome
      echo Welcome, $USERNAME! It looks like this is your first time here.
    else
      # get history
      USER_HISTORY=$($PSQL "SELECT game_count, best_game_guesses FROM users WHERE name = '$USERNAME'")
      IFS="|" read GAMES BEST_RECORD <<< "$USER_HISTORY"
      # welcome back
      echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST_RECORD guesses."
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
    if (( GUESS > $RN ))
    then
      TIME_GUESSED=$(( TIME_GUESSED + 1 ))
      GAME "\nIt's lower than that, guess again: "
    elif (( GUESS < $RN )) 
    then
      TIME_GUESSED=$(( TIME_GUESSED + 1 ))
      GAME "\nIt's higher than that, guess again: "
    else
      echo -e "\nYou guessed it in $(( TIME_GUESSED + 1 )) tries. The secret number was $RN. Nice job!"
      UPDATE_USER_RESULT=$($PSQL "UPDATE users SET game_count = game_count + 1, best_game_guesses = LEAST(best_game_guesses,$TIME_GUESSED) WHERE user_id = $USER_ID")
    fi
  else
    # ask to guess valid number
    GAME "\nThat is not an integer, guess again:"
  fi
}

GET_USERNAME
GAME "\nGuess the secret number between 1 and 1000:"