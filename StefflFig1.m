clear all
close all
clf; 

lng=18;

species={'sp'; 's2p'; 's3p'; 'op'};
ylab={'S^+'; 'S^{++}'; 'S^{+++}'; 'O^+'};% 'T_e'; 'N_e'};
day='0230';
param='MIXR';
caseStr='UberSys4';
testCase=strcat('neutral+fehAmplify',caseStr);
plotnum=4;
rotation=36.3; %degrees per hour
time=276.5:(1/48):279.5;
long=mod((310.0+rotation*(time(:)-276.5)*24),360);
lngIndex=int8((long/(360/lng))+1);
for i=1:length(species)
    hold all;
    spec=char(species(i,:));
    plotdata(lng, plotnum, i, spec, param, day, time, testCase, lngIndex, ylab);
end
% i=i+1;
% spec='op';
% param='TEMP';
% plotdata(lng, plotnum, i, spec, param, day, time, lngIndex, ylab);
% i=i+1;
% param='DENS';
% plotdata(lng, plotnum, i, spec, param, day, time, lngIndex, ylab);
 xlabel(gca, 'Day of Year', 'fontsize', 16);
set(gca, 'xticklabel', 276.5:0.5:279.5);

opfig(strcat('MatlabPlots/variation',caseStr,'.pdf'), 5.0, 4.0, [0,1,0]);