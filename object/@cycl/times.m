function [ prod ] = times( a, b )
%TIMES Summary of this function goes here
%   Detailed explanation goes here


if ~isa( a, 'cycl')

    prod = a .* b.VALUE;
elseif ~isa( b, 'cycl')
    prod = a.VALUE .* b;
else
    prod = a.VALUE .* b.VALUE;
end


prod = cycl(prod);

end

