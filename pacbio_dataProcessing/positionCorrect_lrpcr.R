#!/n/app/R/3.5.1/bin/Rscript

# get the input file from the command-line argument
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]

bed <- read.table(input_file, header = FALSE, stringsAsFactors = FALSE)

bed = bed[which(bed$V2 == 0 & bed$V3 == 16569),]

for (i in 1:nrow(bed)) {
  blockStarts <- strsplit(bed[i, 12], ",")[[1]]
  blockSizes <- strsplit(bed[i,11], ",")[[1]]

  if (as.numeric(blockSizes[1]) == 0) {
    blockSizes[1] <- "1"
  }

  for (j in 2:(length(blockStarts) - 1)) {
    if (as.numeric(blockStarts[j]) <= 144) {
      blockStarts[j] <- as.character(as.numeric(blockStarts[j]) + 16425)
    } else {
      blockStarts[j] <- as.character(as.numeric(blockStarts[j]) - 144)
    }
  }

  bed[i, 12] <- paste(sort(as.numeric(blockStarts)), collapse = ",")
  bed[i, 11] <- paste(blockSizes, collapse = ",")
  bed[i, 10] <- length(blockStarts)
}

# generate the output file and write to a file
output_file <- gsub(".bed", "_positionCorrected.bed", input_file)
write.table(bed, output_file, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)

# Extract a subset of data (100 rows) and write to a separate file
bed_subset = bed[c(1:100),]
output_file_subset <- gsub(".bed", "_positionCorrected_subset.bed", input_file)
write.table(bed_subset, output_file_subset, sep = "\t", quote = FALSE, row.names = FALSE, col.names = FALSE)
