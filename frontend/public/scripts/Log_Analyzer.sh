#!/bin/bash
# Log Analyzer Script
# Description: Advanced system log analysis and monitoring

echo "========== Log Analyzer Tool =========="
echo "Starting log analysis..."

# Define log files to analyze
LOG_FILES=(
    "/var/log/syslog"
    "/var/log/auth.log"
    "/var/log/kern.log"
    "/var/log/apache2/error.log"
    "/var/log/nginx/error.log"
)

# Check for errors in each log file
echo -e "\n[1/5] Checking for errors in system logs..."
for log_file in "${LOG_FILES[@]}"; do
    if [ -f "$log_file" ]; then
        error_count=$(grep -i "error\|fail\|critical" "$log_file" 2>/dev/null | wc -l)
        echo "Found $error_count error-related entries in $log_file"
        if [ $error_count -gt 0 ]; then
            echo "Recent errors (last 5):"
            grep -i "error\|fail\|critical" "$log_file" 2>/dev/null | tail -n 5
            echo -e "-----\n"
        fi
    fi
done

# Check for failed login attempts
echo -e "\n[2/5] Checking for failed login attempts..."
if [ -f "/var/log/auth.log" ]; then
    failed_logins=$(grep -i "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
    echo "Found $failed_logins failed login attempts"
    if [ $failed_logins -gt 0 ]; then
        echo "Recent failed logins (last 5):"
        grep -i "Failed password" /var/log/auth.log 2>/dev/null | tail -n 5
        echo -e "-----\n"
    fi
fi

# Check for system boot times
echo -e "\n[3/5] Checking system boot logs..."
if command -v journalctl &> /dev/null; then
    echo "System boot history (last 5 boots):"
    journalctl --list-boots | tail -n 5
    echo -e "-----\n"
fi

# Check for disk space warnings
echo -e "\n[4/5] Checking for disk space warnings..."
journalctl -p err..emerg --since "24 hours ago" | grep -i "space\|disk\|storage" | tail -n 5
echo -e "-----\n"

# Generate summary report
echo -e "\n[5/5] Generating log summary..."
echo "Top 10 processes logging the most messages (last 24h):"
if command -v journalctl &> /dev/null; then
    journalctl --since "24 hours ago" | awk '{print $5}' | sort | uniq -c | sort -nr | head -n 10
fi

echo -e "\n========== Log Analysis Complete =========="
echo -e "\nRecommendations:"
echo "1. Investigate any critical errors found in the logs."
echo "2. If you see repeated failed login attempts, consider implementing fail2ban."
echo "3. For persistent disk space warnings, clean up unused files or consider adding storage."
echo "4. For more detailed analysis, use specialized tools like logwatch or ELK stack."
echo "5. Run 'journalctl -p err..emerg' to see all errors and critical issues."