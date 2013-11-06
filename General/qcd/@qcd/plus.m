function [ obj ] = plus(a, b)
%PLUS addition of qcd objects

[obj, val] =  generic_arithmetic(a, b);

obj.data = obj.data + val;
end



