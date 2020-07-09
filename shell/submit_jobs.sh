#!/bin/bash 

subOneTask() { #提交一个新的任务

   cage=$1
   vasp=$2
   nodeList=$3
   coresNum=$4  

   caledDir=$cage/caled
   posDir=$cage/posFiles
   workDir=$cage/tasks

   posFiles=`ls $posDir -l | grep "^-" |awk '{print $NF}'`;
   workFiles=`ls $workDir -l | grep "^d" |awk '{print $NF}'`;
   posFile=`sort -m <(echo "$posFiles" | uniq) <(echo "$workFiles" | uniq) <(echo "$workFiles" | uniq) | uniq -u | sed -n "1p"`;

   if [ ! -d $workDir/${posFile} ]
   then
      
      if [ -d $caledDir/${posFile} ]
      then
         mv $caledDir/${posFile}  $workDir/
         return 0; 
      fi  
 
      mkdir $workDir/${posFile}
      if [ $? -eq 1 ]
      then
         return 0;
      fi
   else
      return 0; 
   fi
   
   cp $posDir/${posFile} $workDir/${posFile}/POSCAR
   cp $vasp/* $workDir/${posFile}/
   
   cd $workDir/${posFile}

   sed -i "s/ -J.*$/ -J job_`echo $posFile`/" job.sh
   sed -i "s/\#SBATCH -p.*$/\#SBATCH -p `echo $nodeList` -N 1 -n `echo $coresNum`/" job.sh
   sed -i "s/mpirun.*$/mpirun -n `echo $coresNum` vasp_std/" job.sh

   sbatch ./job.sh > /dev/null

   cd ../../../
}

cage=$1
vasp=$2
nodeList=$3
taskNum=$4    #max number of the jobs in the queue 

caledDir=$cage/caled
posDir=$cage/posFiles
workDir=$cage/tasks

if [ ! -d $workDir ]
then
  mkdir $workDir
fi

while [ 1 -eq 1 ]
do

 posFiles=`ls $posDir -l | grep "^-" |awk '{print $NF}'`;
 workFiles=`ls $workDir -l | grep "^d" |awk '{print $NF}'`;
 calFiles=`sort -m <(echo "$posFiles" | uniq) <( echo "$workFiles" | uniq) | uniq -d`;
   
 Num1=`echo "$posFiles"  |wc -l`      #Number of POSCAR files of the tasks to be performed.
 Num2=`echo "$calFiles" |wc -l`       #Number of tasks completed.

 if [ $Num1 -eq $Num2 ]
 then
   break;
 fi

 taskRunning=`squeue | grep 'chengyh' | grep $nodeList | wc -l`
 if [ $taskRunning -lt $taskNum ]
 then

  coresNum=`sinfo -Nel | grep $nodeList | awk 'END{print $5}'`
  subOneTask  $cage $vasp $nodeList  $coresNum
  
 fi

 sleep 30
 
done



