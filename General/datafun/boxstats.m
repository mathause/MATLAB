function [med, p25, p75, whisL, whisU, outlL, outlU] =  boxstats(X, w)
%BOXSTATS returns statistics used in boxplots
%
%Syntax
%   [med, p25, p75] =  BOXSTATS(X)
%   [med, p25, p75, whisL, whisU] =  BOXSTATS(X)
%   [med, p25, p75, whisL, whisU] =  BOXSTATS(X, w)
%   [med, p25, p75, whisL, whisU, outlL, outlU] =  BOXSTATS(...)
%
%Usage
%   [med, p25, p75] =  BOXSTATS(X) returns median, 25th and 75th percentile
%       of the data vector X (2d vector).
%   [med, p25, p75, whisL, whisU] =  BOXSTATS(X) also retutns the position
%       of the upper and lower whisker as used by boxplots. The whiskers 
%       have the length of w = 1.5, see below.
%   [med, p25, p75, whisL, whisU] =  BOXSTATS(X, w), also taking the length
%       of the whiskers as input, (default = 1.5), see below.
%   [med, p25, p75, whisL, whisU, outlL, outlU] =  BOXSTATS(...) returns 
%       position of the outliers (all points beyond whisL and whisU).
%
%Whiskers (from the boxplot documentation)
%   Maximum whisker length w. The default is a w of 1.5. Points are drawn
%   as outliers if they are larger than p75 + w(p75 – p25) or smaller than
%   p25 – w(p75 – p25), where p25 and p75 are the 25th and 75th percentiles,
%   respectively. The default of 1.5 corresponds to approximately +/–2.7?
%   and 99.3 coverage if the data are normally distributed. The plotted
%   whisker extends to the adjacent value, which is the most extreme data
%   value that is not an outlier. If w is 0 whisU and whisL are empty ([]).
%
%Examples
%   [med, p25, p75, whisL, whisU] =  BOXSTATS(rand(50,1), 1);
%   [med, p25, p75, whisL, whisU, outlL, outlU] =  BOXSTATS(rand(100,1));
%
%Version History
%   16.07.2013  mah     created
%   23.07.2013  mah     added doc and input checking
%   28.10.2013  mah     handling of w = 0
%   
%
%See Also
% boxplots | boxplot | beanplot

validateattributes(X, {'double', 'single'}, {'2d', 'real'}, mfilename, 'X')

if nargin < 2;
    w = 1.5;
else
    validateattributes(w, {'double'}, {'scalar', 'nonnegative'}, mfilename, 'w')
end

pc = prctile(X, [25; 50; 75]);

med = pc(2,:);
p25 = pc(1,:); p75 = pc(3,:);



if nargout > 3
    if w == 0 %return empty whiskers for w = 0
        whisL = [];
        whisU = [];
    else %determination of the WHISKERS -> see help of boxplot
        %inter quartile range
        iqr = diff([p25; p75]);
        
        whisU = p75 + w*iqr; %theoretical upper whiskers
        
        d = whisU - X; %find next smaller datapoint
        sel = d > 0;
        whisU = -min(d(sel)) + whisU;
        
        whisL = p25 - w*iqr;
        d = whisL - X;
        sel = d < 0;
        whisL = -max(d(sel)) + whisL;
    end
end



%get the outliers
if nargout > 5
    if w == 0
        outlL = X(X < p25);
        outlU = X(X > p75);
    else
        outlL = X(X < whisL);
        outlU = X(X > whisU);
    end
end





end
