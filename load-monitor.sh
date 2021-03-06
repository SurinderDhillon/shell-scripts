#!/bin/bash

# Get the server ID set from Cron
SERVER_ID=${1}

# Get Total Memory stats (MB)
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
echo "Free Memory: $MEM_FREE"
echo "Used Memory: $MEM_USED"
echo "CPU Load: $CPU_LOAD"
echo "DB Lag: $DB_LAG"
