close all; clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];
%%
rtt = importdata('../results/clientQUIC-rtt0.data','\t');
pacing = importdata('../results/clientQUIC-pacing-rate0.data', '\t');
bbr_state = [0 0 0; importdata('../results/clientQUIC-BBR-state0.data','\t')];

[~,Irtt,~] = unique(rtt(:,1),'last');
rtt = [0, rtt(1,2) ; rtt(Irtt,[1,3])];
[~,Ipacing,~] = unique(pacing(:,1),'last');
pacing = pacing (Ipacing,[1 3]);
bbr_state = bbr_state(:,[1 3]);

clear Ipacing Irtt

%% increasing btl bw
figure(1);
yyaxis left
stairs(rtt(:,1),rtt(:,2)*1e3,'.-');
ylabel('rtt [ms]');

yyaxis right
stairs(pacing(:,1),pacing(:,2)*1e-6,'.-');
hold on;
stairs([0 20 40 60],[2 4 2 2],'g-.');
hold off;
ylabel('pacing rate [Mbps]');

X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); 60],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);
for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end

legend('round-trip time','pacing rate','bottleneck rate');

title('Increasing bottleneck rate');
xlim([12,26]);

%% decreasing btl bw
figure(2);
yyaxis left
stairs(rtt(:,1),rtt(:,2)*1e3,'.-');
ylabel('rtt [ms]');

yyaxis right
stairs(pacing(:,1),pacing(:,2)*1e-6,'.-');
hold on;
stairs([0 20 40 60],[2 4 2 2],'g-.');
hold off;
ylabel('pacing rate [Mbps]');

X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); 60],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);
for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end

legend('round-trip time','pacing rate','bottleneck rate');

title('Decreasing bottleneck rate');
xlim([35,55]);
