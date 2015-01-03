function [ deg ] = compass2degree( compass )
%COMPASS2DEGREE converts compass coordinates into polar cordinates (degree)
%
%Syntax
%   deg = COMPASS2DEGREE( compass )
%
%Usage
%   deg = COMPASS2DEGREE( compass ) converts the angle in compass notation
%       to an angle in polar cordinates i.e. from a clock- to a an 
%       anticlockwise rotation
%
%   Mathias Hauser, April 2011
%   Version 1.1
%   05.06.2013 renamed
%
%See Also
% degree2compass, deg2rad

deg = mod(90 - compass,360);
end