#!/bin/bash

#SBATCH -J fte_0U
#SBATCH -p short
#SBATCH -n 1   
#SBATCH --ntasks-per-node=20
#SBATCH -t 0-01:00
#SBATCH --mem=2G
#SBATCH --mail-type=fail
#SBATCH --mail-user=richard_isaac@hms.harvard.edu
#SBATCH --export=all
#SBATCH --requeue

module load gcc/6.2.0
module load conda2/4.2.13
source activate /home/rsi4/.conda/envs/churchman_smrtlink

# Check if all input arguments are provided
if [ $# -ne 3 ]; then
	echo "Error: Please provide 3 input arguments: min-ml-score, output bed, input bam"
	exit 1
fi

# Assign input arguments to variables

min_ml_score=$1
bed_file=$2
bam_file=$3

# Execute ft extract with input arguments

ft extract -r --min-ml-score $min_ml_score --m6a $bed_file $bam_file
