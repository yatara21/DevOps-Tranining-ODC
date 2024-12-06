#!/bin/bash

{
tput setaf 2
echo "System Monitoring Report - $(date +"%Y-%m-%d %H:%M:%S")"
tput sgr0
echo "======================================================="

DiskUsage=$(sudo df -h)
tput setaf 2
echo "Disk Usage:"
tput sgr0
echo "======================================================="
echo "$DiskUsage"

echo "======================================================="

CpuUsage=$(sudo top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
tput setaf 2
echo "CPU Usage: $CpuUsage%"
tput sgr0
if (( $(echo "$CpuUsage > 85" | bc -l) )); then
    # Set terminal text color to red
    tput setaf 1
    echo "Warning! The CPU Usage is above 85%!"
    tput sgr0
    # Email configuration
    SUBJECT="High CPU Usage Alert!"
    TO_EMAIL="arabnada771@gmail.com"
    MESSAGE="Warning! The CPU usage on the system has exceeded 85%. Current usage is: $CpuUsage%."

    # Prepare and send the email
    {
        echo "To: $TO_EMAIL"
        echo "Subject: $SUBJECT"
        echo "Content-Type: text/plain; charset=UTF-8"
        echo ""
        echo "$MESSAGE"
    } | /usr/sbin/sendmail -t

    echo "Alert email sent to $TO_EMAIL."

    # Reset terminal text color

fi

echo "======================================================="


MemoryUsage=$(sudo free -h)
tput setaf 2
echo "Memory Usage:"
tput sgr0
echo "======================================================="
echo "$MemoryUsage"

echo "======================================================="

TopFiveMempry=$(sudo ps -Ao pid,user,comm,%mem --sort=-%mem | head -6)
tput setaf 2
echo "Top 5 Memory-Consuming Processes:"
tput sgr0
echo "======================================================="
echo "$TopFiveMempry"
} | tee "/home/vagrant/my-logs/test_$(date +"%Y%m%d_%H%M%S").log"
