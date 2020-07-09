#!/bin/sh
  
cage=$1
initLoop=$2
loopTimes=$3

caledDir=$cage/caled
basePath=`pwd`

#Loop section

for((i=$initLoop;i<=$loopTimes;i++))
do

#Get calculated results
cd ${cage}/tasks;

for fs in `reached`
do
  e0list $fs
done > ../data/enList

cd ../../

sed -i 's/_/ /g' ${cage}/data/enList

#Do fitting
cat >job.m <<EOF
   addpath('$basePath/matlab'); 
   fitting($cage,$i);
   top100($cage,$i);
EOF

matlab -nojvm -nodisplay -nosplash -nodesktop < job.m >/dev/null 2>&1
wait

done
  
