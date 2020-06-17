#! /bin/bash

NUM_ANT=$(echo $0 | sed 's/[^0-9]*//g')
START_CITY=$2
PATH_INFO=../../.information
PATH_ROOT=`grep root $PATH_INFO | awk '{print $2}'` 
CITIES=`grep cities $PATH_INFO | awk '{print $2}'`
ALPHA=`grep alpha $PATH_INFO | awk '{print $2}'`
BETA=`grep beta $PATH_INFO | awk '{print $2}'`
EVAPORATION=`grep evaporation $PATH_INFO | awk '{print $2}'`
LAST_CITY=`echo "${@: -1}"`

args=("$@")

if [ $# -lt $CITIES ];
then	
	total=0
	
	for ((i = 1; i <= $CITIES; i++))
	{
		if [[ ! " ${args[@]} " =~ " ${i} " ]];
		then
			d=`grep distance_$i .distance | awk '{print $2}'`
			p=`cat city_$i/.pheromone`
			phe=`echo "(e($ALPHA * l($p))) * (e($BETA * l($d)))" | bc -l`
			total=`echo "$total + $phe" | bc -l`
		fi
	}
	
	pheromones=0
	city_chosen=-1
	distance=-1
		
	for ((i = 1; i <= $CITIES; i++))
	{
	        if [[ ! " ${args[@]} " =~ " ${i} " ]];
	        then
	                d=`grep distance_$i .distance | awk '{print $2}'`
	                p=`cat city_$i/.pheromone`
	                check=`echo "$total <= 0" | bc`
			if [ $check -eq 1 ];
			then 
				total=1
			fi
			phe=`echo "(e($ALPHA * l($p))) * (e($BETA * l($d)))" | bc -l`
			phe=`echo "$phe / $total" | bc -l`
			check=`echo "$phe > $pheromones" | bc`
	
			if [ $check -eq 1 ];
			then 
				pheromones=$phe
				city_chosen=$i
				distance=$d
			fi
	        fi
	}
	
	echo "`date +'%Y/%d/%m %H:%M:%S'` Ant $NUM_ANT goes from city $LAST_CITY to city $city_chosen"
	
	mv ant_$NUM_ANT.sh city_$city_chosen/
	cd -P city_$city_chosen
	p=`cat .pheromone`
	p=`echo "$p + (1 / $d)" | bc -l`
	echo $p > .pheromone
	
	echo "`date +'%Y/%d/%m %H:%M:%S'` Ant $NUM_ANT applies $p pheromone to the route"

	./ant_$NUM_ANT.sh $@ $city_chosen
	cd ..
else
	distance=0
        for ((i=1; i <= $#; i++))
        {
                from=$((i - 1))
                from=${args[$from]}
		to=${args[$((i % CITIES))]}
                d=`grep distance_$to $PATH_ROOT/process/cities/city_$from/.distance | awk '{print $2}'`
                distance=$((distance + d))
        }

	mv ant_$NUM_ANT.sh $PATH_ROOT/process/cities/
	cd $PATH_ROOT/process/cities
	echo "`date +'%Y/%d/%m %H:%M:%S'` Ant $NUM_ANT Cost $distance - Path [ $@ ]"
	echo "ant_$NUM_ANT $distance - $@" >> .ant

fi


exit 0 
