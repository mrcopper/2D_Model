#!/bin/bash

lng=1
rad=37
npes=$(($rad * $lng))
days=50

./changeDimension.sh $rad $lng

#echo $lng $rad $npes

make all

if [ $? -eq 0 ] 
  then 

  echo "Model Compiled"
  date
  time mpirun -n $npes ./torus > runlog
   
  if [ $? -ge 0 ] 
    then 
    echo "Run Completed Successfully"

    ./moveData.sh $rad $lng

    ./transport.sh $days

    cd plots

#      ./azplots $days MIXR 
#      mv animated.mpeg ../azdens.mpeg

#      ./3Dplots $days MIXR sp
#      mv animated.mpeg ../3dspplot.mpeg
#      mv 3dlast.jpeg ../3dspplot.jpeg

#      ./3Dplots $days MIXR s3p
#      mv animated.mpeg ../3ds3pplot.mpeg
#      mv 3dlast.jpeg ../3ds3pplot.jpeg

#      ./3Dplots $days VSUB .
#      mv animated.mpeg ../3dVelPlot.mpeg

      ./radialplots $days DENS
      mv animated.mpeg ../raddens.mpeg

      ./radialplots $days NL2_
      mv animated.mpeg ../radnl2.mpeg

      ./radialplots $days MIXR
      mv animated.mpeg ../radmix.mpeg

      ./radialplots $days TEMP
      mv animated.mpeg ../radtemp.mpeg

#      ./azplots $days TEMP
#      mv animated.mpeg ../aztemp.mpeg

#      ./azplots $days DENS
#      mv animated.mpeg ../azdens.mpeg

#      ./miscPlot $days MOUT
#      mv misc.mpeg ../misc.mpeg

    cd ..

    ./plots/mixRatio.sh $days

#    vlc dens.mpeg

  fi
  make clean
  echo "Run Complete"
fi

paplay --volume=65000 /usr/share/sounds/KDE-Im-Message-In.ogg

#gifview -a dens.gif &
#mplayer -loop -0 dens.avi &
#vlc intensity.avi &
#mplayer dens.avi &
#display peaks.jpeg & 
#display peakRatio.jpeg  
#display overlay.jpeg



