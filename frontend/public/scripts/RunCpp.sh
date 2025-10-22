#!/bin/bash
# Compile and Run C++ Program

echo "Enter the name of the C++ file (without .cpp extension):"
read cpp_file

# Compile the C++ file
g++ $cpp_file.cpp -o $cpp_file

# Run the compiled program
./$cpp_file
