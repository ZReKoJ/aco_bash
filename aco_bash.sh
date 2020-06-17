#! /bin/bash

rm -rf process

[ ! -d "process" ] && mkdir process

# Variables

ALPHA=0.5
BETA=0.6
EVAPORATION=0.8
ANTS=5
CITIES=5
ITERATION=1

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
echo "sequence 1" >> $INFO_FILE 

echo "============================================================"
echo "`date +'%Y/%d/%m %H:%M:%S'` Starting script ..."

if [ -f "cities.sh" ];
then
	echo "============================================================"
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
        
	for i in `seq 1 $ITERATION`
	do
		./colony.sh
	done
	
	cd ..
else
        echo "`date +'%Y/%d/%m %H:%M:%S'` Error: File colony.sh not found"
        exit 1
fi

cd process/cities

best=`sort -k2 -n .ant | head -n 1`

cd ..

echo "" >> .result
echo $best >> .result

echo "============================================================"
result=`grep ant .result`
echo "`date +'%Y/%d/%m %H:%M:%S'` Result $result"
echo "============================================================"

cd ..

echo "`date +'%Y/%d/%m %H:%M:%S'` Finish"
echo "============================================================"

exit 0
