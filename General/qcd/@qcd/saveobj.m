function [ b, time ] = saveobj( a, d )
%SAVEOBJ Summary of this function goes here
%   Detailed explanation goes here

whos d
disp('bla')

whos a


inputname(1)


[ST,I] =  dbstack('-completenames');

assb(ST, I)

disp('why twice?')

b = a;

time = a.time;

end

