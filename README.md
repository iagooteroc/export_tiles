# export_tiles
Export tiles with annotation from QuPath

## Requirements
Inside `SLIDE_TILING/{SAMPLE_NAME}/`:
    - `{SAMPLE_NAME}.tiff` which can be a symbolic link
    - `{SAMPLE_NAME}.geojson` with the annotation

## Tiling

```bash
./launch_tiling.sh /mnt/netapp2/translational_oncology/SLIDE_TILING/COLAB_CHUS_10_20220513_0943_0_5
```

## Filtering
To filter tiles by their percentage of annotated pixels (default: >=50%):

```bash
python ./filter_tiles.py /mnt/netapp2/translational_oncology/SLIDE_TILING/COLAB_CHUS_10_20220513_0943_0_5
```

This will generate a "OK_tiles.txt" file inside the tiles folder listing the names of the tiles that pass the filter

## Normalizing

```bash
module load miniconda3/4.11.0
conda activate SPAMS_conda4.11.0
./launch_normalize.sh /mnt/netapp2/translational_oncology/SLIDE_TILING/COLAB_CHUS_10_20220513_0943_0_5 vahadane
```

### Warning
You need this in your `~/.bashrc`:

```
channels:
  - conda-forge
  - bioconda
  - defaults
  - r
envs_dirs:
  - /mnt/netapp2/uscmg_aplic/3_environments/python/
pkgs_dirs:
  - /mnt/netapp2/uscmg_aplic/3_environments/python/pkgs
```