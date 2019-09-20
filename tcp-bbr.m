close all; clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];
%%
rtt = importdata('../results/TcpVariantsComparison-rtt.data',' ');
cWnd = importdata('../results/TcpVariantsComparison-cwnd.data',' ');
pacing = importdata('../results/TcpVariantsComparison-pacing-rate.data', ' ');
% bbr_state = [0 0; importdata('../results/TcpVariantsComparison-bbr-state.data',' ')];
inflight = importdata('../results/TcpVariantsComparison-inflight.data', ' ');

[~,Irtt,~] = unique(rtt(:,1),'last');
rtt = rtt (Irtt,:);

[~,IcWnd,~] = unique(cWnd(:,1),'last');
cWnd = cWnd (IcWnd,:);

[~,Ipacing,~] = unique(pacing(:,1),'last');
pacing = pacing (Ipacing,:);

[~,Iinflight,~] = unique(inflight(:,1),'last');
inflight = inflight (Iinflight,:);

%%
figure;
hold on;
yyaxis left
% plot(rtt(:,1),rtt(:,2),'.-');
% yline(9.004e-2,':','Minimum RTT');
% ylabel('rtt [s]')
% yyaxis right
stairs(cWnd(:,1),cWnd(:,2),'.-');
ylabel('cWnd [bytes]');
yyaxis right
stairs(pacing(:,1),pacing(:,2),'.-');
ylabel('pacing [bps]')
hold off;
%xlim([0 100]);

%%
xl=zeros(4,2);
figure (1);

subplot(4,1,1)
stairs(rtt(:,1),rtt(:,2),'.-');
yline(9.004e-2,':','Minimum RTT');
ylabel('rtt [s]')
xl(1,:)=xlim;

subplot(4,1,2)
stairs(cWnd(:,1),cWnd(:,2),'.-');
ylabel('cWnd [bytes]');
set(gca, 'YScale', 'log')
xl(2,:)=xlim;

subplot(4,1,3)
stairs(pacing(:,1),pacing(:,2),'.-');
ylabel('pacing [bps]')
xl(3,:)=xlim;

subplot(4,1,4)
stairs(inflight(:,1),inflight(:,2),'.-');
ylabel('inflight data [Bytes]')
xl(4,:)=xlim;

xl=[min(xl(:,1)) max(xl(:,2))];
for k=1:4
    subplot(4,1,k);
    xlim(xl);
    grid on;
end

%%
plotyn(rtt(:,1),rtt(:,2).*1e3,...
    cWnd(:,1),cWnd(:,2),...
    pacing(:,1),pacing(:,2),...
    {"rtt [ms]","cWnd [bytes]","pacing rate [bps]"});

%%
X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); max(rtt(:,1))],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);

for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end

%%
figure;
stairs(pacing(:,1),pacing(:,2),'.-');
ylabel('pacing [bps]')
xlim([0 100]);
