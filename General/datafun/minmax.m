function [ mm ] = minmax( x )
%MINMAX calculates minimum and maximum of an array
%
%Syntax
%   mm = MINMAX( x )
%
%Usage
%   mm = MINMAX( x ) returns [minimum maximum] of x
%
%Version History
% 22.07.2013    mah     created
%
%See Also
% min | max


mm = [min(x) max(x)];

end

