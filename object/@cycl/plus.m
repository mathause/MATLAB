function [ sum ] = plus( a, b )
%PLUS Summary of this function goes here
%   Detailed explanation goes here


if ~isa( a, 'cycl')

    sum = a + b.VALUE;
elseif ~isa( b, 'cycl')
    sum = a.VALUE + b;
else
    sum = a.VALUE + b.VALUE;
end


sum = cycl(sum);

end