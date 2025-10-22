#!/bin/bash
# Process Manager Script
# Description: Advanced process management and monitoring

echo "========== Process Manager Tool =========="

# Function to display resource usage by top processes
show_top_processes() {
    echo -e "\n[1/5] Top 10 CPU-consuming processes:"
    ps aux --sort=-%cpu | head -11

    echo -e "\n[2/5] Top 10 memory-consuming processes:"
    ps aux --sort=-%mem | head -11
}

# Show basic system info
echo -e "\nSystem uptime and load averages:"
uptime

# Display current resource usage
show_top_processes

# Show detailed memory usage
echo -e "\n[3/5] Detailed memory usage:"
free -h

# Show detailed CPU usage
echo -e "\n[4/5] CPU usage by core:"
mpstat -P ALL 1 1

# Show disk I/O statistics
echo -e "\n[5/5] Disk I/O statistics:"
iostat -x 1 2 | grep -v "^$" | tail -n +3

echo -e "\n========== Process Management Options =========="
echo "To manage processes, you can use the following commands:"
echo "1. kill [PID]           - Terminate a process gracefully"
echo "2. kill -9 [PID]        - Force terminate a process"
echo "3. nice -n [value] [cmd] - Start a process with modified priority"
echo "4. renice [value] -p [PID] - Modify priority of running process"
echo "5. top or htop          - Interactive process viewer"
echo "6. killall [name]       - Kill all processes with the given name"
echo -e "\nFor continuous monitoring, install and use 'htop':\n    sudo apt install htop"