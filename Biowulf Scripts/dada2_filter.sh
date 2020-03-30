#!/bin/bash

#SBATCH --job-name dada2_filter
#SBATCH --mail-type=BEGIN,END
#SBATCH --mem=100g
#SBATCH --cpus-per-task=70
#SBATCH --gres=lscratch:200

export TMPDIR=/lscratch/$SLURM_JOB_ID

module load R

Rscript /home/iskoec/myscripts/dada2_biowulf_filter.R > /home/iskoec/myoutput/dada2_filter_$SLURM_JOB_ID.out

# chaining scripts together
sbatch /home/iskoec/myscripts/dada2_sampleinfer.sh