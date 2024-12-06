#!/bin/bash

# Constants
LOG_DIR="/home/vagrant/my-logs"
CPU_THRESHOLD=85
TO_EMAIL="your-email-example@gmail.com"

# Ensure the log directory exists
if [ ! -d "$LOG_DIR" ]; then
    mkdir -p "$LOG_DIR"
fi

# Functions for colored output
print_green() {
    tput setaf 2
    echo "$1"
    tput sgr0
}

print_red() {
    tput setaf 1
    echo "$1"
    tput sgr0
}

# Log file setup
LOG_FILE="$LOG_DIR/system_report_$(date +"%Y%m%d_%H%M%S").log"

{
    # Header
    print_green "System Monitoring Report - $(date +"%Y-%m-%d %H:%M:%S")"
    echo "======================================================="

    # Disk Usage
    disk_usage=$(df -h)
    print_green "Disk Usage:"
    echo "======================================================="
    echo "$disk_usage"
    echo "======================================================="

    # CPU Usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    print_green "CPU Usage: $cpu_usage%"
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        print_red "Warning! CPU usage is above $CPU_THRESHOLD%!"
        
        # Send alert email
        subject="High CPU Usage Alert!"
        message="Warning! The CPU usage on $(hostname) has exceeded $CPU_THRESHOLD%. Current usage is: $cpu_usage%."

        echo -e "To: $TO_EMAIL\nSubject: $subject\n\n$message" | sendmail -t
        echo "Alert email sent to $TO_EMAIL."
    fi
    echo "======================================================="

    # Memory Usage
    memory_usage=$(free -h)
    print_green "Memory Usage:"
    echo "======================================================="
    echo "$memory_usage"
    echo "======================================================="

    # Top 5 Memory-Consuming Processes
    top_memory_processes=$(ps -Ao pid,user,comm,%mem --sort=-%mem | head -6)
    print_green "Top 5 Memory-Consuming Processes:"
    echo "======================================================="
    echo "$top_memory_processes"
    echo "======================================================="

} | tee "$LOG_FILE"
#enhanced version of the script from GPT
