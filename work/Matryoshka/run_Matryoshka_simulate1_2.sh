#!/bin/bash 

checkMakeDirectory(){
        echo -e "checking directory: $1"
        if [ ! -e "$1" ]; then
                echo -e "\tmakedir $1"
                mkdir -p "$1"
        fi
}
checkMakeDirectory DOMAINS
checkMakeDirectory DATA
BIN=40000
echo "Processing size ${BIN}"

datasets=(simulate1 simulate2)
for dataset in ${datasets[@]}; do
mkdir -p DOMAINS/${dataset}
mkdir -p DATA/${dataset}_Matryoshka

#noise index array
noiseList=(0.04 0.08 0.12 0.16 0.20) 

#start noise index loop
for noise in ${noiseList[@]}; do
python3  convert_N_N+3.py -i ../simulate_data/${dataset}/sim_ob_${noise}.chr5 -o DATA/${dataset}_Matryoshka/sim_ob_${noise}.chr5 -c chr5 -b ${BIN}
gzip DATA/${dataset}_Matryoshka/sim_ob_${noise}.chr5

/home/LiuKun/tmp/matryoshka/matryoshka-master/build/src/matryoshka -r ${BIN} -c 5 -i DATA/${dataset}_Matryoshka/sim_ob_${noise}.chr5.gz -g 0.5 -o DOMAINS/${dataset}/${dataset}.${noise}noise

done

done

