#!/n/app/R/3.5.1/bin/Rscript
# This script changes the numbering for the read from the aligned genome back to rCRS chrM coordinates.
# This script assumes the bed file was from reads aligned to "hg38_chrM_BamHI.fa"

# Get command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Check that there is at least one input argument
if (length(args) < 1) {
  stop("Please provide the input file name")
}

# Set the input file name to the first argument
input_file <- args[1]

# Read in input BED file
bed <- read.table(input_file, header = FALSE, stringsAsFactors = FALSE)

# Filter BED file for full length reads
bed = bed[which(bed$V2 == 0 & bed$V3 == 16565),]

# Rename first column
bed$V1 = "chrM"

# Modify BED file number back to rCRS coordinates
for (i in 1:nrow(bed)) {
  blockStarts <- strsplit(bed[i, 12], ",")[[1]]
  blockSizes <- strsplit(bed[i, 11], ",")[[1]]
  
  if (as.numeric(blockSizes[1]) == 0) {
    blockSizes[1] <- "1"
  }
  
  for (j in 2:(length(blockStarts) - 1)) {
    if (as.numeric(blockStarts[j]) <= 13999) {
      blockStarts[j] <- as.character(as.numeric(blockStarts[j]) + 2570)
    } else {
      blockStarts[j] <- as.character(as.numeric(blockStarts[j]) - 13999)
    }
  }
  
  blockStarts <- blockStarts[as.numeric(blockStarts) <= 16564]
  blockSizes <- blockSizes[1:length(blockStarts)]
  
  bed[i, 12] <- paste(sort(as.numeric(blockStarts)), collapse = ",")
  bed[i, 11] <- paste(blockSizes, collapse = ",")
  bed[i, 10] <- length(blockStarts)
}

# Set the output file name
output_file <- sub(".bed", "_positionCorrected.bed", input_file)

# Write the corrected BED file to a new output
write.table(bed, output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Extract a subset of data (100 rows) and write to a separate file
bed_subset = bed[c(1:100),]
output_file_subset <- gsub(".bed", "_positionCorrected_subset.bed", input_file)
write.table(bed_subset, output_file_subset, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Debugging statements
cat("Input file:", input_file, "\n")
cat("Output file:", output_file, "\n")
