#!/bin/bash

#SBATCH -J pbmm2_0U
#SBATCH -p short
#SBATCH -n 1   
#SBATCH --ntasks-per-node=20
#SBATCH -t 0-05:00
#SBATCH --mem=15G
#SBATCH --requeue

if [ $# -ne 2 ]; then
	echo "Error: Please provide the reference genome (bamhi/eagi/lrpcr) and input bam file."
	echo "Usage: sbatch pbmm2.sh [reference genome] [input bam]"
	echo "Example: sbatch pbmm2.sh bamhi example.bam"
	exit 1
fi

module load gcc/6.2.0
module load conda2/4.2.13
source activate /home/rsi4/.conda/envs/churchman_smrtlink #Change to your conda environment

ref_genome=""
if [ "$1" == "bamhi" ]; then
  ref_genome="hg38_chrM_BamHI.fa"
elif [ "$1" == "eagi" ]; then
  ref_genome="hg38_chrM_EagI.fa"
elif [ "$1" == "lrpcr" ]; then
  ref_genome="hg38_chrM_lrpcr.fa"
else
  echo "Invalid reference genome. Please choose bamhi/eagi/lrpcr."
  exit 1
fi

input_bam="$2"
output_bam="${2%.*}_aligned.bam"

pbmm2 align --preset CCS --sort --sort-memory 1G --unmapped --log-level INFO "$ref_genome" "$input_bam" "$output_bam"
