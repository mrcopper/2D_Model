clear all
close all
clf;

datafolder = dir('/home/mrcopper/Desktop/Project/2D_Model/plots/data/sp/DENS/*_3D.dat');
%datafolder = dir('/home/mrcopper/Desktop/Project/2D_Model/MIXRsp*_3D.dat');
%datafolder = dir('/home/mrcopper/Desktop/Project/2DResolutionTesting/4c/plots/data/sp/MIXR/*_3D.dat');

lng=18;
rad=18;

len=length(datafolder);

for day =1:len
    days(day)=day-1;
    data=load(datafolder(day).name);
    for ring=1:rad
       amp(day,ring)=0.5*(max(data((lng+1)*(ring-1)+1:(lng+1)*ring,2))-min(data((lng+1)*(ring-1)+1:(lng+1)*ring,2)))/mean(data((lng+1)*(ring-1)+1:(lng+1)*ring,2)); 
    end
end

ampmax=max(max(amp(:,:)));

for ring=1:rad
    hold all;
    radius(ring)=data((ring-1)*(lng+1)+1,3);
%    ax(ring)=subplot(ceil(rad/2),2,ring);
    if ring<=rad/2
      ax(ring)=subplot(ceil(rad/2),2,(ring*2)-1);
    end
    if ring>rad/2
        ax(ring)=subplot(ceil(rad/2),2,ring*2-floor(rad/2)*2);
    end
    plot(ax(ring),days,amp(:,ring));
    title(ax(ring),strcat('Radius = ', num2str(radius(ring)) , ' Rj'));  
    xlim([0 len-1]);
    set(ax(ring), 'ylim', [0 ampmax]); %ceil(ampmax*10)/10]);
    ylabel(ax(ring), 'Amp');
end
xlabel(ax(rad), 'Time in Days')