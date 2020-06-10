#!/bin/bash

#SBATCH --job-name dada2_tracker
#SBATCH --mail-type=BEGIN,END
#SBATCH --mem=100g
#SBATCH --cpus-per-task=20
#SBATCH --gres=lscratch:100

# to add dependency: --dependency=afterok:$SLURM_JOB_ID

export TMPDIR=/lscratch/$SLURM_JOB_ID

module load R

Rscript /home/$USER/myscripts/biowulf_tracker_script.R > /home/$USER/myoutput/dada2_tracker_$SLURM_JOB_ID.out