#!/bin/bash -l
#SBATCH --job-name spades
#SBATCH --output slurm_logs/spades_out_%j.txt
#SBATCH --error slurm_logs/spades_err_%j.txt
#SBATCH --time 2:00:00
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 4
#SBATCH --mem 5G
#SBATCH --account project_2006616
#SBATCH --gres=nvme:20

module load spades/3.15.5

spades.py -1 * \
          -2 * \
          -t $SLURM_CPUS_PER_TASK \
          --isolate \
          --tmp-dir $LOCAL_SCRATCH \
          -o results/SPADES

