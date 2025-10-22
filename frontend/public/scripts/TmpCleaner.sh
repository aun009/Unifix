#!/bin/bash
# Cleans up temporary files

echo "Cleaning up /tmp and /var/tmp..."

rm -rf /tmp/*
rm -rf /var/tmp/*

echo "Temporary files cleaned up!"
