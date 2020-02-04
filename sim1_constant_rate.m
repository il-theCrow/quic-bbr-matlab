close all; clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];
%%
rtt = importdata('../results/clientQUIC-rtt0.data','\t');
cWnd = importdata('../results/clientQUIC-cwnd-change0.data','\t');
pacing = importdata('../results/clientQUIC-pacing-rate0.data', '\t');
bbr_state = [0 0 0; importdata('../results/clientQUIC-BBR-state0.data','\t')];
app_rx = importdata('../results/server-App-rx-data-1.data','\t');
% inflight = importdata('../results/TcpVariantsComparison-inflight.data', ' ');

[~,Irtt,~] = unique(rtt(:,1),'last');
rtt = [0, rtt(1,2) ; rtt(Irtt,[1,3])];

[~,IcWnd,~] = unique(cWnd(:,1),'last');
cWnd = [0, cWnd(1,2) ; cWnd(IcWnd,[1,3])];

[~,Ipacing,~] = unique(pacing(:,1),'last');
pacing = [0, pacing(1,2) ; pacing(Ipacing,[1,3])];

% [~,Iinflight,~] = unique(inflight(:,1),'last');
% inflight = inflight (Iinflight,:);

rtt = rtt( and(rtt(:,1)>=2, rtt(:,1)<60) ,:);
cWnd = cWnd( and(cWnd(:,1)>=2, cWnd(:,1)<60) ,:);
pacing = pacing( and(pacing(:,1)>=2, pacing(:,1)<60) ,:);



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
% 
% %%
% xl=zeros(3,2);
% figure (1);
% 
% subplot(size(xl,1),1,1)
% stairs(rtt(:,1),rtt(:,2),'.-');
% yline(18e-2,':','Minimum RTT');
% ylabel('rtt [s]');
% ylim([0,1])
% xl(1,:)=xlim;
% 
% subplot(size(xl,1),1,2)
% stairs(cWnd(:,1),cWnd(:,2),'.-');
% ylabel('cWnd [bytes]');
% % set(gca, 'YScale', 'log')
% xl(2,:)=xlim;
% 
% subplot(size(xl,1),1,3)
% stairs(pacing(:,1),pacing(:,2),'.-');
% ylabel('pacing [bps]')
% xl(3,:)=xlim;
% 
% % subplot(size(xl,1),1,4)
% % stairs(inflight(:,1),inflight(:,2),'.-');
% % ylabel('inflight data [Bytes]')
% % xl(4,:)=xlim;
% 
% xl=[min(xl(:,1)) max(xl(:,2))];
% for k=1:3
%     subplot(3,1,k);
%     xlim(xl);
%     grid on;
% end

%%
[ax,hl] = plotyn(rtt(:,1),rtt(:,2).*1e3,...
                 cWnd(:,1),cWnd(:,2),...
                 pacing(:,1),pacing(:,2),...
                 {"rtt [ms]";"cWnd [bytes]";"pacing rate [bps]"});
             
% for axes = ax
%     xlim(ax, [0 60]);
% end

%% colors states
X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); max(rtt(:,1))],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,3)+1);

for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end
