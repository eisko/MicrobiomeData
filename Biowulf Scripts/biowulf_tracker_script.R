# generate figures to analyze pipeline
# last edit: 3/26/20 ECI

library(dada2)
library(ggplot2)
library(tidyverse)
library(gridExtra)
library(grid)

# CHANGE - map files to proper location
tracker <- readRDS("/data/iskoec/dada2_R/V13_Dada2/V1/tracker.rds")
filterout <- readRDS("/data/iskoec/dada2_R/V13_Dada2/V1/filterout.rds")
mergers <- readRDS("/data/iskoec/dada2_R/V13_Dada2/V1/mergers.rds")
seqtab_nochim <- readRDS("/data/iskoec/dada2_R/V13_Dada2/V1/seqtab_nochim.rds")

# CHANGE - delineate folder to save graphs
savepath <- "/data/iskoec/dada2_R/V13_Dada2/V1/"

# CHANGE - name experiment
exp <- "V1"

# CHANGE - document pipeline changes made
settings <- file(paste0(savepath, exp, "_settings.txt"))
writeLines(c("Pipeline settings used to run V13 samples for presentation", 
             "Used settings suggested by Sean Conlan (Segre lab bioinformatician)",
             "FilterandTrim: maxEE=c(2,4), truncQ=2, maxN=0, rm.phix=TRUE,",
             "\tcompress=TRUE, verbose=TRUE, multithread=TRUE",
             "MergePairs: minOverlap=10, maxMismatch = 1",
             "Nonchim:,method='consensus', multithread=TRUE"),
           settings)
close(settings)



# script starts here - doesn't need changes necessarily

# create tracker df to keep track of reads in/out each step
getN <- function(x) sum(getUniques(x))

tracker[,2] <- filterout[,1]
tracker[,3] <- filterout[,2]
tracker[,6] <- sapply(mergers, getN)
tracker[,7] <- rowSums(seqtab_nochim)

tracker_df <- as.data.frame(tracker)
names(tracker_df) <- c("SampleNames", "input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")

number <- function(x) as.numeric(as.character(x))
tracker_df[,2:7] <- sapply(tracker_df[,2:7], number)


# create data table suited for ggplots
ggtracker <- pivot_longer(tracker_df, -SampleNames, names_to = "Step", values_to = "Reads")
ggtracker$Step <- factor(ggtracker$Step, levels = c("input", "filtered", "denoisedF", "denoisedR",   "merged",  "nonchim"))


# create bargraphs to visualize where losing reads
end <- dim(ggtracker)[1]

p25 <- ggplot(data=ggtracker[1:150,], aes(x=SampleNames, y=Reads, fill=Step)) +
  geom_bar(stat="identity", position=position_dodge()) +
  ylim(0,100000) +
  ggtitle("Samples 1-25") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

p50 <- ggplot(data=ggtracker[151:300,], aes(x=SampleNames, y=Reads, fill=Step)) +
  geom_bar(stat="identity", position=position_dodge()) +
  ylim(0,100000) +
  ggtitle("Samples 25-50") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

p75 <- ggplot(data=ggtracker[301:450,], aes(x=SampleNames, y=Reads, fill=Step)) +
  geom_bar(stat="identity", position=position_dodge()) +
  ylim(0,100000) +
  ggtitle("Samples 50-75") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

pend <- ggplot(data=ggtracker[451:end,], aes(x=SampleNames, y=Reads, fill=Step)) +
  geom_bar(stat="identity", position=position_dodge()) +
  ylim(0,100000) +
  ggtitle("Samples 75-96") +
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.5))

g <- arrangeGrob(p25, p50, p75, pend, nrow = 2)
ggsave(paste0(savepath, exp, "_pipelinepic.png"), g, width=10, height=7)

# create scaterplot of input vs. output reads
gline <- ggplot(tracker_df, aes(x=input, y=nonchim)) +
  geom_point() +
  geom_hline(yintercept = 2000, color = "darkgreen") + # should exclude samples with <2000 reads
  geom_abline(slope = 0.5, intercept = 0, color = "blue") + # should exclude reads where <50% of reads are retained
  geom_abline(slope = 1, intercept = 0, color = "red") +
  annotate("rect", xmin=0, xmax=30000, ymin=50000, ymax=60000, color = "black", fill="white") +
  annotate("text", x=15000, y = 58000, label = "100% reads", color = "red") +
  annotate("text", x=15000, y = 55000, label = "50% reads", color = "blue") +
  annotate("text", x=15000, y = 52000, label = "2000 reads cutoff", color = "darkgreen")

ggsave(paste0(savepath, exp, "_reads_in_v_out.png"), gline, width=10)



# Create table with percents
tracker_100 <- tracker_df %>% filter(input > 100)

percent <- function(x) (x/tracker_100$input*100)

tracker_perc <- tracker_100 %>% transmute_if(is.numeric, percent)
tracker_perc <- cbind.data.frame(SampleNames = tracker_100$SampleNames, tracker_perc)

#create histogram of percent output/input*100
pperc <- ggplot(data=tracker_perc, aes(x=nonchim)) +
  geom_histogram() +
  xlab("% final reads (nonchim/input)") +
  annotate("rect", xmin=42, xmax=48, ymin=11.5, ymax=13.5, color = "black", fill="white") +
  annotate("text", x=45, y = 12.5, 
           label = paste0("mean: ", round(mean(tracker_perc$nonchim), digits= 2), 
                          "\nsd: ", round(sd(tracker_perc$nonchim), digits= 2)), 
           size = 3.5)
pperc

ggsave(paste0(savepath, exp, "_perc_histo.png"), pperc, width=10)





