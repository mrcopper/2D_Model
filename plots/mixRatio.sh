#!/bin/bash

day=$1
if [ $(($day)) -lt 10 ]
then
  i="000"$day""
else if [ $(($day)) -lt 100 ]
  then
    i="00"$day""
  else if [ $(($day)) -lt 1000 ]
    then
      i="0"$day""
  fi
fi
fi

FILE='test'
DIR='/home/mrcopper/Desktop/Project/2D_Model/plots/data'
OBSDIR='/home/mrcopper/Desktop/Project/2D_Model/plots/Observations'

echo 'set terminal jpeg'                                      >$FILE
echo 'set logscale y'                                        >>$FILE
echo 'set key below'                                         >>$FILE
echo 'set size 1, 1'                                         >>$FILE
echo "set xlabel 'Radial Distance(Rj)'"                      >>$FILE
echo "set ylabel '$PREFIX'"                                  >>$FILE
echo "set xrange [6.0:9.0]"                                  >>$FILE
echo "set yrange [0.01:1.0]"                                    >>$FILE
echo "set xtics 0.5"                                          >>$FILE
#echo "set ytics .10"                                         >>$FILE
echo "set grid ytics"                                        >>$FILE
echo "set grid xtics"                                        >>$FILE

options='with lines'
obsopt='with errorbars'

echo "set title 'Mixing Ratio of Sulfur +'" >>$FILE
echo "set output 'spmix.jpeg'" >> $FILE  
echo "plot '"$DIR"/sp/MIXR/MIXRsp"$i"rad.dat'  "$options" title 'Sulfur + (II)'  , " '\' >> $FILE
echo "     '"$OBSDIR"/spmix.dat' "$obsopt" title 'Sulfur + Observed' "  >> $FILE

echo "set title 'Mixing Ratio of Sulfur ++'" >>$FILE
echo "set output 's2pmix.jpeg'" >> $FILE  
echo "plot '"$DIR"/s2p/MIXR/MIXRs2p"$i"rad.dat'  "$options" title 'Sulfur ++ (III)'  , " '\' >> $FILE
echo "     '"$OBSDIR"/s2pmix.dat' "$obsopt" title 'Sulfur ++ Observed' "  >> $FILE

echo "set title 'Mixing Ratio of Sulfur +++'" >>$FILE
echo "set output 's3pmix.jpeg'" >> $FILE  
echo "plot '"$DIR"/s3p/MIXR/MIXRs3p"$i"rad.dat'  "$options" title 'Sulfur +++ (IV)'  , " '\' >> $FILE
echo "     '"$OBSDIR"/s3pmix.dat' "$obsopt" title 'Sulfur +++ Observed' "  >> $FILE

echo "set title 'Mixing Ratio of Oxygen +'" >>$FILE
echo "set output 'opmix.jpeg'" >> $FILE  
echo "plot '"$DIR"/op/MIXR/MIXRop"$i"rad.dat'  "$options" title 'Oxygen + (II)'  , " '\' >> $FILE
echo "     '"$OBSDIR"/opmix.dat' "$obsopt" title 'Oxygen + Observed' "  >> $FILE

echo "set title 'Mixing Ratio of Oxygen ++'" >>$FILE
echo "set output 'o2pmix.jpeg'" >> $FILE  
echo "plot '"$DIR"/o2p/MIXR/MIXRo2p"$i"rad.dat'  "$options" title 'Oxygen ++ (III)'  , " '\' >> $FILE
echo "     '"$OBSDIR"/o2pmix.dat' "$obsopt" title 'Oxygen ++ Observed' "  >> $FILE

gnuplot $FILE




