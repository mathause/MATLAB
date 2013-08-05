function [ compass ] = degree2compass( deg )
%degree2compass converts compass coordinates into polar cordinates (degree)
%
%Syntax
%   compass = degree2compass( deg )
%
%Usage
%   compass = degree2compass( deg ) converts the angle in polar cordinates
%       to an angle in compass notation i.e. from a anti- to a an clockwise
%       rotation
%
%   Mathias Hauser, June 2013
%   Version 1
%
%See Also
% compass2degree, rad2deg

compass = mod(90 - deg,360);
end