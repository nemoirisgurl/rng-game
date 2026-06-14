#!/bin/bash

RN=$(( 1 + $RANDOM % 1000 ))

GET_USERNAME() {
  echo -e "Enter your username:\n"
  read USERNAME
}

GET_USERNAME