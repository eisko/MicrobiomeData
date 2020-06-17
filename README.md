# MicrobiomeData
Scripts used to process sequencing data of stool samples

## Biowulf Scripts
See [**Biowulf Scripts**](https://github.com/eisko/MicrobiomeData/tree/master/Biowulf%20Scripts) for all scripts used to run Dada2 pipeline through sbatch submission on biowulf. Shell scripts (\*.sh) are chained together starting with filter step. Running `sbatch dada2_filter.sh` should start off chain.

Input are forward and reverse fastq files in seperate folders. Output includes multiple RDS files. These RDS files are saved tables to quantitate in/out number of reads for different parts of pipeline). Multiple pics will also be created/saved to visualize and assess number of reads lost through each step.

Scripts chained together in pipeline:

filter --> sampleinfer --> nonchimTax --> tracker_script

Used [**dada2 tutorial for big data**](https://benjjneb.github.io/dada2/bigdata_paired.html) to generate pipeline.


**********************************
# Picrust2
Followed tutorial for Picrust2 to generate .tsv files: [**Picrust2 Tutorial**](https://github.com/picrust/picrust2/wiki/PICRUSt2-Tutorial-(v2.1.4-beta))

Wanted to use [**STAMP**](https://beikolab.cs.dal.ca/software/STAMP) to analyze picrust2 output. Had a really hard time installing it on Mac. Biom-format package (needed python 3) was incompatible with stamp (needed python 2).

Found this [solution](https://groups.google.com/forum/?hl=en#!topic/stamp_help/VSTSqyE2Kec) and seems to work. Solution centered around specifying correct biom-format version. Works for installing stamp on macs.


*************************************


# Useful links/tutorials
- [**Dada2**](https://benjjneb.github.io/dada2/tutorial.html)
- [**PhyloSeq**](https://joey711.github.io/phyloseq/)
- [**Picrust2**](https://github.com/picrust/picrust2/wiki)
  - used Picrust2 but [**Picrust**](http://picrust.github.io/picrust/) page has some helpful info
- [**Stamp**](https://beikolab.cs.dal.ca/software/STAMP) for visualizing picrust2 output. Had trouble loading this package on laptop
