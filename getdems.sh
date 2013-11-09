for x in {59..67}; do
for y in {14..21}; do
echo $x,$y
if [ ! -f srtm_${x}_${y}.zip ]; then
wget http://droppr.org/srtm/v4.1/6_5x5_TIFs/srtm_${x}_${y}.zip
else
echo "Already got it."
fi
done
done
unzip '*.zip'
