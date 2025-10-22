#!/bin/bash
# Compile and Run MPI Program

echo "Enter the MPI C file (without .c extension):"
read mpi_file

# Compile the MPI program
mpicc $mpi_file.c -o $mpi_file

# Run the MPI program
mpirun -np 4 ./$mpi_file
