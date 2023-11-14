#!/bin/bash

#SBATCH -J fte_0U
#SBATCH -p short
#SBATCH -n 1   
#SBATCH --ntasks-per-node=20
#SBATCH -t 0-00:10
#SBATCH --mem=5M
#SBATCH --requeue

# Check that all input arguments are present
if [ "$#" -ne 3 ]; then
	echo "Error: incorrect number of input arguments"
	echo "Usage: sbatch run_ft_extract.sh [BAM file] [min_ml_score start] [min_ml_score end]"
	echo "Example: sbatch run_ft_extract.sh example.bam 244 255"
	exit 1
fi

# Define variables

bam_file="$1"
min_ml_score_start="$2"
min_ml_score_end="$3"
bed_prefix="${bam_file%.*}_ft_"
bed_suffix=".bed"

# Loop through the range of min_ml_score values

for ((min_ml_score=$min_ml_score_start; min_ml_score<=$min_ml_score_end; min_ml_score++ )); do
	bed_file=$bed_prefix$min_ml_score$bed_suffix
	sbatch ft_extract.sh $min_ml_score $bed_file "$bam_file"
done
