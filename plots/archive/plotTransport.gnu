set terminal jpeg
set pm3d map
set pm3d interpolate 32, 32
set xrange [1.0e-7:18.0e-7]
set yrange [0.1e28:6.0e28]
set xtics 3.0e-7
set format x "%G"
set xlabel 'Diffusion Coefficient'
set ylabel 'Source Rate (particles/cc)'
set zlabel 'Integrated Transport Time (days)'
set cblabel 'Integrated Transport Time (days)'
set cbrange [40:120]
#set log cb
#set log x
#set log y
set title 'Transport'
set output 'transport.jpeg'
splot 'transport.dat' 
