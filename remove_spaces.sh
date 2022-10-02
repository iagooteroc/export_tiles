PROJECT_DIR=$1
echo "Removing spaces from filenames of tiles in $PROJECT_DIR"
TILES_DIR=$PROJECT_DIR/QuPathProject/tiles
for d in $(ls $TILES_DIR); do
  for f in $TILES_DIR/$d/*; do
    mv "$f" "${f// /}"
  done
done
echo "Renaming complete"