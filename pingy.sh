#!/bin/bash

# Pingy.sh created on 25th Feb 2014
# Updated on 26th Nov 2014

# Get the server ID set from Cron
SERVER_ID=${1}

# Get Total Memory stats (in MB)
T=$(grep MemT /proc/meminfo | awk '{print $2}')
MEM_TOTAL=$(( ${T} / 1024 ))

# To get the actual Free memory in the system
# We need to add the Free+Buffers+Cached memory. We get them in KB's

# Get Free Memory stats
F=$(grep MemF /proc/meminfo | awk '{print $2}')

# Get Buffer stats
B=$(grep Bu /proc/meminfo | awk '{print $2}')

# Get Cached stats
C=$(grep -w Cached /proc/meminfo | awk '{print $2}')

# Compute Actual Free memory = Buffer + Cached + Free (in MB)
MEM_FREE=$(( ( F + B + C ) / 1024 ))

# Get Used Memory stats (in MB)
MEM_USED=$(( MEM_TOTAL - MEM_FREE ))

# CPU Usage details - Get average load for 5 min
CPU_LOAD=`uptime | cut -d, -f5 | tr -d ' '`

# MySQL Slave Lag
DB_LAG=0
if [ `pgrep mysql | wc -l` -ge 1 ]; then
        DB_LAG=`mysql -e "show slave status\G;" | grep Seconds_Behind_Master | cut -d: -f2 | tr -d ' '`
fi

# POST data to URL
# Make the URL
URL="http://107.170.71.20/servers/${SERVER_ID}/status_update"

#http://scouturl.com/servers/1/status_update?ram_free=1231&ram_used=1231&load=0.123
#curl --data "param1=value1&param2=value2" http://hostname/resource
curl --data "ram_free=${MEM_FREE}&ram_used=${MEM_USED}&load=${CPU_LOAD}&db_lag=${DB_LAG}" ${URL}