#!/bin/bash

#To change compilers and flags edit the first and second lines of the Makefile
#If npes are changed in the vartypes.f90 it must also be changed here (may change files to someplace more appropriate)
#The number of days the program runs is set in inputs.dat the variable below must be correct to get proper plots of all the data
#Some additional software may be required to run this scripts and generate and view all results. 
#I have used python(select scripts require interpreter), gnuplot, imageMagick(may not be needed anymore),
  # mencoder(creates video from day plos), and vlc(all purpose video player) 
#All necessary software is opensource and works on linux (almost certain it works on mac too)


npes=48
days=150

make all

if [ $? -eq 0 ] 
  then 

  time mpirun -n $npes ./torus > runlog

  if [ $? -ge 0 ] 
    then 

    mv DENS*.dat plots/.  
    mv MIXR*.dat plots/.  
    mv TEMP*.dat plots/.  
    mv INTS*.dat plots/.  
    mv intensity*.dat plots/.  

    cd plots
       
      python radData.py
      ./radialplots.sh $days MIXR
      mv animated.avi ../dens.avi

      mv DENS*.dat data/.  
      mv MIXR*.dat data/.  
      mv TEMP*.dat data/.  
      mv INTS*.dat data/.  
      rm intensity*.dat

      cd data
        ./organize.sh    
#        ./peakPlot.sh $days
#        ./plotRatio.sh $days
#        cp peaks.jpeg ../../.
#        cp peakRatio.jpeg ../../.
      cd ..

    cd ..

  fi

fi

make clean

vlc dens.avi 



