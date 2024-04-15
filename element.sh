#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"
NUMBER='^[0-9]+$'
if [[ -z $1 ]] 
then
echo "Please provide an element as an argument."
else
GET_ELEMENT
fi

GET_ELEMENT () {
  if [[ $1 =~ $NUMBER ]]
  then
  ATOMIC_NUMBER=$($PSQL "select atomic number from elements where atomic_number = $NUMBER")
  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo "I could not find that element in the database."
  else
  #get element using actual atomic nuber
  WHOLE_ELEMENT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where atomic_number = $ATOMIC_NUMBER") 
  echo $WHOLE_ELEMENT | while read TYPEID BAR ATOMICN BAR SYMBOL BAR NAME BAR ATOMICM BAR MELT BAR BOIL BAR TYPE
  do
  echo "The element with atomic number $ATOMICN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMICM amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius.

  
  fi
}
