#!/bin/bash
# Author: Juan Romón Peña
# Description: This script is an utility to clean files generated at compile time
# Use:
#   Called from tasks.json
#   $ compile-c-file.sh file_name

dir=$1 #file to compile
echo "Target dir to clean ... $dir"
selected_arch="stm32f4" #selected architecture change if needed
m2os_dir="<M2OS_DIR>" #M2OS directory change if needed

cd $m2os_dir

#file_dir=$(dirname $file)
#echo $file_dir

#get the gpr file

gpr_file=$(find $dir -type f -wholename "*_$selected_arch.gpr")
echo "Cleaning $dir with $gpr_file"

if [ -z "$gpr_file" ]; then
    echo -e "\e[31mThe gpr file for the architecture $selected_arch does not exist in the project\e[0m"
    exit 1
fi

#clean the files
gprclean --target=arm-eabi -r -P$gpr_file