function h = plot(varargin)
%PLOT qcd objects
%
%Syntax
%   h = PLOT(...)
%   h = PLOT(qcd_plot_options, ...)
%
%Usage
%   h = PLOT(...) use the same way as the normal plotting function but with
%       a qcd object
%   h = PLOT(qcd_plot_options, ...) -> see in generic_graph
%
%
%See Also
%qcd/qcd_plot_options


[ cax, to_plot ] = generic_graph(true, true, varargin{:});

if nargout == 0
    plot(cax, to_plot{:})
else
    h = plot(cax, to_plot{:});
end


end
