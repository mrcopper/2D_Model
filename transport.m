%calculate transport time

function getTransport()
rad=18;
lng=18;
dll0=1.5e-6;
dlla=4.5;
% nl2folder = dir('/home/mrcopper/Desktop/Project/2D_Model/plots/data/elec/NL2_/*_3D.dat');
% loadfolder = dir('/home/mrcopper/Desktop/Project/2D_Model/plots/data/LOAD/*_3D.dat');
% massfolder = dir('/home/mrcopper/Desktop/Project/2D_Model/plots/data/MOUT/*_3D.dat');

nl2folder = dir('/home/mrcopper/Desktop/Project/2D_Model/PaperRuns/neutral+fehAmplify1/plots/data/elec/NL2_/*_3D.dat');
loadfolder = dir('/home/mrcopper/Desktop/Project/2D_Model/PaperRuns/neutral+fehAmplify1/plots/data/LOAD/*_3D.dat');
massfolder = dir('/home/mrcopper/Desktop/Project/2D_Model/PaperRuns/neutral+fehAmplify1/plots/data/MOUT/*_3D.dat');

len=length(nl2folder);

for day=1:len
    NL2=load(nl2folder(day).name);
    loading=load(loadfolder(day).name);
    mass=load(massfolder(day).name);
    mass=mean(radify(mass,lng,rad));
    loading=mean(radify(loading,lng,rad));
    NL2radial=radify(NL2, lng, rad);
    radius=getrad(NL2, lng, rad);
    dll=getdll(dll0, dlla, radius);
    for i=1:lng
        transport(day,i,:)=transportTime(NL2radial(i,:), radius, dll);
        lngtransport(i)=sum(mean(transport(:,i,:)));
    end
    massTime(day,:)=(mass(1,:)./loading(1,:))/86400.0;
    lngtransport(lng+1)=lngtransport(1);
    avetransport(day)=sum(mean(transport(day,:,:)));
end
figure(1)
plot(0:len-1, avetransport(:), 'linewidth', 1.5)
xlim([100 400]);
title('Temporal Variation of Radial Transport', 'fontsize', 18);
ylabel('Transport Time Scale (days)', 'fontsize', 15);
xlabel('Time in Days', 'fontsize', 15);
opfig('TransportTime.pdf', 7.5, 4.5, [0,1,0]);

figure(2)
plot(linspace(0,360,lng+1), lngtransport(:), 'linewidth', 1.5)
title('Azimuthal Variation of Radial Transport', 'fontsize', 18);
ylabel('Transport Time Scale (days)', 'fontsize', 15);
xlabel('System 3 Longitude', 'fontsize', 15);
xlim([0 360]);
set(gca, 'XTick', 0:30:360)
opfig('longTransport.pdf', 7.5, 4.5, [0,1,0]);

figure(3)
radTransport=mean(mean(transport));
radtot=0;
integratedRadTransport(1)=0.0;
for i=1:rad-1
    radtot=radtot+radTransport(i);
    integratedRadTransport(i+1)=radtot;
end
plot(linspace(radius(1), radius(rad), rad), integratedRadTransport(:), 'linewidth', 1.5);
title('Radial Variation of Radial Transport', 'fontsize', 18);
ylabel('Integrated Transport Time (days)', 'fontsize', 15);
xlabel('Radius (R_J)', 'fontsize', 15);
xlim([radius(1) radius(rad)]);
opfig('radialTransport.pdf', 7.5, 4.5, [0,1,0]);

figure(4)
meanmassTime=mean(massTime(2:len,:));
%radTransport(:)'
semilogy(linspace(radius(1), radius(rad-1), rad-1), meanmassTime(1:rad-1)'./radTransport(:), 'linewidth', 1.5);
%plot(linspace(radius(1), radius(rad-1), rad-1), meanmassTime(1:rad-1)'./radTransport(:), 'linewidth', 1.5);
title('Chemical and Physical Transport Timescales', 'fontsize', 18);
ylabel('Ratio of Chemical/Transport Timescales', 'fontsize', 15);
xlabel('Radius (R_J)', 'fontsize', 15);
xlim([radius(1) 8]);
ylim([0.1 100]);
opfig('timeRatio.pdf', 7.5, 4.5, [0,1,0]);

end

function T=transportTime(nl2,r,dll)
rad=length(r);
 for i=1:rad
     if i<rad
         stuff(i)=(dll(i)/(r(i)*r(i)))*((nl2(i+1)-nl2(i))/(r(i+1)-r(i)));
     end
     if i<rad
         T(i)=-(nl2(i)/(r(i)*r(i)))*(r(i+1)-r(i))/(stuff(i)*86400.0);
     end
 end
end

function radial=radify(data,lng, rad)
for i=1:lng
    for j=1:rad
        radial(i,j)=data((lng+1)*(j-1)+i,2);
    end
end
end

function radarr=getrad(data,lng, rad)
for i=1:rad
    radarr(i)=data((i-1)*(lng+1)+1,3);
end
end

function dllarr=getdll(dll0, dlla, radius)
for i=1:length(radius)
    dllarr(i)=dll0*((radius(i)/6.0)^dlla);
end
end