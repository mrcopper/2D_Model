set terminal jpeg
set pm3d map
set pm3d interpolate 32, 32
set pm3d flush begin noftriangle scansforward
set xrange [1.0e-7:18.0e-7]
set yrange [0.1e28:6.0e28]
#set xtics 3.0e-7
set xtics out
set ytics out
set format x "%G"
set xlabel 'Diffusion Coefficient (1/s)'
set ylabel 'Source Rate (1/s)'
set zlabel 'Chi Squared'
set log cb
#set cbrange [0:1]
set log x
set log y
set cblabel 'Chi Squared'
set title 'Sulfur +'
set cbrange [30:500]
set output 'spChi.jpeg'
splot 'sp.dat'
set title 'Sulfur ++'
set cbrange [50:500]
set output 's2pChi.jpeg'
splot 's2p.dat'
set title 'Sulfur +++'
set cbrange [90:500]
set output 's3pChi.jpeg'
splot 's3p.dat'
set title 'Oxygen +'
set cbrange [10:150]
set output 'opChi.jpeg'
splot 'op.dat'
set title 'Oxygen ++'
set cbrange [20:200]
set output 'o2pChi.jpeg'
splot 'o2p.dat'
set title 'Electron Density'
set cbrange [10:600]
set output 'elecDens.jpeg'
splot 'elecDens.dat'
set title 'Electron Temp'
set cbrange [100:1000]
set output 'elecTempChi.jpeg'
splot 'elecTemp.dat'
set title 'Column Integrated Density'
set cbrange [100:1000]
set output 'NL2Chi.jpeg'
splot 'NL2.dat'

set title 'Total Chi Squared'
set cblabel 'Reduced Chi Squared'
set cbrange [6:50]
set output 'TotalChi.jpeg'
splot 'Tot.dat'
