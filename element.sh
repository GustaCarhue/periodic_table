#!/bin/bash

# Verificar si no se ha proporcionado ningún argumento
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Variable para ejecutar consultas en la base de datos
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Verificar si el argumento es un número (atomic_number)
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
else
  ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
fi

# Si no se encuentra el elemento
if [[ -z $ELEMENT ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# Dividir los resultados en variables individuales
IFS="|" read -r ATOMIC_NUMBER NAME SYMBOL MASS MELTING BOILING TYPE <<< "$ELEMENT"

# Formatear la salida exactamente como se requiere
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
