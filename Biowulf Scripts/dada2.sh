#!/bin/bash

#SBATCH --job-name dada2_V4_nochimTax_v3
#SBATCH --mail-type=BEGIN,END
#SBATCH --mem=300g
#SBATCH --cpus-per-task=10
#SBATCH --gres=lscratch:200

# to run sbatch script, submit this to biowulf: sbatch /home/iskoec/myscripts/dada2.sh

export TMPDIR=/lscratch/$SLURM_JOB_ID

module load R

# Run R script from folder where want out file


Rscript /home/iskoec/myscripts/dada2_biowulf_nochimTax.R > /home/iskoec/myoutput/dada2_nochimTax_v3.out