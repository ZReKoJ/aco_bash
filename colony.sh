#! /bin/bash

ANTS=`grep ants .information | awk '{print $2}'`
CITIES=`grep cities .information | awk '{print $2}'`
ROOT_PWD=`grep root .information | awk '{print $2}'`
EVAPORATION=`grep evaporation .information | awk '{print $2}'`

echo "============================================================"
echo "`date +'%Y/%d/%m %H:%M:%S'` Creating ants ..."

for i in `seq 1 $ANTS`
do
	seq=`grep sequence .information | awk '{print $2}'`
	
	rand=$((1 + RANDOM % $CITIES))
	destination=$ROOT_PWD/process/cities/city_$rand

	echo "============================================================"
	echo "`date +'%Y/%d/%m %H:%M:%S'` Ant $seq start point: city $rand"


	cp ant.sh $destination/ant_$seq.sh
	old_path=$PWD

	cd $destination
	./ant_$seq.sh $rand
	cd $old_path

	seq=$(($seq + 1))
	sed -i "s/sequence [0-9]*/sequence $seq/g" .information
done

# apply evaporation

cd cities

echo "============================================================"
echo "`date +'%Y/%d/%m %H:%M:%S'` Applying evaporation ..." 

for i in `seq 1 $CITIES`
do
	cd city_$i
	p=`cat .pheromone`
	p=`echo "$p * (1 - $EVAPORATION)" | bc -l`
	echo $p > .pheromone
	echo "`date +'%Y/%d/%m %H:%M:%S'` City $i has $p pheromones after application"
	cd ..	
done

cd ..

exit 0
