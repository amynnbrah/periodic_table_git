#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
NUMBER='^[0-9]+$'


GET_ELEMENT_BY_SYMBOL_ORNAME () {
    ATOM_SYMBOL=$($PSQL "select symbol from elements where symbol ilike '$QUERY'")
    if [[ -z $ATOM_SYMBOL ]]
    then
    ATOM_NAME=$($PSQL "select name from elements where name ilike '$QUERY'")
    if [[ -z $ATOM_NAME ]]
    then
    echo "I could not find that element in the database."
    else
  WHOLE_ELEMENT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where name ilike '$QUERY'") 
  echo "$WHOLE_ELEMENT" | while IFS="|" read TYPEID ATOMICN SYMBOL NAME ATOMICM MELT BOIL TYPE
  do
  echo "The element with atomic number $ATOMICN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMICM amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
  fi
fi
if [[ -n $ATOM_SYMBOL ]]
then
 WHOLE_ELEMENT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where symbol ilike '$QUERY'") 
  echo "$WHOLE_ELEMENT" | while IFS="|" read TYPEID ATOMICN SYMBOL NAME ATOMICM MELT BOIL TYPE
  do
  echo "The element with atomic number $ATOMICN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMICM amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
fi

}



GET_ELEMENT_BY_NUMBER () {
 if [[ $QUERY =~ $NUMBER ]]
  then
  ATOMIC_NUMBER=$($PSQL "select atomic_number from elements where atomic_number = $QUERY")
  if [[ -z $ATOMIC_NUMBER ]]
  then
  echo "I could not find that element in the database."
  else
  #get element using actual atomic nuber
  WHOLE_ELEMENT=$($PSQL "select * from elements full join properties using(atomic_number) full join types using(type_id) where atomic_number = $QUERY") 
  echo "$WHOLE_ELEMENT" | while IFS="|" read TYPEID ATOMICN SYMBOL NAME ATOMICM MELT BOIL TYPE
  do
  echo "The element with atomic number $QUERY is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMICM amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  done
  fi
  else
  GET_ELEMENT_BY_SYMBOL_ORNAME
  fi
}


if [[ -z $1 ]] 
then
echo "Please provide an element as an argument."
else
QUERY=$1
GET_ELEMENT_BY_NUMBER
fi




