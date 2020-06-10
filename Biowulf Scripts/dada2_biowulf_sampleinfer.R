# dada2 biowulf script for sample inference
# copied from: https://benjjneb.github.io/dada2/bigdata.html


library(dada2); packageVersion("dada2")
# File parsing
filtpathF <- "/data/iskoec/V13_16S_data/R1/filtered" # CHANGE ME to the directory containing your filtered forward fastqs
filtpathR <- "/data/iskoec/V13_16S_data/R2/filtered" # CHANGE ME ...
filtFs <- list.files(filtpathF, pattern="fastq.gz", full.names = TRUE)
filtRs <- list.files(filtpathR, pattern="fastq.gz", full.names = TRUE)
sample.names <- sapply(strsplit(basename(filtFs), "[.]"), `[`, 1) # Assumes filename = samplename.XXX.fastq.gz
sample.namesR <- sapply(strsplit(basename(filtRs), "[.]"), `[`, 1) # Assumes filename = samplename.XXX.fastq.gz
if(!identical(sample.names, sample.namesR)) stop("Forward and reverse files do not match.")
names(filtFs) <- sample.names
names(filtRs) <- sample.names
set.seed(100)
# Learn forward error rates
errF <- learnErrors(filtFs, nbases=1e8, multithread=TRUE)
# Learn reverse error rates
errR <- learnErrors(filtRs, nbases=1e8, multithread=TRUE)

# Sample inference and merger of paired-end reads
mergers <- vector("list", length(sample.names))
names(mergers) <- sample.names

# set up tracked reads for output
tracker <- matrix(nrow = length(sample.names), ncol = 7)
i <- 1
getN <- function(x) sum(getUniques(x))


for(sam in sample.names) {
  cat("Processing:", sam, "\n")
    derepF <- derepFastq(filtFs[[sam]])
    ddF <- dada(derepF, err=errF, multithread=TRUE)
    derepR <- derepFastq(filtRs[[sam]])
    ddR <- dada(derepR, err=errR, multithread=TRUE)
    merger <- mergePairs(ddF, derepF, ddR, derepR, minOverlap=10, maxMismatch = 1)
    mergers[[sam]] <- merger

    # update tracker
    tracker[i,] <- c(sam, NA, NA,
                   getN(ddF), getN(ddR), NA, NA)
  i <- i +1

}
rm(derepF); rm(derepR)
# Construct sequence table and remove chimeras
seqtab <- makeSequenceTable(mergers)

# save files
saveRDS(mergers, file="/data/iskoec/dada2_R/V13_Dada2/V2/mergers.rds") # CHANGE ME
saveRDS(tracker, file="/data/iskoec/dada2_R/V13_Dada2/V2/tracker.rds") # CHANGE ME
saveRDS(seqtab, file="/data/iskoec/dada2_R/V13_Dada2/V2/seqtab.rds") # CHANGE ME to where you want sequence table saved


