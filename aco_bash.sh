#! /bin/bash

rm -rf process

[ ! -d "process" ] && mkdir process

# Variables

ALPHA=0.5
BETA=0.5
EVAPORATION=0.8
ANTS=10
CITIES=50

# Constants

EXECUTION_DATE=$(date +'%Y%d%m%H%M%S')
LOG_FILE="process/aco_$EXECUTION_DATE.log"
INFO_FILE="process/.information"

exec > >(tee -a $LOG_FILE) 2>&1

echo "root $PWD" > $INFO_FILE
echo "log $PWD/$LOG_FILE" >> $INFO_FILE
echo "ants $ANTS" >> $INFO_FILE
echo "cities $CITIES" >> $INFO_FILE
echo "alpha $ALPHA" >> $INFO_FILE
echo "beta $BETA" >> $INFO_FILE
echo "evaporation $EVAPORATION" >> $INFO_FILE
echo "secuence 1" >> $INFO_FILE 

echo "Starting script ..."

if [ -f "cities.sh" ];
then
	echo "Creating cities ..."
	cp cities.sh process/
	cd process
	chmod +x cities.sh
	./cities.sh
	cd ..
else
	echo "Error: File cities.sh not found"
	exit 1
fi

echo "Finish"

exit 0
