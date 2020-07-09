#!/bin/sh

tasks_ok=`cat ddd | wc -w`;
tasks_all=`ls 936 | wc -w`;

if [ $tasks_ok -lt $tasks_all ]
then
  echo "Calculation in $Nnum/$iStep does not reached accuracy!"
  exit;
fi

echo "ok!"
