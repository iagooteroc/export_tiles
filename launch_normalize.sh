#!/bin/bash
#-----------------------------------------------------------------------
# launch_normalize.sh
# PARAMETERS: 
# $1: full path to the directory containing the image and its annotation
# $2: name of the normalization method (vahadane, macenko)
#-----------------------------------------------------------------------

THIS_DIR=$(dirname $0)
PROJECT_DIR_ARG=${1}
METHOD=${2}
PROJECT_DIR=$(echo $PROJECT_DIR_ARG | sed 's;\/$;;')
PROJECT_NAME=${PROJECT_DIR##*/}
LOGDIR=${PROJECT_DIR}/logs
mkdir -p ${LOGDIR}

sbatch --export=PROJECT_DIR=${PROJECT_DIR},METHOD=${METHOD} \
--job-name ${PROJECT_NAME} \
--error=${LOGDIR}/${PROJECT_NAME}.normalize."%j".err \
--output=${LOGDIR}/${PROJECT_NAME}.normalize."%j".out \
${THIS_DIR}/slurm_normalize_job.sh