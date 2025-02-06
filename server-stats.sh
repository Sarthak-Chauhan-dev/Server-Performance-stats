#!/bin/bash

# Clear the terminal
clear
echo -e "  
"----------------------------------------------------------------------------------------------------------"
╔═╗┌─┐┬─┐┬  ┬┌─┐┬─┐  ╔═╗┌─┐┬─┐┌─┐┌─┐┬─┐┌┬┐┌─┐┌┐┌┌─┐┌─┐  ╔═╗┌┬┐┌─┐┌┬┐┌─┐
╚═╗├┤ ├┬┘└┐┌┘├┤ ├┬┘  ╠═╝├┤ ├┬┘├┤ │ │├┬┘│││├─┤││││  ├┤   ╚═╗ │ ├─┤ │ └─┐
╚═╝└─┘┴└─ └┘ └─┘┴└─  ╩  └─┘┴└─└  └─┘┴└─┴ ┴┴ ┴┘└┘└─┘└─┘  ╚═╝ ┴ ┴ ┴ ┴ └─┘
"----------------------------------------------------------------------------------------------------------"
"***************************************************************"
"Date and Time of Stats: $(date)"
"***************************************************************"
"Host Name: $(hostname)"
"***************************************************************"

[+] Author: Sarthak Chauhan
[+] Twitter: @sarthakchauhan
[+] Description: Monitors and visualizes key server metrics like CPU, memory, and disk I/O.
                 Provides realtime insights into server health and performance. 
"

#System UPTIME
timing=$(uptime)

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')

# Get memory usage
memory_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')

# Get disk usage
disk_usage=$(df -h / | awk 'NR==2{print $5}')

#TOP 5 process 
top_cpu_processes() {

    echo "Top 5 Processes by CPU Usage"

    echo "----------------------------------------------------"

    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

    echo "----------------------------------------------------"
}


# Function to display top 5 processes by Memory usage
top_memory_processes() {

    echo "Top 5 Processes by Memory Usage"

    echo "----------------------------------------------------"

    ps -eo pid,comm,%mem --sort=-%mem | head -n 6

    echo "----------------------------------------------------"

}

# Get network statistics
network_stats=$(ifconfig eth0 | grep "RX packets\|TX packets")

# Failed Login attempts
# Define log file location based on the OS type
if [ -f /var/log/auth.log ]; then
    LOGFILE="/var/log/auth.log"
elif [ -f /var/log/secure ]; then
    LOGFILE="/var/log/secure"
else
    echo "Error: Authentication log file not found."
    exit 1
fi

# Function to display failed login attempts
check_failed_logins() {
    echo "Failed Login Attempts:"
    echo "----------------------------------------------------"
    # Extract failed login attempts and count them
    grep "Failed password" $LOGFILE | awk '{print $9}' | sort | uniq -c | sort -nr
    echo "----------------------------------------------------"
}
title="Stats:"
prompt="Pick an option:"
options=("System Uptime & Avg System Load" "CPU Usage" "Memory Usage" "Disk Usage" "Network Statistics" "Top 5 Processes by CPU Usage" "Top 5 Processes by Memory Usage" "display failed login attempts")

echo -e "----------------------------------------------------------------------------------------------------------"
echo "$title"
PS3="$prompt "
select opt in "${options[@]}" "Quit"; do 
    case "$REPLY" in
    1) echo "System Uptime & Avg System Load: $timing";;
    2) echo "CPU Usage: $cpu_usage";;
    3) echo "Memory Usage: $memory_usage";;
    4) echo "Disk Usage: $disk_usage";;
    5) echo "Network Statistics: $network_stats";;
    6) top_cpu_processes;;
    7) top_memory_processes;;
    8) check_failed_logins;;
    $((${#options[@]}+1))) echo "Goodbye!"; break;;
    *) echo "Invalid option. Try another one.";continue;;
    esac
done

while opt=$(zenity --title="$title" --text="$prompt" --list \
                   --column="Options" "${options[@]}")
do
    case "$opt" in
    "${options[0]}") zenity --info --text="You picked $opt, option 1";;
    "${options[1]}") zenity --info --text="You picked $opt, option 2";;
    "${options[2]}") zenity --info --text="You picked $opt, option 3";;
    *) zenity --error --text="Invalid option. Try another one.";;
    esac
done
