#!/bin/bash
#SBATCH --time=6:00:00

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=12GB

#SBATCH --mail-type=end,fail
#SBATCH --mail-user=i.otero.coto@gmail.com

module load miniconda3/4.11.0
conda activate SPAMS_conda4.11.0
SRC_DIR=/home/usc/mg/ioc/repos/export_tiles

python ${SRC_DIR}/normalize_tiles.py ${PROJECT_DIR} ${METHOD}