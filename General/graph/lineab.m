function h = lineab(a, b, varargin)
%LINEAB plots a straight line on a plot
%
%Syntax
%   lineab()
%   lineab(a)
%   lineab(a, b)
%   lineab(a, b, LineSpec, ...)
%   lineab(a, b, ..., 'PropertyName',PropertyValue, ...)
%   h = lineab(...)
%
%Usage
%   lineab() plots a horizontal line through the origin. Uses Xlim to
%      determine the length of the line .
%   lineab(a) plots a line with intercept a
%   lineab(a, b) plots a line with intercept a and slope b
%   lineab(a, b, LineSpec, ...) dito specifing the LineSpec (see plot)
%   lineab(a, b, ..., 'PropertyName',PropertyValue, ...) dito, specifing
%      property-value pairs of plot
%   h = lineab(...) also returns the handle of the line
%
%Version History
%   07.08.2013  mah     created
%   13.08.2013  mah     docs


if nargin == 0
    b = 0;   a = 0;
elseif nargin == 1
    b = 0;
end

if nargin < 3
    varargin = {'k'};
end


ih = ishold;

if ~ih
    hold on
end


hax = gca;
xlim = get(hax, 'XLim');


if nargout > 0
    h = plot( xlim, a + xlim*b, varargin{:});
else
    plot( xlim, a + xlim*b, varargin{:});
end
%uistack(h, 'bottom')




if ~ih
    hold off
end


end