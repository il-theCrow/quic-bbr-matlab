close all; clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];
%%
rtt = importdata('../../results/1/clientQUIC-rtt0.data','\t');
cWnd = importdata('../../results/1/clientQUIC-cwnd-change0.data','\t');
pacing = importdata('../../results/1/clientQUIC-pacing-rate0.data', '\t');
bbr_state = [0 0 0; importdata('../../results/1/clientQUIC-BBR-state0.data','\t')];
rx = importdata('../../results/1/serverQUIC-rx-data1.data','\t');

[~,Irtt,~] = unique(rtt(:,1),'last');
rtt = [0, rtt(1,2) ; rtt(Irtt,[1,3])];

[~,IcWnd,~] = unique(cWnd(:,1),'last');
cWnd = [0, cWnd(1,2) ; cWnd(IcWnd,[1,3])];

[~,Ipacing,~] = unique(pacing(:,1),'last');
pacing = [0, pacing(1,2) ; pacing(Ipacing,[1,3])];

rx = [rx(:,1), cumsum(rx(:,2))];

rtt = rtt( rtt(:,1)>=2 ,:);
cWnd = cWnd( cWnd(:,1)>=2 ,:);
pacing = pacing( pacing(:,1)>=2 ,:);



% figure;
% hold on;
% yyaxis left
% plot(rtt(:,1),rtt(:,2),'.-');
% yline(180e-3,':','Minimum RTT');
% ylabel('rtt [s]')
% yyaxis right
% % stairs(cWnd(:,1),cWnd(:,2),'.-');
% % ylabel('cWnd [bytes]');
% % yyaxis right
% stairs(pacing(:,1),pacing(:,2),'.-');
% ylabel('pacing [bps]')
% yline(2e6,'r--','Bottleneck Bandwidth');
% xlim([0 60]);

%%
figure (1);

subplot(2,2,1)
stairs(rtt(:,1),rtt(:,2),'.-');
yline(18e-2,':','Minimum RTT');
ylabel('rtt [s]');
ylim([0,1])
xlim([0 60]);

subplot(2,2,2)
stairs(cWnd(:,1),cWnd(:,2),'.-');
ylabel('cWnd [bytes]');
% set(gca, 'YScale', 'log')
xlim([0 60]);

subplot(2,2,3)
stairs(pacing(:,1),pacing(:,2),'.-');
ylabel('pacing [bps]')
xlim([0 60]);

subplot(2,2,4)
stairs(rx(:,1),rx(:,2),'.-');
ylabel('received data [Bytes]')
xlim([0 60]);


%% colors states
X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); max(rtt(:,1))],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,3)+1);

for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end
