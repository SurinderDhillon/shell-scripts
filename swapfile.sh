#!/bin/bash

##  Check existing Swapfile
Swap=$(free -m | grep Swap | awk '{print $2}')

if [ "$Swap" -ge 1 ]; then
	exit 1
fi

##  Check Disk Space
Disk=$(df -h | grep -E 'vda|sda' | awk '{print $2}' | sed 's/G//')

echo "Disk Size is $Disk"

##  Creating swap
echo "Give the size for swap: "
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
  * ) echo "invalid";;
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
