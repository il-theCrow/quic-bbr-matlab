close all; clear all; clc;

%%
rtt0 = importdata('../results/clientQUIC-rtt0.data','\t');
pacing0 = importdata('../results/clientQUIC-pacing-rate0.data', '\t');

[~,Irtt,~] = unique(rtt0(:,1),'last');
rtt0 = [0, rtt0(1,2) ; rtt0(Irtt,[1,3])];
[~,Ipacing,~] = unique(pacing0(:,1),'last');
pacing0 = pacing0 (Ipacing,[1 3]);

rtt1 = importdata('../results/clientQUIC-rtt1.data','\t');
pacing1 = importdata('../results/clientQUIC-pacing-rate1.data', '\t');

[~,Irtt,~] = unique(rtt1(:,1),'last');
rtt1 = [0, rtt1(1,2) ; rtt1(Irtt,[1,3])];
[~,Ipacing,~] = unique(pacing1(:,1),'last');
pacing1 = pacing1 (Ipacing,[1 3]);

clear Ipacing Irtt

%% increasing btl bw
figure(1);
yyaxis left
stairs(rtt0(:,1),rtt0(:,2)*1e3,'b.-')
hold on;
stairs(rtt1(:,1),rtt1(:,2)*1e3,'g.-');
hold off;
ylabel('rtt [ms]');

yyaxis right
stairs(pacing0(:,1),pacing0(:,2)*1e-6,'r.-');
hold on;
stairs(pacing1(:,1),pacing1(:,2)*1e-6,'m.-');
hold off;
ylabel('pacing rate [Mbps]');

xline(17,'k:','second flow starts');
legend('flow 1 - rtt','flow 2 - rtt','flow 1 - pacing','flow 2 - pacing');

xlim([15 30]);
