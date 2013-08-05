function [nelements,xcenters] = hist( varargin )
%HIST Summary of this function goes here
%   Detailed explanation goes here


tf = isqcd(varargin{:});

assert( sum(tf) == 1, 'qcd:hist:only1qcdInp', 'Only one qcd input allowed')


varargin{tf} = varargin{tf}.data;


if nargout == 0
    hist(varargin{:});
elseif nargout == 1
    nelements = hist(varargin{:});
else
    [nelements,xcenters] = hist(varargin{:});
end



end

