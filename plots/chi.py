import pandas
import os
import copy

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
    for j in range(0, 4):
      k=len(O[i])-1-j*3
      chi=chi+(((O[i][k] - E[i][k])**2)/sig[i][k]**2)
    chis.append(chi)
  return chis

def output(s, dll, chi):
  out=open("chi.dat", 'a')
  out.write(str(chi)+" ")
  out.write(str(s)+"e28 ")
  out.write(str(dll)+"e-7"+'\n')
  out.close()

E=[]
sig=[]
[E, sig]=getData(E, sig)
#[E, sig]=getData(E, sig)
outputs=[]
#O=copy.deepcopy(E)
#getOutput(output, "s=1.0:dll=9.0")
#O=modifyOutput(output, O)
#chis=calculateChi(O, E, sig)
out=open("chi.dat", 'w')
out.write("")
out.close()
for dll in {3.0, 4.5, 6.0, 7.5, 9.0, 10.5, 12.0, 15.0, 18.0}:
  for s in {1.0, 2.0, 3.0, 4.0, 4.5, 5.0, 5.5, 6.0, 7.0}: #take from gatherData.py that generated the data
    run="s="+str(s)+":dll="+str(dll)
    if(not os.path.exists("./"+run)): print "BAD", run
    O=copy.deepcopy(E)
    outputs=[]
    if(getOutput(outputs, run)):
      O=modifyOutput(outputs, O)
    #  print outputs
      chis=calculateChi(O, E, sig)
      chi=chis[2]
      output(s, dll, chi)
    #GetData(E, sig)
    #GetOutput(output)
    #ModifyOutput(output, O)
    #calculate chi squared(O, E, sig)
    #output chi squared, s, dll in proper order for plotting
#plot heatmap of chi squared
