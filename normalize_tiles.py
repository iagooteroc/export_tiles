import staintools
import sys
import cv2 as cv
import os

REFERENCE_TILE = '/mnt/lustre/scratch/nlsas/home/usc/mg/translational_oncology/SLIDE_TILING/COLAB_CHUS_3_20220513_0837_0_7/QuPathProject/tiles/COLAB_CHUS_3_20220513_0837_0_7/COLAB_CHUS_3_20220513_0837_0_7[x=8192,y=5120,w=1024,h=1024].tif'

# Parameters
if len(sys.argv) < 3:
    raise TypeError("Invalid number of arguments")
SAMPLE_DIR = sys.argv[1]
# vahadane
METHOD = sys.argv[2]

if SAMPLE_DIR.endswith("/"):
    SAMPLE_DIR = SAMPLE_DIR[:-1]

SAMPLE_NAME = SAMPLE_DIR.split("/")[-1]
SAMPLE_TILEDIR = os.path.join(SAMPLE_DIR, "QuPathProject/tiles", SAMPLE_NAME)
OUTPUT_DIR = os.path.join("/".join(SAMPLE_DIR.split("/")[:-1]) + "_" + METHOD.upper(), SAMPLE_NAME)
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Load tile names
# Warning: they end with .png, replace with .tif
with open(SAMPLE_TILEDIR + "/OK_tiles.txt", mode='r') as file:
    tiles = [line.rstrip().replace(".png", ".tif") for line in file]

def progress_bar(current, total, bar_length=20):
    fraction = current / total
    arrow = int(fraction * bar_length - 1) * '-' + '>'
    padding = int(bar_length - len(arrow)) * ' '
    ending = '\n' if current == total else '\r'
    print(f'Progress: [{arrow}{padding}] {int(fraction*100)}%', end=ending)

# Read data
target = staintools.read_image(REFERENCE_TILE)

# Standardize brightness (optional, can improve the tissue mask calculation)
target = staintools.LuminosityStandardizer.standardize(target)

# Stain normalize
normalizer = staintools.StainNormalizer(method=METHOD)
normalizer.fit(target)

i = 1
for tile in tiles:
    # Read data
    to_transform = staintools.read_image(os.path.join(SAMPLE_TILEDIR, tile))
    # Standardize brightness (optional, can improve the tissue mask calculation)
    to_transform = staintools.LuminosityStandardizer.standardize(to_transform)

    transformed = normalizer.transform(to_transform)
    transformed = cv.cvtColor(transformed, cv.COLOR_RGB2BGR)
    cv.imwrite(os.path.join(OUTPUT_DIR, tile), transformed)
    progress_bar(i, len(tiles))
    i += 1