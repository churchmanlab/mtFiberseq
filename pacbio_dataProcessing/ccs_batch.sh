#!/bin/bash

#SBATCH -J ccs_batch
#SBATCH -p short
#SBATCH -n 1
#SBATCH -t 0-03:00
#SBATCH --mem 50M

# Check if the data_dir and num_of_chunks arguments are provided
if [ "$#" -ne 2 ]; then
	echo "Error: script requires both the path to data as well as the number of chunks"
	echo "Usage: sbatch ccs_batch.sh [path to data] [number of chunks]"
	exit 1
fi

# get the input arguments
data_dir="$1"
num_of_chunks="$2"

# create the data output directory
out_dir="${data_dir}/out"
mkdir ${out_dir}

# specify the path to the ccs_sub.sh script
ccs_sub_script="/n/groups/churchman/rsi4/mtfiberseq/fibertools/scripts/ccs_sub.sh"

# loop over the subdirectories and submit ccs_sub.sh for each subread bam chunk
for num in $(seq -w 00 $((${num_of_chunks}-1))) ; do
	subreads_bam="${data_dir}/${num}/${num}.subreads.bam"
	ccs_bam="${out_dir}/${num}.ccs.bam"
	sbatch ${ccs_sub_script} ${subreads_bam} ${ccs_bam}
	sleep 2m
done
