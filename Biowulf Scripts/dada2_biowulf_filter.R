# Dada2 biowulf script
# tried running dada2_script.R on biowulf, did not work
# Rewriting following big data tutorial:
# https://benjjneb.github.io/dada2/bigdata_paired.html

# NOTE: code still used wayyyy too many threads, may want to readjust
#   - memory = 100g
#   - lscratch = 200g
#   - cpus-per-task = 70+

library(dada2); packageVersion("dada2")
# File parsing
pathF <- "/data/iskoec/V13_16S_data/R1" # CHANGE ME to the directory containing your demultiplexed forward-read fastqs
pathR <- "//data/iskoec/V13_16S_data/R2" # CHANGE ME ...
filtpathF <- file.path(pathF, "filtered") # Filtered forward files go into the pathF/filtered/ subdirectory
filtpathR <- file.path(pathR, "filtered") # ...
fastqFs <- sort(list.files(pathF, pattern="fastq.gz"))
fastqRs <- sort(list.files(pathR, pattern="fastq.gz"))

if(length(fastqFs) != length(fastqRs)) stop("Forward and reverse files do not match.")

# Filtering: THESE PARAMETERS ARENT OPTIMAL FOR ALL DATASETS
# NOTE: tutorial parameters: truncLen=c(240,200), maxEE=2, truncQ=11, maxN=0, rm.phix=TRUE
filterout <- filterAndTrim(fwd=file.path(pathF, fastqFs), filt=file.path(filtpathF, fastqFs),
              rev=file.path(pathR, fastqRs), filt.rev=file.path(filtpathR, fastqRs),
              maxEE=c(2,4), truncQ=2, maxN=0, rm.phix=TRUE,
              compress=TRUE, verbose=TRUE, multithread=TRUE)

saveRDS(filterout, file="/data/iskoec/dada2_R/V13_Dada2/V1/filterout.rds") # CHANGE ME
