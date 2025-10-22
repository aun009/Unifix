#!/bin/bash
# Compile and Run Parallel Program with OpenMP

echo "Enter the C file (without .c extension):"
read c_file

# Compile with OpenMP
gcc -fopenmp $c_file.c -o $c_file

# Run the compiled program
./$c_file
