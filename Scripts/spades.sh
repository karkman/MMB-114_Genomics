#!/bin/bash -l
#SBATCH --job-name spades
#SBATCH --output slurm_logs/spades_out_%j.txt
#SBATCH --error slurm_logs/spades_err_%j.txt
#SBATCH --time 1:00:00
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 4
#SBATCH --mem 5G
#SBATCH --account project_2006616
#SBATCH --gres=nvme:20

module load spades/3.15.5

spades.py -1 Data/MMB-114_trimmed_1.fastq.gz \
          -2 Data/MMB-114_trimmed_2.fastq.gz \
          -t $SLURM_CPUS_PER_TASK \
          --careful \
          --tmp-dir $LOCAL_SCRATCH \
          -o results/SPADES

