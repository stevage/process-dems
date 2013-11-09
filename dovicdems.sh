#!/bin/bash
#f=dtm10m_e
#f=dtm10m_nw
f=dtm20m
for f in dtm20m dtm10m_nw; do
export GDAL_CACHEMAX=1000
echo -n "Re-projecting: "
gdalwarp  -s_srs EPSG:3111 -t_srs EPSG:3785 -r bilinear ./vmelev_${f}/${f} ${f}-3785.tif 

#exit

echo -n "Generating hill shading: "
#TODO install dev version of gdal in order to use -combined option.
gdaldem hillshade -z 5 $f-3785.tif $f-3785-hs.tif
echo and overviews:
gdaladdo -r average $f-3785-hs.tif 2 4 8 16


echo -n "Generating slope files: "
gdaldem slope $f-3785.tif $f-3785-slope.tif 
echo -n "Translating to 0-90..."
gdal_translate -ot Byte -scale 0 90 $f-3785-slope.tif $f-3785-slope-scale.tif
echo "and overviews."
gdaladdo -r average $f-3785-slope-scale.tif 2 4 8 16
  
#echo -n Translating DEM...
#gdal_translate -ot Byte -scale 0 2000 $f-3785.tif $f-3785-scale.tif 
#echo and overviews.
#gdaladdo -r average $f-3785-scale.tif 2 4 8 16

echo Creating contours
gdal_contour -a elev -i 20 $f-3785.tif $f-3785-contour.shp
shapeindex ${f}-3785-contour.shp
done
