import numpy as np
from PIL import Image
import sys
from os import listdir, sep
from os.path import isfile, join

SAMPLE_DIR=sys.argv[1]
THR=0.5

# Remove the / at the end if present
if SAMPLE_DIR[-1] == sep:
    SAMPLE_DIR = SAMPLE_DIR[:-1]

SAMPLE_NAME = SAMPLE_DIR.split(sep)[-1]

if "QuPathProject" not in SAMPLE_DIR:
    SAMPLE_DIR = join(SAMPLE_DIR, "QuPathProject", "tiles", SAMPLE_NAME)

# Get the .png files from the directory
files = [f for f in listdir(SAMPLE_DIR) if f.endswith(".png") and isfile(join(SAMPLE_DIR, f))]

OUT_FILE = join(SAMPLE_DIR, "OK_tiles.txt")

# Iterate and output which files pass the filter
with open(OUT_FILE, 'w') as out_file:
    for file in files:
        img = Image.open(join(SAMPLE_DIR, file))
        ar = np.array(img)
        if np.sum(ar) >= (ar.size * THR):
            print("{} OK".format(file))
            out_file.write(file + "\n")
        else:
            print("{} NOT OK".format(file))