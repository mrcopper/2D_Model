import os 
import sys
import math

#def calcTrans(path):
#  infile = open(path, "r")
#  outfile
#
#for file in os.listdir("./"):
#  if file.endswith("rad.dat") and file.startswith("NL2_elec"):
#    path=os.getcwd() +"/"+file
#    calcTrans(path)

day=int(sys.argv[1])

zeroes=int(3 - math.floor(math.log10(day)))

for i in range(0, zeroes):
  day="0"+str(day)

target="/home/mrcopper/Desktop/Project/2D_Model/plots/data/elec/NL2_/NL2_elec"+str(day)+"rad.dat"

#print target

infile = open(target, "r")

inputs=open("/home/mrcopper/Desktop/Project/2D_Model/inputs.dat", "r")

for i in range(1, 10):
  line=inputs.readline()

#[dll0, junk]=line.split(" ", 1)
dll0=float(line)

#print dll0

line=inputs.readline()
[dlla, junk]=line.split(" ", 1)
dlla=float(dlla)
#print dlla

rarray=[]
narray=[]
for line in infile:
  [rdist, nl2]=line.split()
  rarray.append(float(rdist))
  narray.append(float(nl2))

infile.close()

dll=[]
for r in rarray:
  dll.append(dll0*(r/6.0)**dlla)

dr=rarray[2]-rarray[1]
#print rarray
#print narray
#print dll

stuff=[1.0e30]
for i in range(1,len(rarray)):
  stuff.append(dll[i]*((narray[i]-narray[i-1])/dr)/(rarray[i]**2))

stuff[0]=stuff[1]

#print stuff

transport=[]

ntot=[]
for i in range(0, len(narray)):
  tot=0.0
  for j in range(i):
    tot=tot+(narray[j]/rarray[j]**2)*dr
  ntot.append(tot)

#print narray
#print ntot

for i in range(0,len(rarray)):
  transport.append(-1.0*narray[i]/(rarray[i]**2)/86400.0/stuff[i])

ttot=[]
for i in range(0, len(narray)):
  tot=0.0
  for j in range(i):
    tot=tot+transport[j]*(rarray[j+1]-rarray[j])
  ttot.append(tot)

outputs=open("transport.dat", "w")
for i in range(len(rarray)):
  outputs.write(str(rarray[i]) + '\t' + str(ttot[i]) + '\n')
outputs.close()

#print '\n',transport
#print '\n',rarray
#print '\n',ttot

