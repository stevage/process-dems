#!/bin/bash
echo Creating contours
f=srtm
gdal_contour -a elev -i 20 $f-3785.tif $f-3785-contour.shp
shapeindex ${f}-3785-contour.shp

