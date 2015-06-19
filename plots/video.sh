#!/bin/bash

mencoder -nosound -ovc lavc -lavcopts \
  vcodec=mpeg4:mbd=2:trell:autoaspect:vqscale=3 \
  -vf scale=640:480 -mf type=jpeg:fps=10 \
  mf://@list.dat -o animated.mpeg

