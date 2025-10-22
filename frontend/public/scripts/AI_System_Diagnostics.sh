#!/bin/bash
# filepath: /home/yash/UniFix/frontend/public/scripts/AI_System_Diagnostics.sh

echo "========== AI-Powered System Diagnostics =========="

# 1. Basic system health checks
echo "Checking CPU load..."
uptime

echo "Checking memory usage..."
free -h

echo "Checking disk usage..."
df -h

echo "Checking running processes..."
ps aux --sort=-%mem | head -n 10

# 2. Check for system errors in logs
echo "Scanning system logs for errors..."
grep -i "error" /var/log/syslog | tail -n 20

# 3. AI/ML-based anomaly detection (if Python & scikit-learn are available)
if command -v python3 &>/dev/null && python3 -c "import sklearn" &>/dev/null; then
  echo "Running AI-based anomaly detection on system logs..."

  python3 - <<'EOF'
import os
from sklearn.ensemble import IsolationForest

logfile = "/var/log/syslog"
if not os.path.exists(logfile):
    print("Syslog not found, skipping AI diagnostics.")
    exit(0)

# Read last 1000 lines of syslog
with open(logfile, "r", encoding="utf-8", errors="ignore") as f:
    lines = f.readlines()[-1000:]

# Simple feature: line length (for demo purposes)
X = [[len(line)] for line in lines]

# Fit Isolation Forest
model = IsolationForest(contamination=0.05, random_state=42)
y_pred = model.fit_predict(X)

print("Potential anomalies in system logs:")
for i, pred in enumerate(y_pred):
    if pred == -1:
        print(lines[i].strip())
EOF

else
  echo "Python3 with scikit-learn not found. Skipping AI diagnostics."
fi

echo "Diagnostics complete."