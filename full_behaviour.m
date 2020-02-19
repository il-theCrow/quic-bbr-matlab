%close all;
clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];

endtime = 60;

mean_int = @(t,x) sum( x(1:end-1).* diff(t) )/( t(end) - t(1) );

%%
rtt = importdata('../results/clientQUIC-rtt0.data','\t');
cWnd = importdata('../results/clientQUIC-cwnd-change0.data','\t');
pacing = importdata('../results/clientQUIC-pacing-rate0.data', '\t');
bbr_state = [0 0 0; importdata('../results/clientQUIC-BBR-state0.data','\t')];
inflight = importdata('../results/clientQUIC-InFlight0.data', '\t');
queue = importdata('../results/queue-Queue-size-2.data','\t');

rtt = rtt(2:end,[1 3]);

[~,IcWnd,~] = unique(cWnd(:,1),'last');
cWnd = cWnd (IcWnd,[1 3]);

[~,Ipacing,~] = unique(pacing(:,1),'last');
pacing = pacing (Ipacing,[1 3]);

[~,Iinflight,~] = unique(inflight(:,1),'last');
inflight = inflight (Iinflight,[1 3]);

[timeQueue,~,Gqueue] = unique(queue(:,1));
queue=[timeQueue, accumarray(Gqueue,queue(:,2),[],@max)];

bbr_state = bbr_state(:,[1 3]);


%%
figure(2);

subplot(4,1,1);
stairs(inflight(:,1), inflight(:,2)*1e-3, '.-');
hold on
stairs(cWnd(:,1), cWnd(:,2)*1e-3, '.-');
ylabel('kBytes')
hold off;
title('Congestion window');


X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); 60],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);
for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end
legend('Bytes In Flight','Congestion Window');
xlim([0 endtime])

subplot(4,1,2);
stairs(pacing(:,1), pacing(:,2)*1e-6, '.-');
yline(2,'g--','BtlBw');
ylabel('Mbps');
title('Pacing Rate');

X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); 60],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);
for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end
xlim([0 endtime])

subplot(4,1,3);
stairs(rtt(:,1), rtt(:,2)*1e3, '.-');
yline(180.02,'g--','min RTT');
ylabel('ms');
title('Measured RTT');

X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); 60],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);
for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end
xlim([0 endtime])

subplot(4,1,4);
stairs(queue(:,1), queue(:,2)*1e-3, '.-');
ylabel('kBytes');
title('Bottleneck queue size');

X = [repmat(bbr_state(:,1),1,2) repmat([bbr_state(2:end,1); 60],1,2)];
Y = repmat([ylim flip(ylim)],size(bbr_state,1),1);
C = colors(bbr_state(:,2)+1);
for ii=1:numel(C)
    patch(X(ii,:),Y(ii,:),C(ii),'FaceAlpha',.25,'EdgeColor','none');
end
xlim([0 endtime])

%%
mean_queuesize = mean_int(queue(:,1),queue(:,2));

mean_rtt = mean_int(rtt(:,1),rtt(:,2));