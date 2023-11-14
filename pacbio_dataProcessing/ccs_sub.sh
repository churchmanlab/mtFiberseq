#!/bin/bash

# load required modules
module load gcc/6.2.0
module load conda2/4.2.13
source activate /home/rsi4/.conda/envs/churchman_smrtlink #Change this to your conda environment

# check if input arguments are provided
if [ "$#" -ne 2 ]; then
	echo "Error: script requires two arguments."
	exit 1
fi

# get input arguments
subreads_bam="$1"
ccs_bam="$2"

# extract file name from input subreads bam
file=$(basename "$subreads_bam")

# print input subreads bam and output ccs bam
echo "Input subreads bam: $subreads_bam"
echo "Output ccs bam: $ccs_bam"

# run ccs command with input subreads bam and output ccs bam
ccs --hifi-kinetics -j 20 "$subreads_bam" "$ccs_bam"
