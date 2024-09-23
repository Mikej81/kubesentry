#!/bin/sh

while true; do
    # Collect CPU usage from /proc/stat
    CPU_USAGE=$(awk -v FS=" " '{sum=$2+$3+$4+$5+$6+$7+$8+$9} END {print sum}' /host/proc/stat)
    
    # Get memory usage
    MEM_TOTAL=$(grep MemTotal /host/proc/meminfo | awk '{print $2}')
    MEM_FREE=$(grep MemFree /host/proc/meminfo | awk '{print $2}')
    MEM_USED=$((MEM_TOTAL - MEM_FREE))
    #MEM_UTIL=$(awk "BEGIN {printf \"%.2f\", $MEM_USED/$MEM_TOTAL*100}")
    MEM_UTIL=$(awk -v used="$MEM_USED" -v total="$MEM_TOTAL" 'BEGIN {printf "%.2f", used/total*100}')


    # Send SNMP trap

    #snmptrap -v 2c -c $COMMUNITY_STRING $TRAP_RECEIVER "" .1.3.6.1.4.1.2021.11.10 "" 6 1 "" .1.3.6.1.4.1.2021.11.10 s "CPU Usage: $CPU_USAGE%" .1.3.6.1.4.1.2021.11.50 s "Memory Usage: $MEM_USAGE%"

    snmptrap -v 2c -c $COMMUNITY_STRING $TRAP_RECEIVER "" .1.3.6.1.4.1.2021.10.1.3.1 .1.3.6.1.4.1.2021.10.1.3.1 s $CPU_USAGE 
    snmptrap -v 2c -c $COMMUNITY_STRING $TRAP_RECEIVER "" .1.3.6.1.4.1.2021.4.6.0 .1.3.6.1.4.1.2021.4.6.0 i $MEM_FREE

    # worked snmptrap -v 2c -c public 192.168.2.25 "" .1.3.6.1.4.1.2021.10.1.3.1 .1.3.6.1.4.1.2021.10.1.3.1 s 90

    # Sleep for a while before the next check
    sleep 60
done
