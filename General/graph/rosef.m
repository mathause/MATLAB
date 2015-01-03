function h = rosef(varargin)
%ROSEF plots a filled rose plot
%
%Syntax
%   ROSEF(theta)
%   ROSEF(theta, patch_color)
%   ROSEF(theta, x)
%   ROSEF(theta, nbins)
%   ROSEF(theta, ..., patch_color)
%   ROSEF(axes_handle, ...)
%   h = ROSEF(...)
%
%Usage
%   ROSEF(theta) plots the angle histogram for the angles in THETA (filled
%       rose plot). The angles in the vector THETA must be specified in 
%       radians.
%   ROSEF(theta, patch_color) define color of the patch
%   ROSEF(theta, x) uses the vector x to specify the number and the
%       locations of bins. length(x) is the number of bins and the values 
%       of x specify the center angle of each bin.
%   ROSEF(theta, nbins) lots nbins equally spaced bins in the range 
%       [0, 2*pi]. The default is 20.
%   ROSEF(theta, ..., patch_color) define patch_color and x or nbins
%   ROSEF(axes_handle, ...) plots into the axes specified by axes_handle
%      instead of the current axes.
%   h = ROSEF(...) returns the handle of the patch
%
%Version History
%   Mathias Hauser @ UNIS // 02.05.2011 v1.0
%   Mathias Hauser @ MCH  // 13.11.2013 v2.0
%
%See Also
% rose | patch

narginchk(1, 4)

curr_ax = gca;

[AX, ARGS] = axescheck(varargin{:});

if ~isempty(AX);
    scf(AX);
    CleanUP = onCleanup(@() sca(curr_ax));
%else: use current axes
end

patch_color = 'b'; %define color of the patch


is_char = cellfun(@ischar,ARGS);
if any(is_char)
    assert(sum(is_char) <= 1, 'Only one string input allowed')
    patch_color = ARGS{is_char};
    ARGS(is_char) = [];
end

%calculate the lines of the rose plot
[t, r] = rose(ARGS{:});
%plot them as polar plot in order to get the rigth axis
h = polar(t,r);
delete(h); %remove the lines again
%calcualte the values given in rho & theta back to x & y
[x,y] = pol2cart(t,r);
%plot them as patch
if nargout > 0
    h = patch(x,y,patch_color);
else
    patch(x,y,patch_color);
end




end
