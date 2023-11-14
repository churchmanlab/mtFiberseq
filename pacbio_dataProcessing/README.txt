The Fibertools pipeline can begin either with a subread bam file or a CCS bam file as long as the HiFi kinetics are present. If a CCS bam file with HiFi kinetics is not present, begin with step 1. Otherwise begin at Step 4.

1. SPLIT SUBREAD BAM FILE

First, split the subread bam file into chunks. This script takes a bam file input and splits it into a designated number of chunks. Each chunk is output to a new folder numbered 00 through N chunks. 

Usage:
sbatch split_subreads.sh [bam file] [number of chunks]

Example:
sbatch split_subreads.sh example_subread.bam 60

NOTE: A corresponding .pbi index file is needed with the bam file. If this is not present, run the following:

pbindex [subread bam file]


2. GENERATE CCS

Each chunked bam file now needs to be processed with CCS to generate the CCS bam file containing the HiFi kinetics. This will run ccs_sub.sh on each chunked bam file in folders 00 through N, where N is the number of chunks from Step 1. This runs ccs with the "--hifi-kinetics" flag and outputs a ccs bam file in the naming format *.ccs.bam.

Usage:
sbatch ccs_batch.sh [number of chunks]

Example:
sbatch ccs_batch.sh 60


3. COMBINE CCS BAM FILES

The generated ccs bam files must now be merged into a single ccs bam file. The "consolidate.sh" script will create a new folder, ft_predictm6a, and move each .ccs.bam file to this folder. The "merge_bam.sh" should then be run, which uses samtools to merge all .ccs.bam files into a single .ccs.bam.


4. RUN FIBERTOOLS PREDICTM6A

Fibertools predictm6a function should then be run on the merged bam file. This runs fibertools predict-m6a function using the "-s" flag. This will output a new bam file with the ending "_m6a.bam". 

Usage:
sbatch predictm6a.sh [input bam]

Example:
sbatch predictm6a.sh example_ccs.bam


5. ALIGN WITH PBMM2

pbmm2 is used to align to a reference genome. This is run with the "--preset CCS", "--sort", "--sort-memory 1G", "--unmapped", and "--log-level INFO" flags. A reference genome (bamhi, eagi, or lrpcr) must be given. This will output a bam file with the ending _aligned.bam.

Usage:
sbatch pbmm2.sh [reference genome] [input bam]

Example:
sbatch pbmm2.sh bamhi example_ccs_m6a.bam


6. GENERATE OUTPUT BED FILE USING SCORE THRESHOLD

Fibertools extract function is used to take the aligned bam file and generate a 12 column bed file containing the location of m6A modifications. A threshold for min_ml_score must be set. This script allows a range of scores to be used, each generating a separate bed file. This will create a bed file ending in _ft_ followed by the threshold score. This script requires for input the bam file as well as the upper and lower values of min_ml_score to be used.

Usage:
sbatch run_ft_extract.sh [BAM file] [lower min_ml_score] [upper min_ml_score]

Example:
sbatch run_ft_extract.sh example_ccs_m6a_aligned.bam 244 255


7. FILTER READS FOR READS SPANNING THE FULL MITOCHONDRIAL GENOME

Bed file can be filtered for reads spanning the full length of the mitochondrial genome if desired. This can be omitted or adjusted to select for specific read lengths.

Usage:
awk ' $2==[START] ' [input bed file] | awk ' $3==[END] ' > [output bed file]

Example
awk ' $2==0 ' example.bed | awk ' $3==16565 ' > example_filtered.bed


8. ADJUST POSITIONS TO MATCH RCRS

Positions can be adjusted to rCRS coordinates depending on the restriction enzyme used. This is done with the positionCorrect_ R scripts which can be executed with the run_positionCorrect shell scripts.




