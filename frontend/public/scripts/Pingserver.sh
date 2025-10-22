#!/bin/bash
# Ping a remote server

echo "Enter the IP address or hostname of the remote server:"
read remote_server

ping -c 4 $remote_server
