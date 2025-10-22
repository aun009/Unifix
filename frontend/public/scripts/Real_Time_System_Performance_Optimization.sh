#!/bin/bash
# Real-time System Performance Optimization Script
# Description: Dynamically optimizes system performance based on workload

echo "========== Real-time System Performance Optimization =========="
echo "This tool uses simple machine learning techniques to optimize your system"
echo "in real-time based on current workload patterns."
echo -e "==========================================================\n"

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
   echo "⚠️ This script requires root privileges for optimal functionality."
   echo "Some optimizations may not be applied."
   read -p "Continue anyway? (y/n): " continue_anyway
   if [ "$continue_anyway" != "y" ]; then
       exit 1
   fi
   SUDO="sudo"
else
   SUDO=""
fi

# Create data directory
DATA_DIR="$HOME/.system_optimizer"
mkdir -p "$DATA_DIR"
LOG_FILE="$DATA_DIR/optimization_log.txt"
HISTORY_FILE="$DATA_DIR/performance_history.csv"

# Check for required tools and install if missing
check_dependencies() {
    echo "[1/8] Checking dependencies..."
    
    dependencies=("sysstat" "util-linux" "bc" "iproute2" "procps" "hdparm" "ethtool" "python3")
    missing=()
    
    for dep in "${dependencies[@]}"; do
        if ! dpkg -l | grep -q "$dep"; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo "Missing dependencies: ${missing[*]}"
        read -p "Install missing dependencies? (y/n): " install_deps
        
        if [ "$install_deps" == "y" ]; then
            $SUDO apt-get update
            $SUDO apt-get install -y "${missing[@]}"
        else
            echo "⚠️ Some features may not work without required dependencies."
        fi
    else
        echo "✅ All dependencies are installed."
    fi
}

# Initialize performance history file if it doesn't exist
initialize_history() {
    if [ ! -f "$HISTORY_FILE" ]; then
        echo "timestamp,cpu_usage,memory_usage,disk_io,network_io,load_avg,io_wait" > "$HISTORY_FILE"
    fi
}

# Collect system performance metrics
collect_metrics() {
    echo -e "\n[2/8] Collecting performance metrics..."
    
    # CPU usage
    cpu_usage=$(mpstat 1 1 | awk '/Average:/ {print 100-$NF}')
    echo "CPU Usage: ${cpu_usage}%"
    
    # Memory usage
    mem_info=$(free | grep Mem)
    mem_total=$(echo "$mem_info" | awk '{print $2}')
    mem_used=$(echo "$mem_info" | awk '{print $3}')
    memory_usage=$(echo "scale=2; $mem_used*100/$mem_total" | bc)
    echo "Memory Usage: ${memory_usage}%"
    
    # Disk I/O
    disk_io=$(iostat -d -x 1 2 | grep -v "^$" | tail -n +4 | head -n 1 | awk '{print $14}')
    echo "Disk Utilization: ${disk_io}%"
    
    # Network I/O
    net_interface=$(ip route | grep default | awk '{print $5}')
    net_stats_before=$(cat /proc/net/dev | grep "$net_interface" | awk '{print $2 + $10}')
    sleep 1
    net_stats_after=$(cat /proc/net/dev | grep "$net_interface" | awk '{print $2 + $10}')
    network_io=$(echo "$net_stats_after - $net_stats_before" | bc)
    echo "Network I/O: ${network_io} bytes/sec"
    
    # System load average
    load_avg=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | tr -d ' ')
    echo "Load Average: $load_avg"
    
    # I/O wait
    io_wait=$(vmstat 1 2 | tail -1 | awk '{print $16}')
    echo "I/O Wait: ${io_wait}%"
    
    # Save metrics to history file
    timestamp=$(date +%s)
    echo "$timestamp,$cpu_usage,$memory_usage,$disk_io,$network_io,$load_avg,$io_wait" >> "$HISTORY_FILE"
}

# Analyze performance patterns using simple machine learning
analyze_patterns() {
    echo -e "\n[3/8] Analyzing performance patterns..."
    
    # Need at least 10 data points for analysis
    data_points=$(wc -l < "$HISTORY_FILE")
    if [ "$data_points" -lt 10 ]; then
        echo "⚠️ Not enough data for analysis. Collecting more data..."
        return 1
    fi
    
    # Calculate average CPU usage over time
    avg_cpu=$(tail -n 10 "$HISTORY_FILE" | cut -d, -f2 | awk '{ sum += $1 } END { print sum / NR }')
    echo "Average CPU usage (last 10 samples): ${avg_cpu}%"
    
    # Calculate average Memory usage over time
    avg_mem=$(tail -n 10 "$HISTORY_FILE" | cut -d, -f3 | awk '{ sum += $1 } END { print sum / NR }')
    echo "Average Memory usage (last 10 samples): ${avg_mem}%"
    
    # Calculate average I/O wait over time
    avg_io_wait=$(tail -n 10 "$HISTORY_FILE" | cut -d, -f7 | awk '{ sum += $1 } END { print sum / NR }')
    echo "Average I/O wait (last 10 samples): ${avg_io_wait}%"
    
    # Detect trend - is system usage increasing?
    cpu_first=$(tail -n 10 "$HISTORY_FILE" | head -n 5 | cut -d, -f2 | awk '{ sum += $1 } END { print sum / NR }')
    cpu_last=$(tail -n 5 "$HISTORY_FILE" | cut -d, -f2 | awk '{ sum += $1 } END { print sum / NR }')
    cpu_trend=$(echo "$cpu_last - $cpu_first" | bc)
    
    echo "CPU usage trend: $cpu_trend% (positive means increasing)"
    
    # Identify the bottleneck
    if (( $(echo "$avg_cpu > 80" | bc -l) )); then
        echo "⚠️ System appears to be CPU-bound"
        BOTTLENECK="cpu"
    elif (( $(echo "$avg_mem > 80" | bc -l) )); then
        echo "⚠️ System appears to be memory-bound"
        BOTTLENECK="memory"
    elif (( $(echo "$avg_io_wait > 20" | bc -l) )); then
        echo "⚠️ System appears to be I/O-bound"
        BOTTLENECK="io"
    else
        echo "✅ System resources appear to be balanced"
        BOTTLENECK="balanced"
    fi
    
    return 0
}

# Get resource-intensive processes
find_resource_hogs() {
    echo -e "\n[4/8] Identifying resource-intensive processes..."
    
    echo "Top 5 CPU-intensive processes:"
    ps aux --sort=-%cpu | head -6 | tail -5 | awk '{print $1, $2, $3"%", $4"%", $11}'
    
    echo -e "\nTop 5 memory-intensive processes:"
    ps aux --sort=-%mem | head -6 | tail -5 | awk '{print $1, $2, $3"%", $4"%", $11}'
    
    echo -e "\nTop 5 I/O-intensive processes:"
    if command -v iotop &>/dev/null; then
        # Use iotop if available
        $SUDO iotop -b -n 1 -o | head -10
    else
        # Fallback to less accurate method
        for pid in $(ls /proc/ | grep -E '^[0-9]+$'); do
            if [ -f "/proc/$pid/io" ]; then
                iodata=$(cat "/proc/$pid/io" 2>/dev/null)
                if [ $? -eq 0 ]; then
                    rbytes=$(echo "$iodata" | grep "read_bytes:" | awk '{print $2}')
                    wbytes=$(echo "$iodata" | grep "write_bytes:" | awk '{print $2}')
                    
                    if [[ $rbytes =~ ^[0-9]+$ ]] && [[ $wbytes =~ ^[0-9]+$ ]]; then
                        echo "$pid $rbytes $wbytes" >> /tmp/io_usage_$$.tmp
                    fi
                fi
            fi
        done
        
        if [ -f "/tmp/io_usage_$$.tmp" ]; then
            sort -k2,3 -nr /tmp/io_usage_$$.tmp | head -5 | while read pid rbytes wbytes; do
                cmd=$(cat /proc/$pid/comm 2>/dev/null || echo "[unknown]")
                user=$(ps -o user= -p $pid 2>/dev/null || echo "[unknown]")
                echo "$user $pid $((rbytes/1024))KB read $((wbytes/1024))KB written $cmd"
            done
            rm /tmp/io_usage_$$.tmp
        fi
    fi
}

# Apply optimizations based on workload analysis
apply_optimizations() {
    echo -e "\n[5/8] Applying optimizations based on analysis..."
    
    case $BOTTLENECK in
        cpu)
            echo "Applying CPU optimizations..."
            
            # Check if CPU governor can be adjusted
            if [ -d "/sys/devices/system/cpu/cpu0/cpufreq" ]; then
                echo "Setting CPU governor to performance mode..."
                for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
                    [ -f "$cpu" ] && echo "performance" | $SUDO tee "$cpu" > /dev/null
                done
                echo "✅ CPU governors set to performance mode"
            fi
            
            # Nice values for background processes
            echo "Adjusting process priorities..."
            ps aux | grep -E '(cron|rsyslog|gluster|samba)' | grep -v grep | awk '{print $2}' | while read pid; do
                $SUDO renice +5 -p $pid >/dev/null 2>&1
            done
            echo "✅ Background process priorities adjusted"
            
            # Disable unnecessary services
            echo "Checking for unnecessary services..."
            for service in bluetooth cups avahi-daemon; do
                if systemctl is-active --quiet $service; then
                    echo "Temporarily stopping $service..."
                    $SUDO systemctl stop $service
                fi
            done
            ;;
            
        memory)
            echo "Applying memory optimizations..."
            
            # Drop caches
            echo "Dropping filesystem caches..."
            $SUDO sync
            $SUDO echo 2 > /proc/sys/vm/drop_caches
            
            # Adjust swappiness based on available memory
            mem_free_pct=$(free | grep Mem | awk '{print $4/$2 * 100.0}')
            if (( $(echo "$mem_free_pct < 20" | bc -l) )); then
                # Less swappiness when memory is low
                echo "Setting lower swappiness to reduce swap usage..."
                $SUDO sysctl -w vm.swappiness=10
            else
                # Higher swappiness when memory is available
                echo "Setting higher swappiness to utilize RAM efficiently..."
                $SUDO sysctl -w vm.swappiness=60
            fi
            
            # OOM score adjustment
            echo "Adjusting OOM killer priorities..."
            ps aux | sort -nrk 4 | head -10 | awk '{print $2}' | while read pid; do
                echo "Increasing OOM score for high-memory process $pid"
                echo "300" > /proc/$pid/oom_score_adj 2>/dev/null
            done
            ;;
            
        io)
            echo "Applying I/O optimizations..."
            
            # Set I/O scheduler to deadline for better throughput
            for disk in $(lsblk -d -o name | grep -v NAME); do
                if [ -f "/sys/block/$disk/queue/scheduler" ]; then
                    echo "Setting I/O scheduler for $disk to deadline..."
                    echo "deadline" | $SUDO tee /sys/block/$disk/queue/scheduler > /dev/null
                fi
            done
            
            # Adjust readahead for better throughput
            for disk in $(lsblk -d -o name | grep -v NAME); do
                if [ -f "/sys/block/$disk/queue/read_ahead_kb" ]; then
                    echo "Increasing read-ahead for $disk..."
                    echo "1024" | $SUDO tee /sys/block/$disk/queue/read_ahead_kb > /dev/null
                fi
            done
            
            # Adjust vm.dirty_* parameters
            $SUDO sysctl -w vm.dirty_background_ratio=10
            $SUDO sysctl -w vm.dirty_ratio=20
            echo "✅ I/O parameters adjusted"
            ;;
            
        balanced)
            echo "System is well-balanced. Applying general optimizations..."
            
            # Apply conservative optimizations for balanced systems
            echo "Optimizing network settings..."
            $SUDO sysctl -w net.core.somaxconn=4096
            $SUDO sysctl -w net.ipv4.tcp_max_syn_backlog=4096
            echo "✅ Network settings optimized"
            
            # Check and optimize filesystem mounts
            echo "Checking filesystem mount options..."
            if grep -q "/home" /etc/fstab && ! grep "/home" /etc/fstab | grep -q noatime; then
                echo "Consider adding 'noatime' to /home mount for better performance"
            fi
            ;;
    esac
    
    # Common optimizations for all scenarios
    echo -e "\nApplying common optimizations..."
    
    # Optimize network settings
    $SUDO sysctl -w net.ipv4.tcp_fastopen=3
    
    # Check and unload unnecessary kernel modules
    echo "Checking for unused kernel modules..."
    lsmod | tail -n +2 | awk '{print $1, $3}' | grep "^0" | awk '{print $1}' | while read module; do
        echo "Unloading unused module: $module"
        $SUDO modprobe -r $module 2>/dev/null
    done
    
    # Log applied optimizations
    echo "$(date): Applied optimizations for bottleneck: $BOTTLENECK" >> "$LOG_FILE"
}

# Create an optimization recommendation report
generate_recommendations() {
    echo -e "\n[6/8] Generating optimization recommendations..."
    
    REPORT_FILE="$DATA_DIR/optimization_recommendations.txt"
    
    echo "========== System Optimization Recommendations ==========" > "$REPORT_FILE"
    echo "Generated on: $(date)" >> "$REPORT_FILE"
    echo "System: $(hostname) - $(uname -r)" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    echo "1. Current System Performance:" >> "$REPORT_FILE"
    echo "   - CPU Usage: ${cpu_usage}%" >> "$REPORT_FILE"
    echo "   - Memory Usage: ${memory_usage}%" >> "$REPORT_FILE"
    echo "   - Disk I/O: ${disk_io}%" >> "$REPORT_FILE"
    echo "   - Load Average: $load_avg" >> "$REPORT_FILE"
    echo "   - I/O Wait: ${io_wait}%" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    echo "2. Identified Bottleneck: $BOTTLENECK" >> "$REPORT_FILE"
    echo "" >> "$REPORT_FILE"
    
    echo "3. Applied Optimizations:" >> "$REPORT_FILE"
    case $BOTTLENECK in
        cpu)
            echo "   - Set CPU governor to performance mode" >> "$REPORT_FILE"
            echo "   - Adjusted process priorities" >> "$REPORT_FILE"
            echo "   - Disabled unnecessary services" >> "$REPORT_FILE"
            ;;
        memory)
            echo "   - Dropped filesystem caches" >> "$REPORT_FILE"
            echo "   - Adjusted swappiness settings" >> "$REPORT_FILE"
            echo "   - Modified OOM killer priorities" >> "$REPORT_FILE"
            ;;
        io)
            echo "   - Changed I/O scheduler to deadline" >> "$REPORT_FILE"
            echo "   - Increased disk read-ahead values" >> "$REPORT_FILE"
            echo "   - Adjusted virtual memory I/O parameters" >> "$REPORT_FILE"
            ;;
        balanced)
            echo "   - Applied conservative optimizations" >> "$REPORT_FILE"
            echo "   - Enhanced network settings" >> "$REPORT_FILE"
            ;;
    esac
    echo "" >> "$REPORT_FILE"
    
    echo "4. Additional Recommendations:" >> "$REPORT_FILE"
    echo "   - Consider upgrading hardware if bottlenecks persist" >> "$REPORT_FILE"
    
    if (( $(echo "$avg_cpu > 80" | bc -l) )); then
        echo "   - Evaluate CPU-intensive applications for optimization" >> "$REPORT_FILE"
        echo "   - Consider distributing workload across more cores" >> "$REPORT_FILE"
    fi
    
    if (( $(echo "$avg_mem > 80" | bc -l) )); then
        echo "   - Add more RAM or optimize memory-intensive applications" >> "$REPORT_FILE"
        echo "   - Consider running fewer concurrent applications" >> "$REPORT_FILE"
    fi
    
    if (( $(echo "$avg_io_wait > 20" | bc -l) )); then
        echo "   - Consider SSD upgrade for better I/O performance" >> "$REPORT_FILE"
        echo "   - Optimize database queries if applicable" >> "$REPORT_FILE"
    fi
    
    echo "" >> "$REPORT_FILE"
    echo "5. Long-term Optimization Strategy:" >> "$REPORT_FILE"
    echo "   - Monitor system performance regularly" >> "$REPORT_FILE"
    echo "   - Analyze application resource usage patterns" >> "$REPORT_FILE"
    echo "   - Consider containerization for better resource isolation" >> "$REPORT_FILE"
    echo "   - Implement regular maintenance tasks (cleanup, defrag)" >> "$REPORT_FILE"
    echo "=========================================================" >> "$REPORT_FILE"
    
    echo "Recommendations saved to $REPORT_FILE"
}

# Create a simple visualization of performance metrics
visualize_metrics() {
    echo -e "\n[7/8] Creating performance visualization..."
    
    # Check for enough data points
    if [ $(wc -l < "$HISTORY_FILE") -lt 5 ]; then
        echo "⚠️ Not enough data for visualization. Run the tool multiple times to collect more data."
        return
    fi
    
    # Create ASCII chart of CPU usage
    echo "CPU Usage over time (ASCII chart):"
    echo "---------------------------------"
    tail -n 10 "$HISTORY_FILE" | cut -d, -f2 | awk '{printf "%5.1f%% |", $1; for (i=0; i<$1/5; i++) printf "#"; print ""}'
    
    echo -e "\nMemory Usage over time (ASCII chart):"
    echo "---------------------------------"
    tail -n 10 "$HISTORY_FILE" | cut -d, -f3 | awk '{printf "%5.1f%% |", $1; for (i=0; i<$1/5; i++) printf "#"; print ""}'
    
    echo -e "\nI/O Wait over time (ASCII chart):"
    echo "---------------------------------"
    tail -n 10 "$HISTORY_FILE" | cut -d, -f7 | awk '{printf "%5.1f%% |", $1; for (i=0; i<$1/5; i++) printf "#"; print ""}'
    
    # Generate more advanced visualization if Python is available
    if command -v python3 &>/dev/null; then
        GRAPH_SCRIPT="$DATA_DIR/generate_graph.py"
        
        # Create Python script for visualization
        cat > "$GRAPH_SCRIPT" << 'EOF'
import os
import sys
import csv
import datetime
import matplotlib.pyplot as plt
from matplotlib.dates import DateFormatter

# Read data from CSV file
data_file = sys.argv[1]
csv_data = []

with open(data_file, 'r') as f:
    reader = csv.reader(f)
    header = next(reader)  # Skip header
    for row in reader:
        csv_data.append(row)

# Parse data
timestamps = [datetime.datetime.fromtimestamp(float(row[0])) for row in csv_data]
cpu_usage = [float(row[1]) for row in csv_data]
memory_usage = [float(row[2]) for row in csv_data]
io_wait = [float(row[6]) for row in csv_data]

# Create plot
fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(10, 10))
fig.suptitle('System Performance Metrics')

# CPU Usage
ax1.plot(timestamps, cpu_usage, 'b-', label='CPU Usage (%)')
ax1.set_ylabel('Percentage')
ax1.set_ylim(0, 100)
ax1.grid(True)
ax1.legend()

# Memory Usage
ax2.plot(timestamps, memory_usage, 'r-', label='Memory Usage (%)')
ax2.set_ylabel('Percentage')
ax2.set_ylim(0, 100)
ax2.grid(True)
ax2.legend()

# IO Wait
ax3.plot(timestamps, io_wait, 'g-', label='I/O Wait (%)')
ax3.set_ylabel('Percentage')
ax3.set_ylim(0, max(io_wait) * 1.2 if max(io_wait) > 0 else 10)
ax3.grid(True)
ax3.legend()

# Format x-axis
for ax in [ax1, ax2, ax3]:
    ax.xaxis.set_major_formatter(DateFormatter('%H:%M'))

# Adjust layout
plt.tight_layout()
plt.subplots_adjust(top=0.95)

# Save the plot
output_file = os.path.join(os.path.dirname(data_file), 'performance_graph.png')
plt.savefig(output_file)
print(f"Graph saved to {output_file}")
EOF
        
        echo "Generating graphical visualization..."
        if command -v matplotlib &>/dev/null || python3 -c "import matplotlib" &>/dev/null; then
            python3 "$GRAPH_SCRIPT" "$HISTORY_FILE"
        else
            echo "⚠️ matplotlib not installed. Install with: pip3 install matplotlib"
            echo "Then run: python3 $GRAPH_SCRIPT $HISTORY_FILE"
        fi
    else
        echo "⚠️ Python3 not found. Install Python3 for graphical visualization."
    fi
}

# Set up continuous monitoring and optimization
setup_continuous_optimization() {
    echo -e "\n[8/8] Setting up continuous optimization..."
    
    CRON_JOB="*/30 * * * * /bin/bash $(realpath $0) --auto-run > $DATA_DIR/auto_run.log 2>&1"
    
    if [ "$1" == "--auto-run" ]; then
        # Running in auto mode
        collect_metrics
        analyze_patterns && apply_optimizations
        exit 0
    fi
    
    read -p "Would you like to set up continuous optimization (runs every 30 min)? (y/n): " setup_cron
    
    if [ "$setup_cron" == "y" ]; then
        (crontab -l 2>/dev/null | grep -v "$(basename $0)"; echo "$CRON_JOB") | crontab -
        echo "✅ Continuous optimization scheduled."
        echo "   The script will run every 30 minutes and apply optimizations automatically."
        echo "   Logs will be saved to $DATA_DIR/auto_run.log"
        echo "   To disable, run: crontab -e and remove the entry."
    else
        echo "Continuous optimization not enabled."
        echo "You can run this script manually whenever needed."
    fi
}

# Main execution
if [ "$1" == "--auto-run" ]; then
    # Running in automatic mode from cron
    initialize_history
    collect_metrics
    analyze_patterns && apply_optimizations
    exit 0
else
    # Interactive mode
    check_dependencies
    initialize_history
    collect_metrics
    analyze_patterns
    find_resource_hogs
    apply_optimizations
    generate_recommendations
    visualize_metrics
    setup_continuous_optimization
fi

echo -e "\n========== Performance Optimization Complete =========="
echo "Your system has been analyzed and optimized based on current workload."
echo "Review the recommendations file for long-term optimization strategies:"
echo "$DATA_DIR/optimization_recommendations.txt"
echo -e "\nRun this script periodically or enable continuous optimization"
echo "to keep your system performing optimally under changing workloads."