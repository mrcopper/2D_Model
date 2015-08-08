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

def Transport(path, dll0, s):
  dayint=int(sys.argv[1])

  zeroes=int(3 - math.floor(math.log10(dayint)))

  for i in range(0, zeroes):
    day="0"+str(dayint)

  target=path+"/elec/NL2_/NL2_elec"+str(day)+"rad.dat"
#  if( not os.path.isfile(target)): return 0
  while( not os.path.isfile(target)):
    dayint=dayint-1
    for i in range(0, zeroes):
      day="0"+str(dayint)
    target=path+"/elec/NL2_/NL2_elec"+str(day)+"rad.dat"
    if( dayint == 0 ): return 0

  infile = open(target, "r")

  inputs=open(path+"/inputs.dat", "r")

  for i in range(1, 10):
    line=inputs.readline()
  #print path+"/inputs.dat", line
  [dll0, junk]=line.split(" ", 1)

  dll0=float(dll0)

#print dll0

  line=inputs.readline()
#  [dlla, junk]=line.split(" ", 1)
  dlla=float(line)
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
  
  ttot=[0.0]
  for i in range(1, len(narray)):
    tot=0.0
    for j in range(i):
      tot=tot+transport[j]*(rarray[j+1]-rarray[j])
    ttot.append(tot)
  
  outputs=open("transport.dat", "a")
  #for i in range(len(rarray)):
  outputs.write(str(dll0)+" " + str(s) + "e28 " + str(ttot[15]) + '\n')
  outputs.close()

#print '\n',transport
#print '\n',rarray
#print '\n',ttot
  Transport(run, dll[i], s[j])
  out=open("transport.dat", "a")
  out.write('\n')  
  out.close()

os.popen("gnuplot plotTransport.gnu")
