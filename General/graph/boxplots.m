function [ h, AX ] = boxplots(varargin)
%BOXPLOTS alternative to the MATLAB boxplot
%
%Syntax
%   BOXPLOTS(X)
%   BOXPLOTS(X, POS)
%   BOXPLOTS(..., Name, Value, ...)
%   BOXPLOTS(axes_handle, ...)
%   h = BOXPLOTS(...)
%   [h, AX] = BOXPLOTS(...)
%
%Usage
%   BOXPLOTS(X) makes a boxplots with the values in X. X must be a column
%       vector or a matrix and each column gets a boxplot.
%   BOXPLOTS(X, POS) makes a boxplot at the position(s) in POS. POS must be
%       integers and have the same number of elements than X has columns.
%       If POS is not given, POS is 1:n_columns.
%   BOXPLOTS(..., 'Name', Value, ...) manipulate the boxplot by setting its
%       properties (see below).
%   BOXPLOTS(axes_handle, ...) plots using axes with the handle axes_handle
%       instead of the current axes (gca).
%   h = BOXPLOTS(...) returns the handles of the elements of the boxplot.
%       h is a [8 x n_columns] matrix (see Tipps below).
%   [h, AX] = BOXPLOTS(...) also returns the handle of the axes.
%
%Input
%Name Value Pairs
%   compact: {false} | true
%       plot a compact version of the boxplots
%   orientation: {'vertical'} | 'horizontal
%       plot the boxplots horizontally or vertically
%   outliers: {false} | true
%       plot outliers or not
%   whisker: {1.5} | nonnegative number
%       see below
%   stretch:  {1} | nonnegative number
%       stretches the patch (iqr) by delta if the boxplots are more than
%           '1' apart from each other (e.g. if POS is not [1 2 3] but
%           [1 3 5], set delta to 2)
%   LineWidth:  {2|1} | nonnegative integer
%           define the width of the lines of the plot (default for not 
%           compact and compact plot, respectively)
%
%Whiskers (from the MATLAB boxplot documentation)
%   Maximum whisker length w. The default is a w of 1.5. Points are drawn
%   as outliers if they are larger than p75 + w(p75 – p25) or smaller than
%   p25 – w(p75 – p25), where p25 and p75 are the 25th and 75th percentiles,
%   respectively. The default of 1.5 corresponds to approximately +/–2.7?
%   and 99.3 coverage if the data are normally distributed. The plotted
%   whisker extends to the adjacent value, which is the most extreme data
%   value that is not an outlier. Set whisker to 0 to give no whiskers and
%   to make every point outside of p25 and p75 an outlier.
%
%Output
%   h   The [8 x n_columns] lists the handles for each drawn object, if an
%       object is not drawn (e.g. if the outliers are supressed), 0 is
%       given:
%   h = {'median';        ... median line
%        'patch';         ... patch from p25 to p75
%        'whisL paralel'; ... line from first non-outlier to p25
%        'whisU paralel'; ... line from p75 ti last non-outlier
%        'whisL perp';    ... line at first non-outlier
%        'whisU perp';    ... line at last non-outlier
%        'outlL';         ... lower outliers
%        'outlU'}         %   upper outliers
%
%Example
%   x1 = normrnd(5,1,100,1);
%   x2 = normrnd(6,1,100,1);
%   boxplots(x1,1)
%   boxplots(x2,2)
%
%   figure
%   X = randn(100,25);
%   boxplots(X,'compact', true)
%
%Tipps
%   Labels
%       in order to set the labels use:
%       set(gca,'XTickLabel', Labels)
%       (or 'YTickLabel')
%
%   Legend
%      to display a legend use:
%       h = BOXPLOTS(...)
%       h_leg = [h(1), h(2) h(3)];
%       leg = {'Median', 'IQR', 'Range'};
%       legend(h_leg, leg)
%
%Version History
%   16.07.2013   mah@MCH   created
%   26.08.2013   mah@MCH   documentation
%   28.10.2013   mah@MCH   bugfixes (w=0), doc, ghost pts, empty outliers
%   07.11.2013   mah@MCH   introduced delta to stretch patch
%   06.12.2013   mah@MCH   added LineWidth, renamed delta to stretch
%
%See Also
%boxplot | boxstats


%input parsing
[AXi, X, POS, opt] = parseInput(varargin{:});

n_plots = size(X, 2);

is_compact = opt.compact;
plot_horz = strcmp(opt.orientation, 'horizontal');
plot_outliers = opt.outliers;
whisker = opt.whisker;
stretch = opt.stretch;
%end input parsing

if is_compact
    patch_col = 'b';
    patch_half_width = 0.33*stretch;
    patch_FaceAlpha = 1;

    line_width = 2;
    
    whis_lineSpec = 'b-';
else
    patch_col = 'w';
    patch_half_width = 0.33*stretch;
    patch_FaceAlpha = 1;

    line_width = 1;
    
    whis_lineSpec = 'k--';
end
if ~isempty(customLineWidth)
    line_width = customLineWidth;
end
    
hi = zeros(8, n_plots); %handles of the plotted objects

is_hold = ishold;

if ~is_hold
    plot(NaN); %get rid of previous plots (default MATLAB behaviour)
    hold on
end

for ii = 1:n_plots
    %create hggroup to contain all plot elements
    hg = hggroup('Parent',AXi);
    
    if plot_outliers
        %get statistics incl. ouliers
        [med, p25, p75, whisL, whisU, outlL, outlU] =  boxstats(X(:,ii), whisker);
        %plot outliers
        if ~isempty(outlL)
            hi(7,ii) = swap_plot(plot_horz, POS(ii)*ones(length(outlL),1), outlL, 'or', 'Low Outliers');
        end
        if ~isempty(outlU)
            hi(8,ii) = swap_plot(plot_horz, POS(ii)*ones(length(outlU),1), outlU, 'or', 'High Outliers');
        end
    else
        %get statistics w/o outliers
        [med, p25, p75, whisL, whisU] =  boxstats(X(:,ii), whisker);
    end
    
    
    %plot the box with the iqr
    x_iqr = [-1 -1 1 1]*patch_half_width + POS(ii);
    y_iqr =  [p25   p75  p75  p25];
    plt = swap_xy(x_iqr,y_iqr, plot_horz);
    hi(2, ii) = patch(plt{:},patch_col, 'EdgeColor','b', 'Tag', 'Box', 'Parent', hg, 'FaceAlpha', patch_FaceAlpha);
    
    
    %plot the median
    x_med = x_iqr(2:3);    
    hi(1, ii) = swap_plot(plot_horz, x_med, [med med], 'r', 'Median', 'LineWidth', line_width);
    
    
    if whisker > 0
        %plot the whiskers
        x_whis_vert = [0 0] + POS(ii);
        hi(3, ii) = swap_plot(plot_horz, x_whis_vert, [p25 whisL], whis_lineSpec, 'Lower Whisker',  'LineWidth', line_width);
        hi(4, ii) = swap_plot(plot_horz, x_whis_vert, [p75 whisU], whis_lineSpec, 'Higher Whisker', 'LineWidth', line_width);
        
        
        %plot the horizontal whiskers (lower adjacent)
        if ~is_compact
            x_whis_horz = [-0.25 0.25] + POS(ii);
            hi(5, ii) = swap_plot(plot_horz, x_whis_horz, [whisL, whisL], 'k', 'Lower Adjacent Value');
            hi(6, ii) = swap_plot(plot_horz, x_whis_horz, [whisU, whisU], 'k', 'Upper Adjacent Value');
        end
    end
end

if ~is_hold; hold off; end


%set Ticks and Lim
if plot_horz; ax = 'Y'; else ax = 'X'; end

first_plt = strcmp(get(AXi, [ax, 'TickMode']), 'auto');
dLim = 0.5 + 0.5*stretch;
if first_plt
    set(AXi, [ax 'Tick'], POS)
    set(AXi, [ax 'Lim'], [floor(POS(1))-dLim ceil(POS(end))+dLim])
else
    Ticks = get(AXi, [ax 'Tick']);
    Ticks = union(Ticks, POS);
    set(AXi, [ax 'Tick'], Ticks)
    set(AXi, [ax 'Lim'], [floor(Ticks(1)) - dLim ceil(Ticks(end)) + dLim])
end

box on


if nargout > 0
    AX = AXi;
    h = hi;
end

% =========================== NESTED FUNCTIONS ============================
    %nested function (because of hg)
    function h = swap_plot(swap, x, y, LineSpec, Tag, varargin)
        %ploting function with the common settings
        sw_plt = swap_xy(x, y, swap); %swap xy if necessary
        if nargout == 0
            %all plots have a Tag and hg as Parent
            plot(sw_plt{:}, LineSpec, 'Tag', Tag, 'Parent', hg, varargin{:});
        else
            h = plot(sw_plt{:}, LineSpec, 'Tag', Tag, 'Parent', hg, varargin{:}); 
        end  
    end
% ========================= END NESTED FUNCTIONS ==========================

end

% ============================ LOCAL FUNCTIONS ============================
function [AX, X, POS, opt] = parseInput(varargin)

[AX,ARGS,NARGS] = axescheck(varargin{:});


if isempty(AX)
    AX = gca;
else
    %set AX as current
    f = get(AX, 'Parent');
    set(0, 'currentfigure', f);
    set(f, 'currentaxes', AX);
end

X = ARGS{1};

n_plots = size(X, 2);

if size(X, 1) <= 1
    error('boxplots:invHandle', 'X must have more than one element (maybe you specified an invalid axes handle).');
end

if NARGS > 1 && isnumeric(ARGS{2}) && ~isempty(ARGS{2})
    POS = ARGS{2};
    assert(all(rem(POS, 1) == 0), 'boxplots:POSnotINT', 'The vector with the positions must only contain integers.');
    assert(length(POS) == n_plots, 'boxplots:nPOSnot_eq_nPlots', ...
        'The POS vector must have the same number of elements (has %i) as X has columns (has %i)', ...
        length(POS), n_plots)
    ARGS(1:2) = [];
else
    POS = 1:n_plots;
    ARGS(1) = [];
end



p = inputParser;

addParamValue(p,'compact',false)
addParamValue(p,'orientation', 'vertical')
addParamValue(p,'outliers', false)
addParamValue(p,'whisker', 1.5);
addParamValue(p,'stretch', 1);
addParamValue(p,'LineWidth', []);

parse(p, ARGS{:})

validateattributes(p.Results.stretch, {'numeric'}, {'scalar', 'real', 'nonnegative'}, mfilename, 'delta')

opt = p.Results;


end



function plt = swap_xy(x, y, swap)
%exchange x & y to plot horizontally or vertically
if swap
    plt{1} = y; plt{2} = x;
else
    plt{1} = x; plt{2} = y;
end
end

% ========================== END LOCAL FUNCTIONS ==========================

