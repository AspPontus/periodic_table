#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
  then
  ARGUMENT=$1
  if [[  $ARGUMENT =~ ^[0-9]+$ ]]
    then
    ELEMENT_INFO="$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements 
    INNER JOIN properties USING(atomic_number)
    INNER JOIN types USING(type_id)
    WHERE atomic_number=$ARGUMENT")"
    else
    ELEMENT_INFO="$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements 
    INNER JOIN properties USING(atomic_number)
    INNER JOIN types USING(type_id)
    WHERE name='$ARGUMENT' OR symbol='$ARGUMENT'")"
  fi

  
  if [[ -z $ELEMENT_INFO ]]
    then
    echo "I could not find that element in the database."
    else
    echo $ELEMENT_INFO | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
    do
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
  done
  fi  
  else
  echo -e "Please provide an element as an argument."
fi
