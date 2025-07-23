#!/bin/bash
# Author: Juan Romón Peña
# Description: This script is an utility to compile a single C file from the M2OS project
# Use:
#   Called from tasks.json
#   $ compile-c-file.sh file_name

file=$1 #file to compile
echo "==== Compiling " $file "===="
selected_arch="stm32f4" #selected architecture change if needed
m2os_dir="<M2OS_DIR>" #M2OS directory change if needed

cd $m2os_dir

file_dir=$(dirname $file)
#echo $file_dir

#get the gpr file

gpr_file=$(find $file_dir -type f -wholename "*_$selected_arch.gpr")

if [ -z "$gpr_file" ]; then
    echo -e "\e[31mThe gpr file for the architecture $selected_arch does not exist in the project\e[0m"
    exit 1
fi

echo $gpr_file

#compile the file or all the files in the dir with the gpr file
if [ "$2" == "all" ]; then
  gprbuild --target=arm-eabi -d -P$gpr_file -Xuse_tool=No_Use_Tool 
  exit 0
fi
gprbuild --target=arm-eabi -d -P$gpr_file -Xuse_tool=No_Use_Tool $file  


