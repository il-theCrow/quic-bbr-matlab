function [ax,hlines] = plotyn(varargin)
%
% Syntax:   [ax,hlines] = plotyn(x1,y1,...,xn,yn,ylabels)
%
% Inputs:   x1,y1 are the xdata and ydata for the first axes' line
%           ........
%           xn,yn are the xdata and ydata for the n'th axes' line
%           ylabels is a 4x1 cell array containing the ylabel strings (optional)
%
% Outputs:  ax -        nx1 double array containing the axes' handles
%           hlines -    nx1 double array containing the lines' handles
%
% Example:
%           x = 0:10;
%           y1=x;  y2=x.^2;  y3=x.^3;  y4=x.^4;
%           ylabels{1} = 'First y-label';
%           ylabels{2} = 'Second y-label';
%           ylabels{3} = 'Third y-label';
%           ylabels{4} = 'Fourth y-label';
%           [ax,hlines] = plotyn(x,y1,x,y2,x,y3,x,y4,ylabels);
%           leghandle = legend(hlines, 'y = x','y = x^2','y = x^3','y = x^4',2);
%
% See also Plot, Plotyy

% Based on plotyyy.m (available at www.matlabcentral.com) by :
% Denis Gilbert, Ph.D.
%% preset
colorY=['k','r','b','c','m','g','y']; %['black','red','blue','cyan','green','magenta','yellow'];
datanum=(nargin-rem(nargin,2))/2;

%% Check inputs

if (nargin < 2)
   error('floatAxis requires a minimum of three parameters')
elseif (rem(nargin,2)==1)
   ylabels=varargin{nargin};
end
%%data trans
for i=1:datanum
   data(i).x = varargin{i*2-1};
   data(i).y = varargin{i*2};
end

%% Create figure window
figure('units','normalized',...
       'DefaultAxesXMinorTick','on','DefaultAxesYminorTick','on');

%% get handle draw first plot
hlines(1)=plot(data(1).x,data(1).y,'k');
ax(1) = get(gcf,'Children');
pos = get(ax(1),'position');
cfig = get(gcf,'color');

offset=0.07;
startX=offset*datanum;
pos = [startX 0.1 0.95-startX 0.8];

set(ax(1),'position',pos);
limx1 = get(ax(1),'xlim');

%% draw remain plot
for i=2:datanum
    poss=[pos(1)-offset*(i-1) pos(2) pos(3)+offset*(i-1) pos(4)];
    scale = poss(3)/pos(3);
    limxs = [limx1(2)-scale*(limx1(2)-limx1(1)) limx1(2)];
    ax(i)=axes('Position',poss,'box','off',...
        'Color','none','XColor',cfig,'YColor',colorY(i),...
        'xtick',[],'xlim',limxs,'yaxislocation','left');
    hlines(i) = line(data(i).x,data(i).y,'Color',colorY(i),'Parent',ax(i));
end

%% Put ax(2) on top;
% axes(ax(2));

%% Set y-labels;
if (rem(nargin,2)==1)
    Ylab = get(ax,{"ylabel"});
    set([Ylab{:}],{"String"},{ylabels{:}}');
end
