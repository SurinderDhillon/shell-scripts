#!/bin/bash
# unset any variable which system may be using
unset reset os architecture kernelrelease internalip externalip nameserver loadaverage

while getopts iv name
do
        case $name in
          i)iopt=1;;
          v)vopt=1;;
          *)echo "Invalid arg";;
        esac
done

if [[ ! -z $iopt ]]
then
{
wd=$(pwd)
basename "$(test -L "$0" && readlink "$0" || echo "$0")" > /tmp/scriptname
scriptname=$(echo -e -n $wd/ && cat /tmp/scriptname)
su -c "cp $scriptname /usr/bin/monitor" root && echo "Congratulations! Script Installed, now run monitor Command" || echo "Installation failed"
}
fi

if [[ ! -z $vopt ]]
then
{
echo -e "Monitor version 0.1\nDesigned by Surinder\nReleased Under Apache 2.0 License"
}
fi

if [[ $# -eq 0 ]]
then
{


# Define Variable reset
reset=$(tput sgr0)

# Check if connected to Internet or not
ping -c 1 google.com &> /dev/null && echo -e '\E[32m'"Internet: $reset Connected" || echo -e '\E[32m'"Internet: $reset Disconnected"

echo ""

# Check OS Type
os=$(uname -o)
echo -e '\E[32m'"Operating System Type :" $reset $os
echo ""

# Check OS Release Version and Name
#cat /etc/os-release | grep 'NAME' | grep -v 'CPE_NAME' | grep -v 'PRETTY_NAME' > /tmp/osrelease
cat /etc/os-release | grep 'NAME' | grep -v 'CPE_NAME' | sed 's/PRETTY_NAME/NAME/g' | sed 's/NAME="CentOS Linux"//g' | sed '/^\s*$/d' > /tmp/osrelease
echo -n -e '\E[32m'"OS Name :" $reset  && cat /tmp/osrelease
echo ""

# Check Architecture
architecture=$(uname -m)
echo -e '\E[32m'"Architecture :" $reset $architecture
echo ""

# Check Kernel Release
kernelrelease=$(uname -r)
echo -e '\E[32m'"Kernel Release :" $reset $kernelrelease
echo ""

# Check hostname
echo -e '\E[32m'"Hostname :" $reset $HOSTNAME
echo ""

# Check Internal IP
internalip=$(hostname -I)
echo -e '\E[32m'"Internal IP :" $reset $internalip
echo ""

# Check External IP
#externalip=$(curl -s ipecho.net/plain;echo)
#echo -e '\E[32m'"External IP : $reset "$externalip

# Check DNS
nameservers=$(cat /etc/resolv.conf | sed '1 d' | awk '{print $2}')
echo -e '\E[32m'"Name Servers :" $reset $nameservers 
echo ""

# Check Logged In Users
who>/tmp/who
echo -e '\E[32m'"Logged In users :" $reset && cat /tmp/who
echo ""

# Check RAM and SWAP Usages
free -h | grep -v + > /tmp/ramcache
echo -e '\E[32m'"Ram Usages :" $reset
cat /tmp/ramcache | grep -v "Swap"
echo -e '\E[32m'"Swap Usages :" $reset
cat /tmp/ramcache | grep -v "Mem"
echo ""

# Check Disk Usages
df -h| grep 'Filesystem\|/dev/sda*' > /tmp/diskusage
df -h| grep 'Filesystem\|/dev/mapper*' > /tmp/diskuage2
echo -e '\E[32m'"Disk Usages :" $reset 
cat /tmp/diskusage
cat /tmp/diskuage2
echo ""

# Check Load Average
loadaverage=$(top -n 1 -b | grep "load average:" | awk '{print $10 $11 $12}')
echo -e '\E[32m'"Load Average :" $reset $loadaverage
echo ""

# Check System Uptime
tecuptime=$(uptime | awk '{print $3,$4}' | cut -f1 -d,)
echo -e '\E[32m'"System Uptime Days/(HH:MM) :" $reset $tecuptime
echo ""

# Unset Variables
unset reset os architecture kernelrelease internalip externalip nameserver loadaverage

# Remove Temporary Files
rm /tmp/osrelease /tmp/who /tmp/ramcache /tmp/diskusage /tmp/diskuage2
}
fi
shift $(($OPTIND -1))