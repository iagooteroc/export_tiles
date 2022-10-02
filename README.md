# export_tiles
Export tiles with annotation from QuPath

```
./launch_tiling.sh /mnt/netapp2/translational_oncology/SLIDE_TILING/COLAB_CHUS_10_20220513_0943_0_5
```

To filter tiles by their percentage of annotated pixels (default: >=50%):

```
python ./filter_tiles.py /mnt/netapp2/translational_oncology/SLIDE_TILING/COLAB_CHUS_10_20220513_0943_0_5
```

This will generate a "OK_tiles.txt" file inside the tiles folder listing the names of the tiles that pass the filter