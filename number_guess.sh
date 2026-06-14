#!/bin/bash

DB_USER="freecodecamp"
DB_NAME="postgres"
PSQL="psql -U $DB_USER -d $DB_NAME -t -A -c"
RN=$(( 1 + RANDOM % 1000 ))
TIME_GUESSED=0

GET_USERNAME() {
  echo -e "Enter your username:\n"
  read -r USERNAME

  if [[ -z "$USERNAME" ]]; then
    GET_USERNAME
  else
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")

    if [[ -z "$USER_ID" ]]; then
      INSERT_USERNAME_RESULT=$($PSQL "INSERT INTO users(name, game_count, best_game_guesses) VALUES ('$USERNAME', 0, 0)")
      USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
      echo "Welcome, $USERNAME! It looks like this is your first time here."
    else
      USER_HISTORY=$($PSQL "SELECT game_count, best_game_guesses FROM users WHERE user_id = $USER_ID")
      IFS="|" read -r GAMES BEST_RECORD <<< "$USER_HISTORY"
      echo "Welcome back, $USERNAME! You have played $GAMES games, and your best game took $BEST_RECORD guesses."
    fi
  fi
}

UPDATE_STATS() {
  BEST_CURRENT=$($PSQL "SELECT best_game_guesses FROM users WHERE user_id = $USER_ID")

  if [[ -z "$BEST_CURRENT" || "$BEST_CURRENT" -eq 0 || $TIME_GUESSED -lt "$BEST_CURRENT" ]]; then
    BEST_CURRENT=$TIME_GUESSED
  fi

  UPDATE_RESULT=$($PSQL "UPDATE users SET game_count = game_count + 1, best_game_guesses = $BEST_CURRENT WHERE user_id = $USER_ID")
}

GAME() {
  local prompt="$1"

  while true; do
    echo -e "$prompt"
    read -r GUESS

    if [[ ! "$GUESS" =~ ^[0-9]+$ || $GUESS -lt 1 || $GUESS -gt 1000 ]]; then
      prompt="\nThat is not an integer, guess again:"
      continue
    fi

    TIME_GUESSED=$(( TIME_GUESSED + 1 ))

    if (( GUESS > RN )); then
      prompt="\nIt's lower than that, guess again: "
    elif (( GUESS < RN )); then
      prompt="\nIt's higher than that, guess again: "
    else
      echo -e "\nYou guessed it in $TIME_GUESSED tries. The secret number was $RN. Nice job!"
      UPDATE_STATS
      break
    fi
  done
}

GET_USERNAME
GAME "\nGuess the secret number between 1 and 1000:"
