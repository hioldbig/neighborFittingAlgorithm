#!/bin/sh
  
cage=$1

basePath=`pwd`

#submit the first random 100 tasks,preparing for the Loop
tasksSubNum=`ls ${cage}/tasks | wc -l`
if [ $tasksSubNum -eq 0 ]
then
  
#Select structures for the inital calculation
cat >job.m <<EOF
    addpath('$basePath/matlab'); 
    randSelect($cage);
EOF

matlab -nojvm -nodisplay -nosplash -nodesktop < job.m >/dev/null 2>&1
wait

shell/redoName $cage

#submit the vasp calculations
shell/submit_jobs.sh ${cage} vasp super_q 10 &
wait

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

fi
