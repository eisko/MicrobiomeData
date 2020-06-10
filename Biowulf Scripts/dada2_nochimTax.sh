#!/bin/bash

#SBATCH --job-name dada2_nochimTax
#SBATCH --mail-type=BEGIN,END
#SBATCH --mem=100g
#SBATCH --cpus-per-task=10
#SBATCH --gres=lscratch:200

# to add dependency: --dependency=afterok:$SLURM_JOB_ID

export TMPDIR=/lscratch/$SLURM_JOB_ID

module load R

Rscript /home/$USER/myscripts/dada2_biowulf_nochimTax.R > /home/$USER/myoutput/dada2_nochimTax_$SLURM_JOB_ID.out

# chaining scripts together
sbatch /home/$USER/myscripts/dada2_tracker.sh