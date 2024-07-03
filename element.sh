#!/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

SHOW_ATOM_DESC(){

      echo "$1" | while IFS="|" read -r TYPE_ID  ATOMIC_NUMBER  SYMBOL NAME  ATOMIC_MASS  MELTING_POINT_CELSIUS  BOILING_POINT_CELSIUS TYPE
      do
        
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."

      done



}



if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
else


  if [[ "$1" =~ ^-?[0-9]+$ ]]; then
      

      FIND_INFO_RESULT_NUMBER=$($PSQL "
        SELECT *
        FROM elements
        INNER JOIN
        properties

        USING(atomic_number)
        INNER JOIN
        types
        USING(type_id)

        WHERE atomic_number = $1
      
      ")


      # echo 
      SHOW_ATOM_DESC $FIND_INFO_RESULT_NUMBER 
  
      

  else
      

      FIND_INFO_RESULT_SYMBOL=$($PSQL "
        SELECT *
        FROM elements
        INNER JOIN
        properties

        USING(atomic_number)
        INNER JOIN
        types
        USING(type_id)

        WHERE  symbol = '$1'
      
      ")

      if [[ -z $FIND_INFO_RESULT_SYMBOL ]]

        then

      FIND_INFO_RESULT_NAME=$($PSQL "
        SELECT *
        FROM elements
        INNER JOIN
        properties

        USING(atomic_number)
        INNER JOIN
        types
        USING(type_id)

        WHERE  name = '$1'
      
      ")

        if [[ -z $FIND_INFO_RESULT_NAME ]]
          then
            echo "I could not find that element in the database." 
        else
          SHOW_ATOM_DESC $FIND_INFO_RESULT_NAME 

        fi

        
      
      else
        SHOW_ATOM_DESC $FIND_INFO_RESULT_SYMBOL 

      fi



  fi



  


fi
