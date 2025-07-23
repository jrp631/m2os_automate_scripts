#!/bin/bash
# Author: Juan Romón Peña
# Description: This script is an utility to compile and flash a single C file from the M2OS project
# Use:
#   Called from tasks.json
#   $ compile-and-flash.sh file_name

file=$1 #file to compile
echo $file
selected_arch="stm32f4" #selected architecture change if needed
m2os_dir="<M2OS_DIR>" #M2OS directory change if needed

#compile file 

./.vscode/compile-c-file.sh $file
if [ $? -ne 0 ]; then
  echo "Compilation failed. Aborting."
  exit -1
fi

#flash file

./.vscode/flash-bin.sh $file