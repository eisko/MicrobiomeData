# dada2 biowulf script for removing chimeras and assigning taxonomy
# copied from: https://benjjneb.github.io/dada2/bigdata.html

library(dada2); packageVersion("dada2")
# Merge multiple runs (if necessary)
st <- readRDS("/data/iskoec/dada2_R/V13_Dada2/V1/seqtab.rds") # CHANGE ME

# Remove chimeras
seqtab_nochim <- removeBimeraDenovo(st, method="consensus", multithread=TRUE)
# Assign taxonomy
tax <- assignTaxonomy(seqtab_nochim, "/data/iskoec/dada2_R/silva_nr_v132_train_set.fa.gz", multithread=TRUE)
# Write to disk
saveRDS(seqtab_nochim, "/data/iskoec/dada2_R/V13_Dada2/V1/seqtab_nochim.rds") # CHANGE ME to where you want sequence table saved
saveRDS(tax, "/data/iskoec/dada2_R/V13_Dada2/V1/tax_final.rds") # CHANGE ME ...

