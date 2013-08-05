function [ obj ] = plus( a, b, varargin )
%PLUS Summary of this function goes here
%   Detailed explanation goes here


if nargin > 2
    disp( num2str(varargin{1}));
end


[obj, val] =  generic_arithmetic(a, b);

obj.data = obj.data + val;


end



