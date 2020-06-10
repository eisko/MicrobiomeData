# processing for Forward (R1) reads only
# run after filtering reads

library(dada2)

# File parsing
filtpath <- "/data/iskoec/V13_16S_data/R1/filtered" # CHANGE ME to the directory containing your filtered fastq files
filtFs <- list.files(filtpath, pattern="fastq.gz", full.names=TRUE) # CHANGE if different file extensions
sample.names <- sapply(strsplit(basename(filtFs), "[.]"), `[`, 1) # Assumes filename = samplename.XXX.fastq.gz
names(filtFs) <- sample.names
print("filtFs:")
print(filtFs)

# Learn error rates
set.seed(100)
err <- learnErrors(filtFs, nbases = 1e8, multithread=TRUE, randomize=TRUE)
# Infer sequence variants
dds <- vector("list", length(sample.names))
names(dds) <- sample.names
for(sam in sample.names) {
  cat("Processing:", sam, "\n")
  derep <- derepFastq(filtFs[[sam]])
  dds[[sam]] <- dada(derep, err=err, multithread=TRUE)
}
# Construct sequence table and write to disk
seqtab <- makeSequenceTable(dds)
saveRDS(seqtab, "/data/iskoec/dada2_R/V13_Dada2/V2/seqtab_Fs.rds") # CHANGE ME to where you want sequence table saved
saveRDS(dds, "/data/iskoec/dada2_R/V13_Dada2/V2/dadas_Fs.rds")



# Remove chimeras
seqtab <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE)
# Assign taxonomy
tax <- assignTaxonomy(seqtab, "/data/iskoec/dada2_R/silva_nr_v132_train_set.fa.gz", multithread=TRUE, tryRC=TRUE)
# Write to disk
saveRDS(seqtab, "/data/iskoec/dada2_R/V13_Dada2/V2/seqtab_nochim_Fs.rds") # CHANGE ME to where you want sequence table saved
saveRDS(tax, "/data/iskoec/dada2_R/V13_Dada2/V2/tax_final_Fs.rds") # CHANGE ME ...