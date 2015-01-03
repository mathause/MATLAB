function plotWorld_2( figNum, nameNum )
%plotWorld plots a Map of the entire world (miller projection)
%   plotMap(figNum, nameNum) creates a new figure window with the number figNum
%   if figNum is ommited, it will be plotted in figure 1
%   if nameNum is ommited it well be set to the figNum
%
%   Mathias Hauser @ IAC/ETHZ
%   Jun 2010


%set figNum 1 if none is given
if ~exist('figNum','var'); figNum=1; end
if ~exist('nameNum','var'); nameNum=figNum; end
%define the projection style
proj = 'miller';
%either creates the figure(figNum) or makes it the active figure
figure(figNum);


%it could be that the figure is an 'ordinary' plot
if ismap(gca)  && strcmp(getm(gca,'MapProjection'),proj);
    coast = load('coast','-mat','lat','long');
    hold off
    h=plotm(coast.lat,coast.long,'Tag','WorldMap');
    set(h,'color',[.5 .5 .5]);
    hold on
    %name it
    set(figNum,'Name',['Map ' num2str(nameNum)]);
    return
elseif isempty(get(gcf,'Children')) %if the figure exists but has no axes
    %continiue below
else
    %close the plot if it is an ordinary plot
    close(figNum);
    %create a new figure
    figure(figNum);
end

%name it
set(figNum,'Name',['Map ' num2str(nameNum)]);
%load the coast
coast = load('coast','-mat','lat','long');
%set(figNum,'units','normalized','position',[0 0 1 1]);
% set the details for the projection
latlim = [-86 86];  lonlim = [-180 180];
axesm('MapProjection',proj,'FLatLimit',latlim,'FLonLimit',lonlim);

%,'origin',[90 0],

% plot the coastlines
h=plotm(coast.lat,coast.long,'Tag','WorldMap');
set(h,'color',[.5 .5 .5]);
axis([-3.2 3.2 -2.15 2.15]);

plotm(ones(1,361)*86,0:360,':k');
plotm(-ones(1,361)*86,0:360,'k:');

%gridm
% g = gridm('on');
%must be set so the grid doesent extend the axis frame
% set(g,'Clipping','on');

end

