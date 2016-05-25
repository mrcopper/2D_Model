clear all
close all
%format long
%datafoldersp = dir('/home/khan/2D_Model-master/plots/data/sp/MIXR/MIXRsp*_3D.dat');
datafoldersp = dir('/home/mrcopper/Desktop/Project/2D_Model/PaperRuns/neutral+fehAmplify/plots/data/sp/MIXR/*_3D.dat');
%datafoldersp = dir('/home/mrcopper/Desktop/Project/2D_Model/MIXRsp*_3D.dat');
%datafoldersp = dir('/home/mrcopper/Public/data2_0kms/sp/MIXR/*_3D.dat');
%datafoldersp = dir('/home/khan113/runs/20x16_steady_subco_vion_1/2D_Model/plots/data/sp/MIXR/*_3D.dat');
%datafoldersp = dir('/home/mrcopper/Public/data2_0kms/sp/MIXR/*_3D.dat');
lng = 18;
rad = 18;
radial_max_data = zeros(rad,3);
writerObj = VideoWriter('/home/mrcopper/ratio_map_1.avi');
writerObj.FrameRate = 10;
open(writerObj);
for day = 1:length(datafoldersp)
    v = -lng;
    b = 0;
    %g = -7;
    %h = 0;
    data = load(datafoldersp(day).name);
   for i = 1:rad;
       v = v + lng + 1;
       b = b + lng + 1;
       radial_bin = data(v:b,:);
       first = radial_bin(1,2);
       last = radial_bin(9,2);
       if max(radial_bin(:,2)) == first && last
           radial_max = radial_bin(1,2);
           radial_max_row = 1;
       else
            radial_max = max(radial_bin(:,2));
            radial_max_row = find(radial_bin(:,2) == radial_max);
       end
       if size(radial_max_row) >= [2, 1]
               radial_max_row = radial_max_row(1,1);
       end
       radial_max_data(i,:) = radial_bin(radial_max_row,:);
   end
    theta = data(:,1)*(pi/180);
    ratio = data(:,2);
    radius = data(:,3);
    dimension = size(theta);
    radial_dimension = dimension(1,1)/2;
   % x = radius*cos(theta);
   % y = radius*sin(theta);
    [x,y,c] = pol2cart(theta, radius, ratio);
    X = reshape(x,radial_dimension,2);
    Y = reshape(y,radial_dimension,2);
    C = reshape(c,radial_dimension,2);
    max_value = max(data(:,2));
    max_row = find(data(:,2) == max_value);
    max_data = data(max_row,:);
    clf
    pcolor(X,Y,C);
    set(gca,'YDir', 'reverse') 
    shading interp
    colormap(jet(300));
    colorbar
    caxis([0 0.1])
    hold on
    h = polar((radial_max_data(:,1)*(pi/180)),radial_max_data(:,3), '.');
    set(h,'markersize', 25);
    set(h, 'color', 'm');
    daylabel = strcat('Day');
    TeXString = texlabel(daylabel);
    text(-1,0,TeXString);
    daynumlabel = num2str(day-1);
    TeXString_num = texlabel(daynumlabel);
    text(0.5,0,TeXString_num)
    frame = getframe;
    drawnow
    writeVideo(writerObj, frame);
    hold off
end
close(writerObj);