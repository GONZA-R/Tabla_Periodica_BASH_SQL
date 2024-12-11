#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#DROP_COLUMN=$($PSQL "alter table properties drop column type")

if [[ -z "$1" ]]
then
  echo "Please provide an element as an argument."
else
  #./element.sh 1, ./element.sh H, or ./element.sh Hydrogen
  
  if [[ "$1" =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where atomic_number=$1")
  else
    ELEMENT=$($PSQL "select atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius from elements inner join properties using(atomic_number) inner join types using(type_id) where name='$1' or symbol='$1'")
  fi 

  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ELEMENT" | while IFS="|" read ATOMIC  NAME SYMBOL TYPE ATOMIC_MASSA MELTING BOILING
    do
    echo "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASSA amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
  
fi

# Eliminar el elemento con atomic_number 1000 de ambas tablas
DELETE_RESULT=$($PSQL "DELETE FROM properties WHERE atomic_number = 1000")
DELETE_RESULT=$($PSQL "DELETE FROM elements WHERE atomic_number = 1000")



