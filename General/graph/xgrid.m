function xgrid(varargin)
%XGRID replace the standard grid by a thin gray line
%
%Syntax
%   XGRID
%   XGRID on
%   XGRID off
%   XGRID x
%   XGRID y
%   XGRID(axes_handle, ...)
%
%Usage
%   XGRID    replace the standard grid by a thin gray line
%   XGRID on    same as XGRID
%   XGRID off    remove the grid
%   XGRID x    only draw grid lines on x-axis
%   XGRID y    only draw grid lines on y-axis
%   XGRID(axes_handle, ...)    draw 
%
%Example
%   XGRID
%
%   plot(rand(1,10));
%   XGRID y
%
%See
%   http://www.mathworks.ch/support/solutions/en/data/1-1PAYMC/?solution=1-1PAYMC
%
%Caveat/To do
%   Does not update when the plot is resized.
%   Does not work well when the x/y limits are set automatically (as the
%       new grid lines are used in the calculation of the limits)
%
%Version History
%   Mathias Hauser@MeteoSwiss 2013
%
%See Also
%   grid | xlim | xlim | axis -> xlimmode


%   XGRID minor
%   XGRID xminor
%   XGRID yminor

[AX,ARGS,NARGS] = axescheck(varargin{:});

if isempty(AX)
    AX = gca;
end


%default settings
is_off = false;
%is_minor = false;
is_x = true;
is_y = true;

if NARGS > 0
    is_off = strcmpi(ARGS{1}, 'off');

%     if ~isempty(strfind(ARGS{1}, 'minor'))
%         is_minor = true;
%     end
    
    
    %do not plot x grid if y is wanted (and vice versa)
    is_x = ~strcmpi(ARGS{1}(1), 'y');
    is_y = ~strcmpi(ARGS{1}(1), 'x');
end



%use the Tag as indicator if the plot was 'xgridded'
h_xgrid = findobj(get(AX, 'Children'), 'Tag', 'xgrid');
delete(h_xgrid);

if is_off
    return
end


is_hold = ishold;
hold(AX,'on')

% XLimMode = get(AX, 'XLimMode');
% YLimMode = get(AX, 'YLimMode');
% 
% set(AX, 'XLimMode', 'manual');
% set(AX, 'YLimMode', 'manual');

hg = hggroup('Parent', AX, 'Tag','xgrid');


grid(AX, 'on')

% Obtain the tick mark locations
xtick = get(AX,'XTick');
% Obtain the limits of the y axis
ylim = get(AX,'Ylim');
% Obtain the tick mark locations
ytick = get(AX,'YTick');
% Obtain the limits of the y axis
xlim = get(AX,'Xlim');

%if the outer (leftmost,...) grid lines coincide with the extent of the
%axes -> do not plot them
if numel(xtick) > 1;
    if xlim(1) == xtick(1); xtick(1) = []; end
    if xlim(2) == xtick(end); xtick(end) = []; end
end
if numel(ytick) > 1
    if ylim(1) == ytick(1); ytick(1) = []; end
    if ylim(2) == ytick(end); ytick(end) = []; end
end


if is_x
    % Create line data
    X = repmat(xtick,2,1);
    Y = repmat(ylim',1,size(xtick,2));
    % Plot line data
    plot(AX, X,Y,'Color', [0.6 0.6 0.6], 'Parent', hg, 'Tag', 'xgrid');
end

if is_y
    Y = repmat(ytick,2,1);
    X = repmat(xlim',1,size(ytick,2));
    % Plot line data
    plot(AX, X,Y,'Color', [0.6 0.6 0.6], 'Parent', hg, 'Tag', 'ygrid');
end

uistack(hg, 'bottom')

grid(AX, 'off')
if ~is_hold
    hold(AX, 'off')
end

% set(AX, 'XLimMode', XLimMode);
% set(AX, 'YLimMode', YLimMode);

% set(AX, 'XLim', xlim);

end
