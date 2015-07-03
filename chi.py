import pandas
import os
import copy
import matplotlib.pyplot as plt
import numpy
import itertools

lineNum=34

def transpose(array):
  return map(list, zip(*array)) 

def getData(E, sig):
  tmp=[]
  tmp=pandas.read_csv('./plots/archive/Expected.dat', sep='\t', header=None)
  tmp=tmp.values
  tmp=transpose(tmp)
  E=tmp
  tmp=pandas.read_csv('./plots/archive/Sigma.dat', sep='\t', header=None)
  tmp=tmp.values
  tmp=transpose(tmp)
  sig=tmp
  return [E, sig]

def getOutput(output,run):
  paths=[]
  day=100
  pathParams=[["elec", "DENS"], ["op", "MIXR"], ["o2p","MIXR"], ["sp","MIXR"], ["s2p","MIXR"], ["s3p","MIXR"], ["elec", "NL2_"], ["elec", "TEMP"]]
  for i in range(0,len(pathParams)):
    path="./"+run+"/"+pathParams[i][0]+"/"+pathParams[i][1]+"/"+pathParams[i][1]+pathParams[i][0]+"0"+str(day)+"rad.dat"
#    while(not os.path.isfile(path)):
#      day=day-1
#      path="./"+run+"/"+pathParams[i][0]+"/"+pathParams[i][1]+"/"+pathParams[i][1]+pathParams[i][0]+"0"+str(day)+"rad.dat"
#      if( day == 0 ): return 0
    if( not os.path.isfile(path) ): return 0
    paths.append(path)
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
    for j in range(0, len(O[i])):
      k=j
      if i==len(O)-1: k=j+1
      O[i][len(O[i])-j-1]=output[i+1][k]    
  return O

def calculateChi(O, E, sig):
  chis=[]
  chi=0
  for i in range(0, len(O)):
    for j in range(0, len(O[i])-1):
      k=len(O[i])-1-j
      if not (i==len(O)-1 and j==0):
        chi=chi+(((O[i][k] - E[i][k])**2)/sig[i][k]**2)
    chis.append(chi)
  return chis

def output(outputLine, chis, filenames):
  for i in range(0, len(filenames)):
    out=open("runlog", 'a')
    out.write(outputLine+filenames[i] + " : ")
    out.write(str(chis[i])+'\n')
    out.close()

def outputSpace(filenames):
  for i in range(0, len(filenames)):
    out=open(filenames[i]+".dat", 'a')
    out.write('\n')
    out.close()

def getPuv(folder):
  runlog=open("runlog", 'r')
  lNum=0
  junk=""
  Puv=''
  for line in runlog:
    lNum=lNum+1
    if(lNum == lineNum):
      s=line.rsplit('\n', 1)
#      print s
      while(Puv==''):
       s=s[0].rsplit(' ', 1)
       Puv=s[1]
#       print s
  if(lNum < lineNum):
#    print "ERROR:", run, " only has ", lNum, " lines."
    return 0
  return float(Puv)

def PuvFit(Puv):
  PuvChi=((1.75-Puv)/0.25)**2
  return PuvChi

E=[]
sig=[]
[E, sig]=getData(E, sig)
outputs=[]
filenames=["elecDens", "sp", "o2p", "sp", "s2p", "s3p", "NL2", "elecTemp", "Tot"] 
run="plots/data"
runlog=open("runlog", 'a')
if(not os.path.exists("./"+run)): print "BAD", run
O=copy.deepcopy(E)
outputs=[]
if(getOutput(outputs, run) and os.path.exists("./"+run)):
  O=modifyOutput(outputs, O)
  chis=calculateChi(O, E, sig)
  Puv=getPuv(run)
  PuvChi=PuvFit(Puv)
  chis.append((chis[3] + chis[5] + 12.0*PuvChi )/35.0)
  runlog.write("CHI SQUARED Puv : " + str(PuvChi))
  outputLine = "CHI SQUARED "
  output(outputLine, chis, filenames)

runlog.close()
