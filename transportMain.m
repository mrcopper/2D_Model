rad=8;
lng=12;

nl2folder = dir('/home/mrcopper/Desktop/Project/2D_Model/plots/data/elec/NL2_/*_3D.dat');

len=length(nl2folder);

for day=1:len
    NL2=load(nl2folder(day).name);
    NL2radial=radify(NL2);
end
