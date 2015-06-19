#!/bin/bash

cd ./data/

rm -r sp/
rm -r s2p/
rm -r s3p/
rm -r op/
rm -r o2p/
rm -r elec/
rm -r LOAD/
#rm -r OXGN/
#rm -r SLFR/

#mkdir OXGN
#mkdir SLFR
mkdir LOAD
good=$?
if [ $good -ne 0 ]
  then
  echo "LOAD folder already exists. Please remove or change name to procede." 
fi

mv LOAD*.dat LOAD/.
#mv OXGN*.dat OXGN/.
#mv SLFR*.dat SLFR/.

cd ..
./organizeSpecies.sh sp
./organizeSpecies.sh s2p
./organizeSpecies.sh s3p
./organizeSpecies.sh op
./organizeSpecies.sh o2p
./organizeSpecies.sh elec
