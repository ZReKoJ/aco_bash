#! /bin/bash

CITIES=`grep cities .information | awk '{print $2}'`
ROOT_PWD=`grep root .information | awk '{print $2}'`

[ ! -d "cities" ] && mkdir cities

cd cities

for i in `seq 1 $CITIES`;
do
	echo "Creating city $i ..."
	
	mkdir city_$i
	cd city_$i

	echo "   Initialize pheromone with 1"
        echo 1 > .pheromone

	for j in `seq 1 $CITIES`;
	do
		if [ $i -ne $j ];
		then
			ln -s $ROOT_PWD/process/cities/city_$j city_$j
			if [ $i -gt $j ];
			then
				rand=`grep "distance_$i " city_$j/.distance | awk '{print $2}'`
				echo "distance_$j 1" >> .distance
				echo "   Distance to city $j is $rand"
			else
				rand=$((1 + RANDOM % 10))
				echo "distance_$j $rand" >> .distance
				echo "   Distance to city $j is $rand"
			fi
		fi
	done	

	cd ..
done

cd ..

exit 0