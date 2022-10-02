#!/bin/bash
#-----------------------------------------------------------------------
# launch_tiling.sh
# PARAMETERS: 
# $1: full path to the directory containing the image and its annotation
#-----------------------------------------------------------------------

THIS_DIR=$(dirname $0)
PROJECT_DIR_ARG=${1}
PROJECT_DIR=$(echo $PROJECT_DIR_ARG | sed 's;\/$;;')
PROJECT_NAME=${PROJECT_DIR##*/}
LOGDIR=${PROJECT_DIR}/logs
mkdir -p ${LOGDIR}

sbatch --export=PROJECT_DIR=${PROJECT_DIR} \
--job-name ${PROJECT_NAME} \
--error=${LOGDIR}/${PROJECT_NAME}.tiling."%j".err \
--output=${LOGDIR}/${PROJECT_NAME}.tiling."%j".out \
${THIS_DIR}/slurm_tiling_job.sh