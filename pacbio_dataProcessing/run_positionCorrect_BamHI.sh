#!/bin/bash

#SBATCH -J posCorrect
#SBATCH -p short
#SBATCH -n 1   
#SBATCH -t 0-00:30
#SBATCH --mem=1G
#SBATCH --requeue

# Get the input file name from the command line argument
if [ $# -eq 0 ]; then
	echo "Please provide the input file name"
	exit 1
fi
INPUT_FILE=$1

# Run the R script
Rscript positionCorrect_BamHI.R $INPUT_FILE
