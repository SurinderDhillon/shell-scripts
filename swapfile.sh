#!/bin/bash

if [ "$(whoami)" != "root" ]; then
		echo "Please run script with sudo or root user. Quitting script.."
        exit 0
else
	:
fi

##  Check existing Swapfile
Swap=$(free -m | grep Swap | awk '{print $2}')

if [ "$Swap" -ge 1 ]; then
	echo "Swapfile is already in use. Quitting script.."
	exit 1
fi

##  Check Disk Space
check=$(df -h | grep -E 'vda|sda' | wc -l)
if [ "$check" -eq '2' ]; then
    Disk=$(df -h | awk ' /'vda'|'sda'/ {print $2}' | head -1 | sed -E 's/G//') && echo "Disk Size is $Disk"
else
    Disk=$(df -h | grep -E 'vda|sda' | awk '{print $2}' | sed 's/G//') && echo "Disk Size is $Disk"
fi

##  Creating swap
echo "Specify the size for swap: "
read -r user_input

Deducted_disk=$(( Disk - user_input ))
echo ""
echo ""
echo "Total disk will be available after deduction $Deducted_disk G"
echo ""
echo ""

##  Asking to continue
read -r -p "Continue (y/n)?" choice
case "$choice" in
  y|Y ) echo "Creating swapfile";;
  n|N ) echo "quit";;
  * ) echo "Press Y|y or N|n";;
esac

fallocate -l "$user_input"\G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cp /etc/fstab /etc/fstab-"$(date '+%Y%m%d')"

##  Checking fstab file entry for swapfile
Grep_swap=$(grep -c /swapfile /etc/fstab)
if [ "$Grep_swap" == 0 ]; then
        echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab
fi

##  Asking to reboot
while true; do
        read -r -p "Reboot now? (y/n)?" choice
        case "$choice" in
                y|Y ) (reboot);;
                n|N ) echo "quit" && break ;;
                * ) echo "Please answer yes or no." && echo "" ;;
        esac
done
