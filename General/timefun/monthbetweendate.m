function n_months = monthbetweendate(begdate, enddate)
%MONTHBETWEENDATE returns number of months between two dates
%
%Syntax
%   n_months = MONTHBETWEENDATE(begdate, enddate)
%
%Usage
%   n_months = MONTHBETWEENDATE(begdate, enddate) returns the number of
%      months between enddate and begdate - every month that is begun (or
%       not ended) adds 1 to n_monts
%
%Examples
%   n_months = MONTHBETWEENDATE(datenum(2013,01,31), datenum(2013,02,1))
%   n_months = MONTHBETWEENDATE([2013,01,1], [2014,1,1])
%
%Version History
%   2013.11.25  mah     first version
%
%See Also
% datenum

narginchk(1,2)

if nargin == 1
    [m, n] = size(begdate); 
    if m*n == 2
        enddate = begdate(2);
        begdate = begdate(1);
    elseif m == 2
        enddate = begdate(2, :);
        begdate = begdate(1, :);
    end
end

begdate = datenum(begdate);
enddate = datenum(enddate);


if begdate > enddate
   warning('monthbetweendate:beg_ge_end', 'begdate after enddate: negative numbers of months')
end

[beg_year, beg_month] = datevec(begdate);
[end_year, end_month] = datevec(enddate);

years  = end_year - beg_year;
months = end_month - beg_month;

n_months = years*12 + months + 1; % + ceil(days/(days+eps));
end
