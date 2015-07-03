import os
import sys
import shutil
import itertools

def switchline(linenum, value):
  parameters=open("./inputs.dat")
  tmp=open("./tmp.tmp", 'w')
  i=0
  for line in parameters:
    i=i+1
    if i==linenum:
      tmp.write(value)
      tmp.write('\n')
    else:
      tmp.write(line)
  tmp.close()
  parameters.close()
  shutil.move("./tmp.tmp", "./inputs.dat")

def catalog(extension):
  path="./plots/archive/"+extension+"/"
  if (not os.path.exists(path)):
    shutil.copytree("./plots/data/", path)
    shutil.copy("./inputs.dat",path+"inputs.dat")
    shutil.copy("./runlog",path+"runlog")

os.popen("date >chirun.dat")
i=0
lng=1
rad=18
npes=lng*rad
os.popen("./changeDimension.sh "+ str(rad) + " " + str(lng))
os.popen("make clean")
os.popen("make all")
sourceArray=[5.0, 6.0, 7.0, 8.0, 10.0]
lens=len(sourceArray)
sourceAlphaArray=[-12.0, -14.5]
lensa=len(sourceAlphaArray)
dllArray=[6.5, 8.0, 9.5, 11.0, 15.0]
lend=len(dllArray)
dllAlphaArray=[3.5, 4.5, 5.5]
lenda=len(dllAlphaArray)
fheArray=[0.0020, 0.0030]
lenf=len(fheArray)
fheAlphaArray=[3.5, 5.0, 7.0]
lenfa=len(fheAlphaArray)
runs=lens*lensa*lend*lenda*lenf*lenfa
product=itertools.product(range(0,lens), range(0,lensa), range(0,lend), range(0,lenda), range(0,lenf), range(0,lenfa))
for index in product:
#    extension="s="+str(source)+":dll="+str(dll)a
    source=sourceArray[index[0]]
    sourceAlpha=sourceAlphaArray[index[1]]
    dll=dllArray[index[2]]
    dllAlpha=dllAlphaArray[index[3]]
    fhe=fheArray[index[4]]
    fheAlpha=fheAlphaArray[index[5]]
    extension="run-"+str(index)
    path="./plots/archive/"+extension+"/"
    if ( 1 ):#not os.path.exists(path)):
      source1=str(source)+"e28"
      switchline(4, source1)
      switchline(5, str(sourceAlpha))
      switchline(7, str(fhe))
      switchline(8, str(fheAlpha))
      dll1=str(dll)+"e-7"
      switchline(9, dll1)
      switchline(10, str(dllAlpha))
      os.popen("mpirun -n "+str(npes)+" ./torus > runlog")
      os.popen("./moveData.sh " + str(rad) +" "+ str(lng))
      catalog(extension)
    i=i+1
    print "Completed run ", i, "/", runs, ".", index
    sys.stdout.flush()

os.popen("date >> chirun.dat")

  #for dll:
    #switch 
    #for feh
      #switch
      #run
      #calculate fit
      #catalog
 

