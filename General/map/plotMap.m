function plotMap(figNum, nameNum)
%plotMap plots a Map of the northern hemisphere viewed from the north pole
%   plotMap(figNum) creates a new figure window with the number figNum
%   if figNum is ommited, it will be plotted in figure 1

%set figNum 1 if none is given
if ~exist('figNum','var'); figNum=1; end
if ~exist('nameNum','var'); nameNum=figNum; end

%either creates the figure(figNum) or makes ist the active figure
figure(figNum);

%it could be that the figure is an 'ordinary' plot
if ismap(gca) && strcmp(getm(gca,'MapProjection'),'stereo');
    coast = load('coast');
    hold off
    h=plotm(coast.lat,coast.long,'Tag','WorldMap');
    set(h,'color',[.5 .5 .5]);
    hold on
    return
elseif isempty(get(gcf,'Children')) %if the figure exists but has no axes
else
    %close the plot if it is an ordinary plot
    close(figNum);
    %create a new figure
    figure(figNum);
end

%name it
set(figNum,'Name',['Map ' num2str(nameNum)]);
%load the coast
coast = load('coast');
set(figNum,'units','normalized','position',[0 0 1 1]);
% set the details for the projection
latlim = [30 90];  lonlim = [-180 180];
axesm('MapProjection','stereo','origin',[90 0],'FLatLimit',latlim,'FLonLimit',lonlim);

% plot the coastlines
h=plotm(coast.lat,coast.long,'Tag','WorldMap');
set(h,'color',[.5 .5 .5]);
axis([-1.2 1.2 -1.2 1.2]);


%gridm
g = gridm('on');
%must be set so the grid doesent extend the axis frame
set(g,'Clipping','on');

end
