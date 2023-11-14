#!/bin/bash

#SBATCH -J merge_bam
#SBATCH -p short
#SBATCH -n 1   
#SBATCH -t 0-00:30
#SBATCH --mem 20M
#SBATCH --mail-type=fail
#SBATCH --mail-user=richard_isaac@hms.harvard.edu
#SBATCH --export=all

# check if input bam file is provided
if [ $# -lt 2 ]; then
	echo "Error: input file directory or output file names not provided"
	echo "Usage: sbatch merge_bam.sh [path to directory with ccs.bam chunks] [output bam file name]"
	exit 1
fi

# Get target bam file name from argument
input_dir="$1"
output_bam="$2"

module load gcc/6.2.0
module load samtools/1.3.1

samtools merge -c "$output_bam" "$input_dir"/*.ccs.bam
