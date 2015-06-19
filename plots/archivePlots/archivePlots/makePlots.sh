DIR=$1

mkdir ./FitPlots/$1
./mixRatio.sh 200 $1
mv *mix.jpeg ./FitPlots/$1/.
./radialplots.sh 200 DENS $1
mv animated.mpeg ./FitPlots/$1/raddens.mpeg
./radialplots.sh 200 TEMP $1
mv animated.mpeg ./FitPlots/$1/radtemp.mpeg
./radialplots.sh 200 NL2_ $1
mv animated.mpeg ./FitPlots/$1/radnl2.mpeg
