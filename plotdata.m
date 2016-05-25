function plotdata(lng, plotnum, i, spec, param, day, time, testCase, lngIndex, ylab)
    file = strcat('/home/mrcopper/Desktop/Project/2D_Model/PaperRuns/',testCase,'/plots/data/',spec,'/',param,'/',param,spec,day,'_1D.dat');
    data=load(file);
    average=mean(data(1:lng,2));
    ax(i)=subplot(plotnum,1,i);
    height=(0.75/plotnum);
    bottom=0.9-(height*i);
    set(ax(i), 'pos', [0.125 bottom 0.825 height]);
    plot(ax(i), time, data(lngIndex(:),2)/average, 'linewidth', 1.15);
    set(gca, 'xlim', [276.5 279.5]); 
    set(gca, 'xtick', 276.5:0.5:279.5);
    set(gca, 'xminortick', 'on');
    set(gca, 'xticklabel', {});
    set(gca, 'ylim', [0.8, 1.2]);
    set(gca, 'ytick', 0.9:0.1:1.1);
    set(gca, 'ygrid', 'on');
    ylabel(gca, char(ylab(i,:)), 'fontsize', 16);
    if i==1
        title(gca, 'Relative Variation of Mixing Ratios', 'fontsize', 18);
    end
end
