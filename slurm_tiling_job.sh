#!/bin/bash
#SBATCH --time=4:00:00

#SBATCH -N 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --mem=6GB

#SBATCH --mail-type=end,fail
#SBATCH --mail-user=i.otero.coto@gmail.com

# Receives PROJECT_DIR as a PARAMETER

QUPATH_BIN=/mnt/netapp2/translational_oncology/QuPath/bin/QuPath
SRC_DIR=/home/usc/mg/ioc/repos/export_tiles
PROJECT_NAME=${PROJECT_DIR##*/}

ANNOTATION=${PROJECT_DIR}/${PROJECT_NAME}.geojson
if grep -q Tumor ${ANNOTATION} 2>/dev/null; then
    echo "Tumor tag detected"
else
    echo "Tumor tag not detected, inserting"
    n_lines=$(grep -n properties ${ANNOTATION} | cut -f1 -d":")
    >| ${ANNOTATION}.edit
    last_line=1
    total_lines=$(grep -c . $ANNOTATION)
    for n_line in ${n_lines[@]}; do
        tail -n +$((last_line)) ${ANNOTATION} \
        | head -n $((n_line-last_line+1)) \
        >> ${ANNOTATION}.edit
        cat tumor_annotation.txt >> ${ANNOTATION}.edit
        last_line=$((n_line + 3))
    done
    tail -n +$last_line ${ANNOTATION} \
    >> ${ANNOTATION}.edit
    mv ${ANNOTATION}.edit ${ANNOTATION}
fi

echo "Setting headless parameters"
Xvfb :99 &
export DISPLAY=:99
export JAVA_OPTS="$JAVA_OPTS -Djava.awt.headless=true"

echo "Creating empty project"
${QUPATH_BIN} script \
    $SRC_DIR/create_project.groovy \
    -a ${PROJECT_DIR}

echo "Importing annotation"
${QUPATH_BIN} script \
    $SRC_DIR/import_annotation.groovy \
    -p ${PROJECT_DIR}/QuPathProject/project.qpproj \
    -a ${PROJECT_DIR}/${PROJECT_NAME}.geojson \
    -s

echo "Exporting tiles"
${QUPATH_BIN} script \
    $SRC_DIR/export_tiles.groovy \
    -p ${PROJECT_DIR}/QuPathProject/project.qpproj

${SRC_DIR}/remove_spaces.sh ${PROJECT_DIR}