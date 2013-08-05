function [ h, AX ] = boxplots( varargin )
%BOXPLOTS Summary of this function goes here
%   Detailed explanation goes here
%
%Tipps
%   in order to set the labels use (or 'YTickLabel')
%   set(gca,'XTickLabel', Labels)
%
%   to display a legend use:
%   h = BOXPLOTS(...)
%   h_leg = [h(1), h(2) h(3)];
%   leg = {'Median', 'IQR', 'Range'};
%   legend(h_leg, leg)
%See Also
%boxplot | boxstats


%input parsing
[AXi, X, POS, opt] = parseInput(varargin{:});

n_plots = size(X, 2);

is_compact = opt.compact;
plot_horz = strcmp(opt.orientation, 'horizontal');
plot_outliers = opt.outliers;
whisker = opt.whisker;

%end input parsing


if is_compact
    patch_col = 'b';
    patch_half_width = 0.33;
    line_width = 2;
    
    whis_lineSpec = 'b-';
else
    patch_half_width = 0.33;    
    patch_col = 'w';
    line_width = 1;
    
    whis_lineSpec = 'k--';
end

kk = 1; %for the handles

hi = zeros(8, n_plots);

hold on
for ii = 1:n_plots
    %create hggroup to contain all plot elements
    hg = hggroup('Parent',AXi);

    if plot_outliers
        %get statistics incl ouliers
        [med, p25, p75, whisL, whisH, outlL, outlH] =  boxstats( X(:,ii), whisker );
        %plot outliers
        plt = swap_xy( POS(ii)*ones(length(outlL),1), outlL, plot_horz );
        hi(7,kk) = plot(plt{:}, 'or', 'Tag', 'Low Outliers', 'Parent', hg);
        plt = swap_xy( POS(ii)*ones(length(outlH),1), outlH, plot_horz );
        hi(8,kk) = plot(plt{:}, 'or', 'Tag', 'High Outliers', 'Parent', hg);
    else
        %get statistics w/o outliers
        [med, p25, p75, whisL, whisH] =  boxstats( X(:,ii), whisker );
    end


%plot the box with the iqr
x_iqr = [-1 -1 1 1]*patch_half_width + POS(ii);
y_iqr =  [ p25   p75  p75  p25];
plt = swap_xy( x_iqr,y_iqr, plot_horz );
hi(2, kk) = patch(plt{:},patch_col, 'EdgeColor','b', 'Tag', 'Box', 'Parent', hg);


%plot the median
x_med = x_iqr(2:3);
plt = swap_xy( x_med, [med med], plot_horz );
hi(1, kk) = plot(plt{:} , 'r', 'LineWidth', line_width, 'Tag', 'Median', 'Parent', hg);

%plot the whiskers
x_whis_vert = [0 0] + POS(ii);
plt = swap_xy( x_whis_vert, [p25 whisL], plot_horz );
hi(3, kk) = plot(plt{:}, whis_lineSpec, 'LineWidth', line_width, 'Tag', 'Lower Whisker', 'Parent', hg);
plt = swap_xy( x_whis_vert, [p75 whisH], plot_horz );
hi(4, kk) = plot(plt{:}, whis_lineSpec, 'LineWidth', line_width, 'Tag', 'Higher Whisker', 'Parent', hg);
    
%plot the horizontal whiskers (lower adjacent)
if ~is_compact   
    x_whis_horz = [-0.25 0.25] + POS(ii);
    plt = swap_xy( x_whis_horz, [whisL, whisL], plot_horz );
    hi(5, kk) = plot(plt{:}, 'k', 'Tag', 'Lower Adjacent Value', 'Parent', hg);
    plt = swap_xy( x_whis_horz, [whisH, whisH], plot_horz );
    hi(6, kk) = plot(plt{:}, 'k', 'Tag', 'Upper Adjacent Value', 'Parent', hg);
end


%plot 2 ghost points to get a bit a nicer ylim (dont set them explicitly
%because you would need to get all the previous ones when adding a boxplot)
plt = swap_xy( POS(ii), whisL - abs(whisL)*0.05, plot_horz );
plot(plt{:}, 'w', 'Tag', 'Lower Ghost', 'Parent', hg )
plt = swap_xy( POS(ii), whisH + abs(whisL)*0.05, plot_horz );
plot(plt{:}, 'w', 'Tag', 'Upper Ghost', 'Parent', hg)



end
hold off


if plot_horz
 ax = 'Y';
    
else
    ax = 'X';
end

first_plt = strcmp(get(AXi, [ax, 'TickMode']), 'auto');
if first_plt
    set(AXi, [ax 'Tick'], POS)
    
    set(AXi, [ax 'Lim'], [floor(POS(1))-1 ceil(POS(end))+1])
    
else
    Ticks = get(AXi, [ax 'Tick']);
    
    Ticks = union(Ticks, POS);
    
    set(AXi, [ax 'Tick'], Ticks)
    
    
    set(AXi, [ax 'Lim'], [floor(Ticks(1)) - 1 ceil(Ticks(end)) + 1])
    
end
    
    
% if ~isempty( TickLabel )
%     if first_plt
%         set(AX, [ax 'TickLabel'], TickLabel)
%     else
%         a = cellstr(get(AX, [ax 'TickLabel']));
%         [TLabel{ Ticks }] = a{:};
%         [TLabel{POS}] = TickLabel{:};        
%         empty_labels = cellfun(@isempty, TLabel);
%         TLabel(empty_labels) = [];
%         set(AX, [ax 'TickLabel'], TLabel)         
%     end
% else
% end

box on

%x_lim = get(AX, 'XLim');
if nargout > 0
    
   AX = AXi; 
   h = hi;
end




end



function [AX, X, POS, opt] = parseInput(varargin)

[AX,ARGS,NARGS] = axescheck(varargin{:});


if isempty(AX)
    AX = gca;
else
    %axes(AX)
    f = get(AX, 'Parent');
    set(0, 'currentfigure', f);
    set(f, 'currentaxes', AX);
end

X = ARGS{1};

n_plots = size(X, 2);

if numel(X) <= 1
   error('boxplots:invHandle', 'X must have more than one element (maybe you specified an invalid axes handle).'); 
end


if NARGS > 1 && isnumeric( ARGS{2} ) && ~isempty( ARGS{2})
    POS = ARGS{2};
    assert(all(rem(POS, 1) == 0), 'boxplots:POSnotINT', 'The vector with the positions must only contain integers.'); 
    ARGS(1:2) = [];
else
    POS = 1:n_plots;
    ARGS(1) = [];
end



p = inputParser;

%p.KeepUnmatched = true;
%boxplot

addParamValue(p,'compact',false)
addParamValue(p,'orientation', 'vertical')
addParamValue(p,'outliers', false)
addParamValue(p,'whisker', 1.5);





parse(p, ARGS{:})

opt = p.Results;


end






function plt = swap_xy( x, y, swap )

if swap
    plt{1} = y; plt{2} = x;
else
    plt{1} = x; plt{2} = y;
end


end
