# MicrobiomeData
Scripts used to process sequencing data of stool samples

## Biowulf Scripts
See [**Biowulf Scripts**](https://github.com/eisko/MicrobiomeData/tree/master/Biowulf%20Scripts) for all scripts used to run Dada2 pipeline through sbatch submission on biowulf. Shell scripts (\*.sh) are chained together starting with filter step. Running `sbatch dada2_filter.sh` should start off chain.

Input are forward and reverse fastq files in seperate folders. Output includes multiple RDS files. These RDS files are saved tables to quantitate in/out number of reads for different parts of pipeline). Multiple pics will also be created/saved to visualize and assess number of reads lost through each step.

Scripts chained together in pipeline:

filter --> sampleinfer --> nonchimTax --> tracker_script

