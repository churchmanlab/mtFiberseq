#!/bin/bash

#SBATCH -J predictm6A
#SBATCH -p short
#SBATCH -n 1
#SBATCH -t 0-12:00
#SBATCH --mem 3G

if [ $# -ne 1 ]; then
	echo "Please provide bam file as an input argument."
	echo "Usage: sbatch predictm6a.sh [bam file]"
	echo "Example: sbatch predictm6a.sh example.bam"
	exit 1
fi

module load gcc/6.2.0
module load conda2/4.2.13
source activate /home/rsi4/.conda/envs/churchman_smrtlink

input_bam="$1"
output_bam="${1%.bam}_m6a.bam"

ft predict-m6a -s "$input_bam" "$output_bam"
