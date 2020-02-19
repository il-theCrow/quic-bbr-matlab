close all; clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];

endtime = 30;

mean_int = @(t,x) sum( x(1:end-1).* diff(t) )/( t(end) - t(1) );

%%
rtt = importdata('../results/TcpVariantsComparison-rtt.data',' ');
cWnd = importdata('../results/TcpVariantsComparison-cwnd.data',' ');
pacing = importdata('../results/TcpVariantsComparison-pacing-rate.data', ' ');
bbr_state = [0 0; importdata('../results/TcpVariantsComparison-bbr-state.data',' ')];
inflight = importdata('../results/TcpVariantsComparison-inflight.data', ' ');
queue = importdata('../results/queue-Queue-size-2.data', '\t');

rtt = rtt(2:end,:);

[~,IcWnd,~] = unique(cWnd(:,1),'last');
cWnd = cWnd (IcWnd,:);

% [~,Ipacing,~] = unique(pacing(:,1),'last');
% pacing = pacing (Ipacing,:);

[~,Iinflight,~] = unique(inflight(:,1),'last');
inflight = inflight (Iinflight,:);

[timeQueue,~,Gqueue] = unique(queue(:,1));
queue=[timeQueue, accumarray(Gqueue,queue(:,2),[],@max)];


%%
figure(2);
pause

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
