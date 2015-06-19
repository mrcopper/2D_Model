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
#[dlla, junk]=line.split(" ", 1)
dlla=float(line)
#print dlla

rarray=[]
narray=[]
for line in infile:
  [rdist, nl2]=line.split()
  rarray.append(float(rdist))
  narray.append(float(nl2))

infile.close()

dr=rarray[2]-rarray[1]
dll=[]
for r in rarray:
  dllAve=dll0*((r/6.0)**dlla)*(((1.0+(dr/r))**(dlla+1.0))-1.0)*(r/dr)*(1.0/(dlla+1.0))
  dll.append(dllAve)

#print rarray
#print narray
#print dll
stuff=[]
for i in range(0,len(rarray)-1):
  stuff.append(dll[i]*((narray[i+1]-narray[i])/dr)/(rarray[i]**2))


#print stuff

transport=[]

#print narray
#print ntot

for i in range(0,len(rarray)-1):
  transport.append((-1.0*narray[i]*dr/(rarray[i]**2))/(86400.0*stuff[i]))

ttot=[0.0]
for i in range(1, len(narray)-1):
  tot=0.0
  for j in range(i):
    tot=tot+transport[j]
  ttot.append(tot)

outputs=open("transport.dat", "w")
for i in range(len(rarray)-1):
  outputs.write(str(rarray[i]) + '\t' + str(ttot[i]) + '\n')
outputs.close()

outputs=open("nl2Transport.dat", "w")
for i in range(len(rarray)-1):
  outputs.write(str(rarray[i]) + '\t' + str(narray[i]) + '\n')
outputs.close()
#print '\n',transport
#print '\n',rarray
#print '\n',ttot

