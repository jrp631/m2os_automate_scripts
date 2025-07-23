#!/bin/bash
# Author: Juan Romón Peña
# Description: This script is an utility to compile a file from the M2OS project
# Use:
#   Called from tasks.json
#   flash-bin.sh file_name


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

file=$1 #file to compile
echo $file
selected_arch="stm32f4" #selected architecture change if needed
m2os_dir="<M2OS_DIR>" #M2OS directory change if needed

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

openocd -f board/stm32f4discovery.cfg -c "program $file_name.bin verify reset exit 0x08000000" 2> openocd_status.log

notify-send -t 2000 -u normal  "Ⓜ️2️⃣  $file_name flashed on STM32 💻"