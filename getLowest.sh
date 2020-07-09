#!/bin/sh
cage=$1
cat $cage/data/enList | sort -k 13n | awk 'BEGIN{FS="-"}NR==1{print $1}' | tr ' ' '_'
