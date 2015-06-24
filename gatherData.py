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
rad=31
npes=lng*rad
os.popen("./changeDimension.sh "+ str(rad) + " " + str(lng))
os.popen("make clean")
os.popen("make all")
sourceArray=[1.0, 2.5, 3.0, 3.5, 5.0]
sourceAlphaArray=[-10.0, -14.5, -16.0]
dllArray=[5.5, 6.5,  7.0, 8.0, 11.0]
dllAlphaArray=[3.5, 4.5, 5.5, 7.0, 9.0]
fheArray=[0.0010, 0.005, 0.01]
fheAlphaArray=[0.7, 2.0, 5.0]
product=itertools.product(range(0,5), repeat=3)
for index in product:
#    extension="s="+str(source)+":dll="+str(dll)a
    source=sourceArray[index[0]]
    sourceAlpha=-13.5
    dll=dllArray[index[1]]
    dllAlpha=dllAlphaArray[index[2]]
    fhe=0.0065
    fheAlpha=1.0
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
    print "Completed run ", i, "/", len(dllArray)**3, ".", index
    sys.stdout.flush()

os.popen("date >> chirun.dat")

  #for dll:
    #switch 
    #for feh
      #switch
      #run
      #calculate fit
      #catalog
 

