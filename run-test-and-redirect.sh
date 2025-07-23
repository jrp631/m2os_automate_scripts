#!/bin/bash
# Author: Juan Romón Peña
# Description: This script is an utility to compile and run a single test C file from the M2OS project
# The test is executed multiple times and the output is redirected to a file
# Use:
#   Call directly from the terminal or instead of tasks.json 
#   $ run-test-and-redirect.sh file_name

file=$1 #file to compile
echo $file
selected_arch="stm32f4" #selected architecture change if needed
m2os_dir="<M2OS_DIR>" #M2OS directory change if needed

# check if the board is connected to the host 

stm32_connected=$(lsusb | grep "STMicroelectronics ST-LINK/V2.1" | wc -l)
uart_connected=$(ls /dev/ttyUSB* | wc -l)
if [ $stm32_connected -eq  0 ]; then
    echo -e "\e[31mThe board is not connected to the host or not detected\e[0m"
    exit 1
fi
if [ $uart_connected -eq  0 ]; then
    echo -e "\e[31mThe UART is not connected to the host or not detected\e[0m"
    exit 1
fi

# TODO: refactor 

cd $m2os_dir

file_dir=$(dirname $file)
echo $file_dir

file_name=$(basename $file .c)

cd $file_dir

#generate .bin flashable file from executable
arm-eabi-objcopy -O binary $file_name $file_name.bin

echo BIN file generated: $file_name.bin

#flash the program in the board
echo -e "\e[32m====== Flasging program: $file_name on STM32 ======\e[0m"

touch $file_name.log

exec socat -u FILE:/dev/ttyUSB0,b115200 STDOUT | tee $file_name.log &

for i in {1..50}
do
    echo -e "\e[32m====== Running test $i ======\e[0m"
    eval $FLASH_COMMAND
    
    #check if the test has finished runnig
    while ! tail -n 1 $file_name.log | grep -q "Test OK"; do
      sleep 0.05
      echo -n "."
    done
done