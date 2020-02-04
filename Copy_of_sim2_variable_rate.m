close all; clear all; clc;
addpath(genpath('lib'));

colors = ["red"; "green"; "blue"; "cyan"];
%%
rtt = importdata('../results/clientQUIC-rtt0.data','\t');
cWnd = importdata('../results/clientQUIC-cwnd-change0.data','\t');
pacing = importdata('../results/clientQUIC-pacing-rate0.data', '\t');
bbr_state = [0 0 0; importdata('../results/clientQUIC-BBR-state0.data','\t')];
% inflight = importdata('../results/TcpVariantsComparison-inflight.data', ' ');

rtt = timeseries ([rtt(1,2); rtt(:,3)],[0; rtt(:,1)],'Name','RTT');
cWnd = timeseries ([cWnd(1,2); cWnd(:,3)],[0; cWnd(:,1)],'Name','CWND');
pacing = timeseries ([pacing(1,2); pacing(:,3)],[0; pacing(:,1)],'Name','Pacing Rate');

%%
figure;
% plot(rtt);
plot(cWnd,'.-');


%%
app_rx = importdata('../results/server-App-rx-data-1.data','\t');
[app_rx_time,~,app_rx_groups] = unique(app_rx(:,1));
app_rx_data = accumarray(app_rx_groups,app_rx(:,2));

app_rx = timeseries(cumsum(app_rx_data),app_rx_time, 'Name', 'App Rx Data');

stairs(app_rx_time, movmean(app_rx_data,[2 2],'SamplePoints',app_rx_time));

