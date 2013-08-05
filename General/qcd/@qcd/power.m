function [ obj ] = power( a, b )
%PLUS Summary of this function goes here
%   Detailed explanation goes here



[obj, val] =  generic_arithmetic(a, b);

obj.data = obj.data .^ val;


end



