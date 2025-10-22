#!/bin/bash
# Compile and Run Java Program

echo "Enter the name of the Java file (without .java extension):"
read java_file

# Compile the Java file
javac $java_file.java

# Check if compilation was successful
if [ $? -eq 0 ]; then
    # Run the Java program
    java $java_file
else
    echo "Compilation failed. Please check your code."
fi
