function polar2compass( h )
%polar2compass changes polar plots form radian Beschriftung to compass
%Beschriftung (brute force solution)
%
% polar2compass() edits the current axes (gca)
%
% make a polar plot and use this function to change the axis label
%
% CAREFUL: the data needs still to be ploted in polar coordinates
%
%   Mathias Hauser @ UNIS
%   April 2011; v1.92

%check number of arguments
narginchk(0, 1)


%handle/ axes check (replace with axescheck ?)

% check if h is specified
% use get(gcf,...) in order to not create an Axes object if none exists
% if exist('h','var');
%     if ishandle(h)
%         if strcmp(get(h,'Type'), 'axes')
%         else
%             error('polar2compass:HandleNotAxes','The handle is no axes object.');
%         end
%     else
%         error('polar2compass:hNotAHandle','The specified input is not a handle')
%     end
% else
%     fig = get(0,'CurrentFigure');
%     if isempty(fig)
%         error('polar2compass:noFigExists','There is no figure.')
%     end
%     h = get(gcf,'CurrentAxes');
%     if isempty(h)
%     error('polar2compass:noAxesExist','There is no axes object.')
%     end
% end

if exist('h','var');
    if isempty(axescheck(h))
        error('polar2compass:HandleNotAxes','The handle is no axes object.');
    end
else
    fig = get(0,'CurrentFigure');
    if isempty(fig)
        error('polar2compass:noFigExists','There is no figure.')
    end
    h = get(gcf,'CurrentAxes');
    if isempty(h)
        error('polar2compass:noAxesExist','There is no axes object.')
    end
end




a = findall(h); %find all objects
b = a(strcmp(get(a,'type'),'text')); %find all text objects



%find the distance of all text objects (to the origin)
pos = ones(length(b),3);
for ii = 1:length(b)
    pos(ii,:) = get(b(ii), 'position');
end
dist = sqrt(pos(:,1).^2 + pos(:,2).^2);
%assume that the one which has the same distace most often is the right one
mDist = mode(dist);
%find these (including some tolerance for numerical errors)
c = b(dist-.1 <= mDist & dist+.1 >= mDist);


if isempty(c)
    error('polar2compass:notPolar','Not a polar plot.')
end

% get its string argument (to double check)
for ii = 1:length(c)
    st = str2double(get(c(ii),'String'));
    
    if mod(st,30) == 0
        if st == 90
            set(c(ii),'String','360°/0°');
        else
            set(c(ii),'String',[num2str(mod(90 - st,360)) '°']);
        end
    end
end


% get its string argument
% for ii = 1:length(b)
%     st = str2double(get(b(ii),'String'));
%
%     if mod(st,30) == 0
%        if st == 90
%            set(b(ii),'String','360°/0°');
%        else
%        set(b(ii),'String',[num2str(mod(90 - st,360)) '°']);
%        end
%     end
%
% end



end

