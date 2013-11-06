function [nelements,xcenters] = hist(varargin)
%HIST Summary of this function goes here
%   Detailed explanation goes here

[cax, to_plot] = generic_graph(false, false, varargin{:});

if nargout == 0
    hist(cax, to_plot{:});
elseif nargout >= 1
    [nelements,xcenters] = hist(cax, to_plot{:});
end



end

