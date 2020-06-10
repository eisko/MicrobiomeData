#!/bin/bash

#SBATCH --job-name dada2_sampleinfer
#SBATCH --mail-type=BEGIN,END
#SBATCH --mem=100g
#SBATCH --cpus-per-task=20
#SBATCH --gres=lscratch:200

# to add dependency: --dependency=afterok:$SLURM_JOB_ID

export TMPDIR=/lscratch/$SLURM_JOB_ID

module load R

Rscript /home/$USER/myscripts/dada2_biowulf_sampleinfer.R > /home/$USER/myoutput/dada2_sampleinfer_$SLURM_JOB_ID.out

# chaining scripts together
sbatch /home/$USER/myscripts/dada2_nochimTax.sh