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

echo "`date +'%Y/%d/%m %H:%M:%S'` Starting script ..."

if [ -f "cities.sh" ];
then
	echo "`date +'%Y/%d/%m %H:%M:%S'` Creating cities ..."
	cp cities.sh process/
	cd process
	chmod +x cities.sh
	./cities.sh
	cd ..
else
	echo "`date +'%Y/%d/%m %H:%M:%S'` Error: File cities.sh not found"
	exit 1
fi

if [ -f "ant.sh" ];
then
        cp ant.sh process/
        cd process
        chmod +x ant.sh
        cd ..
else
        echo "`date +'%Y/%d/%m %H:%M:%S'` Error: File ant.sh not found"
        exit 1
fi

if [ -f "colony.sh" ];
then
        cp colony.sh process/
        cd process
        chmod +x colony.sh
        ./colony.sh
        cd ..
else
        echo "`date +'%Y/%d/%m %H:%M:%S'` Error: File colony.sh not found"
        exit 1
fi

echo "`date +'%Y/%d/%m %H:%M:%S'` Finish"

exit 0
