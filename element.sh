#!/bin/bash
#first commit
#second commit
#third commit
#fourth commit


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [ -z "$1" ]; then
    echo "Please provide an element as an argument."
    exit 0
fi

ELEMENT=$1

if [[ $ELEMENT =~ ^[0-9]+$ ]]; then
    QUERY="SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.atomic_number = $ELEMENT"
elif [[ $ELEMENT =~ ^[A-Z][a-z]?$ ]]; then
    QUERY="SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.symbol = '$ELEMENT'"
else
    QUERY="SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e JOIN properties p ON e.atomic_number = p.atomic_number JOIN types t ON p.type_id = t.type_id WHERE e.name = '$ELEMENT'"
fi

RESULT=$($PSQL "$QUERY")

if [ -z "$RESULT" ]; then
    #echo "Element not found."
    echo "I could not find that element in the database."
    exit 0
fi

IFS='|' read -ra INFO <<< "$RESULT"

echo "The element with atomic number ${INFO[0]} is ${INFO[2]} (${INFO[1]}). It's a ${INFO[3]}, with a mass of ${INFO[4]} amu. ${INFO[2]} has a melting point of ${INFO[5]} celsius and a boiling point of ${INFO[6]} celsius."
