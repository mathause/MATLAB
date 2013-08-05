function h = rosef(theta,patch_color)
% h = rosef(theta,line_color) plots a filled rose plot
%
%   ROSE(THETA) plots the angle histogram for the angles in THETA.  
%   The angles in the vector THETA must be specified in radians.
%
%   ROSE(THETA, PATCH_COLOR) does the same but with the specified color
%
%   Mathias Hauser @ UNIS
%   02.05.2011  v1.0


%define color of the patch
if ~exist('patch_color','var'); patch_color = 'b'; end

%calculate the lines of the rose plot
[t, r] = rose(theta);
%plot them as polar plot in order to get the rigth axis
h = polar(t,r);
delete(h); %remove the lines again
%calcualte the values given in rho & theta back to x & y
[x,y] = pol2cart(t,r);
%plot them as patch
h = patch(x,y,patch_color);
end