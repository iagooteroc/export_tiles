QUPATH_BIN=/mnt/netapp2/translational_oncology/QuPath/bin/QuPath
SRC_DIR=/home/usc/mg/ioc/repos/export_tiles
PROJECT_DIR=/mnt/netapp2/translational_oncology/QuPath_test/COLAB_CHUS_1_20220513_0837_0_5
PROJECT_NAME=${PROJECT_DIR##*/}
# ${QUPATH_BIN} script \
#     $SRC_DIR/export_annotation.groovy \
#     -p /Users/iago/Pictures/JRB/TILES_COLAB_CHUS_1/project.qpproj \
#     -a ${PROJECT_DIR}/COLAB_CHUS_1_20220513_0837_0_5.geojson

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