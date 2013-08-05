function [med, p25, p75, whisL, whisH, outlL, outlH ] =  boxstats( X, w )
%BOXSTATS returns statistics used in boxplots
%
%Syntax
%   [med, p25, p75, whisL, whisH] =  BOXSTATS( X, w )
%   [med, p25, p75, whisL, whisH, outlL, outlH ] =  BOXSTATS( X, w )
%
%Usage
%   [med, p25, p75, whisL, whisH] =  BOXSTATS( X, w ) returns median, 25th
%       and 75th percentile, and the position of the upper and lower whisker
%       as used by boxplots. X is the data (2d vector) and w (optional,
%       scalar) the length of the whiskers (default = 1.5), see below;
%   [med, p25, p75, whisL, whisH, outlL, outlH ] =  BOXSTATS( X, w ) dito,
%      but does not return outliers.
%
%Whiskers (from the boxplot documentation)
%   Maximum whisker length w. The default is a w of 1.5. Points are drawn
%   as outliers if they are larger than q3 + w(q3 – q1) or smaller than
%   q1 – w(q3 – q1), where q1 and q3 are the 25th and 75th percentiles,
%   respectively. The default of 1.5 corresponds to approximately +/–2.7?
%   and 99.3 coverage if the data are normally distributed. The plotted
%   whisker extends to the adjacent value, which is the most extreme data
%   value that is not an outlier. Set whisker to 0 to give no whiskers and
%   to make every point outside of q1 and q3 an outlier.
%
%Version History
%   16.07.2013  mah     created
%   23.07.2013  mah     added doc and input checking
%
%See Also
% boxplots | boxplot | beanplot

validateattributes(X, {'double', 'single'}, {'2d', 'real'}, mfilename, 'X')

if nargin < 2;
    w = 1.5;
else
    validateattributes(w, {'double'}, {'scalar', 'positive'}, mfilename, 'w')
end




pc = prctile(X, [25; 50; 75]);

med = pc(2,:);
p25 = pc(1,:); p75 = pc(3,:);





%determination of the WHISKERS -> see help of boxplot
if nargout > 3
    %inter quartile range
    iqr = diff([p25; p75]);

    whisH = p75 + w*iqr;
    
    d = whisH - X;
    sel = d > 0;
    whisH = -min(d(sel)) + whisH;
    
    whisL = p25 - w*iqr;
    d = whisL - X;
    sel = d < 0;
    whisL = -max(d(sel)) + whisL;
end

%get the outliers
if nargout > 5
    outlL = X(X < whisL);
    outlH = X(X > whisH);
end





end