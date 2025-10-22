#!/bin/bash
# Identifies and kills memory-hogging processes

echo "Top 5 memory-consuming processes:"
ps aux --sort=-%mem | head -n 6

echo "Enter the PID of the process to kill:"
read pid
kill -9 $pid

echo "Process $pid has been killed."
