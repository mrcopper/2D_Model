import pandas
import os
import copy
import matplotlib.pyplot as plt
import numpy

def transpose(array):
  return map(list, zip(*array)) 

def getData(E, sig):
  tmp=[]
  tmp=pandas.read_csv('Expected.dat', sep='\t', header=None)
  tmp=tmp.values
  tmp=transpose(tmp)
  E=tmp
  tmp=pandas.read_csv('Sigma.dat', sep='\t', header=None)
  tmp=tmp.values
  tmp=transpose(tmp)
  sig=tmp
#  print E, '\n'
#  print sig
  return [E, sig]

def getOutput(output,run):
  paths=[]
  pathParams=[["elec", "DENS"], ["op", "MIXR"], ["o2p","MIXR"], ["sp","MIXR"], ["s2p","MIXR"], ["s3p","MIXR"], ["elec", "NL2_"], ["elec", "TEMP"]]
  for i in range(0,len(pathParams)):
    path="./"+run+"/"+pathParams[i][0]+"/"+pathParams[i][1]+"/"+pathParams[i][1]+pathParams[i][0]+"0200rad.dat"
    if(not os.path.isfile(path)):
      return 0
    paths.append(path)
#    print os.path.isfile(path)
#  print paths
  output.append([])
  for f in paths:
    data=pandas.read_csv(f, sep=' ', header=None)
    data=data.values
    data=transpose(data) 
    output.append(data[1])
  output[0]=data[0]
  return 1    

def modifyOutput(output, O):
  for i in range(0, len(O)):
    for j in range(0, 4):
      O[i][len(O[i])-1-3*j]=output[i+1][j]    
  return O

def calculateChi(O, E, sig):
  chis=[]
  chi=0
  for i in range(0, len(O)):
    start=0
    if i == len(O)-1:
      start=1
    for j in range(start, 4):
      k=len(O[i])-1-j*3
      chi=chi+(((O[i][k] - E[i][k])**2)/sig[i][k]**2)
    chis.append(chi)
  return chis

def output(s, dll, chis, filenames):
  for i in range(0, len(chis)):
    out=open(filenames[i]+".dat", 'a')
    out.write(str(dll)+"e-7 ")
    out.write(str(s)+"e28 ")
    out.write(str(chis[i])+'\n')
    out.close()

def outputSpace(filenames):
  for i in range(0, len(chis)):
    out=open(filenames[i]+".dat", 'a')
    out.write('\n')
    out.close()

def makePlot(x, y, z):
#  plt.subplot(1, 1, 1)
  plt.figure()
  x=numpy.array(x)
  y=numpy.array(y)
  z=numpy.array(z)
  print x[3]
  print y
  print z
  #z_min, z_max = -numpy.abs(z).max(), numpy.abs(z).max()
  plt.pcolor(x, y, z)#, cmap='RdBu', vmin=z_min, vmax=z_max)
  plt.title('Chi')
  # set the limits of the plot to the limits of the data
#  plt.axis([min(x), max(x), min(y), max(y)])
  plt.colorbar()
  plt.show()
  plt.savefig("chi.png")

E=[]
sig=[]
[E, sig]=getData(E, sig)
outputs=[]
filenames=["elecDens", "op", "o2p", "sp", "s2p", "s3p", "NL2", "elecTemp"] 
for name in filenames: open(name+'.dat', 'w').close()
out=open("chi.dat", 'a')
s=[1.0, 2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0]
dll=[3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0]
#for s in {1.0, 2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0}: #take from gatherData.py that generated the data
for i in range(0, len(dll)) :
 # for dll in {3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0}:
  for j in range(0, len(s)) : #take from gatherData.py that generated the data
    run="s="+str(s[j])+":dll="+str(dll[i])
    if(not os.path.exists("./"+run)): print "BAD", run
    O=copy.deepcopy(E)
    outputs=[]
    if(getOutput(outputs, run)):
      O=modifyOutput(outputs, O)
    #  print outputs
      chis=calculateChi(O, E, sig)
      chi=chis[3]
      output(s[j], dll[i], chis, filenames)
      #print dll[i], s[j]
  outputSpace(filenames)
  #out=open("chi.dat", 'a')
  #out.write('\n')
  #out.close()

os.popen("gnuplot plot.gnu")
#print x
#print y
#print z
#makePlot(x, y, z) #<-BROKEN
    #GetData(E, sig)
    #GetOutput(output)
    #ModifyOutput(output, O)
    #calculate chi squared(O, E, sig)
    #output chi squared, s, dll in proper order for plotting
#plot heatmap of chi squared
