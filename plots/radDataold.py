import os
import sys

radsize=1
latsize=48
radspan=.5

for root,dirs,files in os.walk("./"):
  if root != "./":
    for file in files:
      if file.endswith("rad.dat"):
        path=os.path.abspath(root)
        path=path+"/"+file
        os.remove(path)

def createData(file):
  infile = open(file, "r")
  outfile = open(file.replace(".dat", "rad.dat"), "w")
  for i in range(1, radsize+1):
    total=0.0
    lat=0.0
    value=0.0
    rad=6.0+((i-1)*radspan/radsize)
    for j in range(1, latsize):
      line=infile.readline()
      [lat,value]=line.split()
      total=total+float(value);
      avg=total/latsize;
    outfile.write(str(rad)+" ");
    outfile.write(str(avg)+"\n");
    line=infile.readline()
    [lat,value]=line.split()
  infile.close()
  outfile.close()

for root,dirs,files in os.walk("./"):
  if root != "./":
    for file in files:
      if file.endswith(".dat"):
#        print "here"
        path=os.path.abspath(root)
        path=path+"/"+file
#        print path
        createData(path)
#        print "HERE"


