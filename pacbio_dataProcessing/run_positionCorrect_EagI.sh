#!/bin/bash

#SBATCH -J posCorrect
#SBATCH -p short
#SBATCH -n 1   
#SBATCH -t 0-00:30
#SBATCH --mem=1G
#SBATCH --mail-type=fail
#SBATCH --mail-user=richard_isaac@hms.harvard.edu
#SBATCH --export=all
#SBATCH --requeue

# Get the input file name from the command line argument
if [ $# -eq 0 ]; then
	echo "Please provide the input file name"
	exit 1
fi
INPUT_FILE=$1

# Run the R script
Rscript /n/groups/churchman/rsi4/mtfiberseq/fibertools/scripts/positionCorrect_EagI.R $INPUT_FILE
