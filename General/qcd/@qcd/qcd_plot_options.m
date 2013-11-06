function qcd_plot_options
%QCD_PLOT_OPTIONS central help file for qcd plotting 
%
%The QCD_PLOT_OPTIONS are exemplified with 'plot' but they are valid for
%   all plotting functions.*
%
%Syntax
%   plot(valid_flag_option, qcd_obj, ...)
%   plot(sel, qcd_obj, ...)
%   plot(valid_flag_option, sel, qcd_obj, ...)
%
%Input
%   valid_flag_option
%       '-val' :    [default] only display/use valid values (see: gvf)
%       '-all' :    show also invalid values (note: they may be NaN anyway)
%       '-comb':    only use values that are valid 
%   sel             logical array with the same size as the qcd object. 
%                       elements that are true will be ploted/ used, the 
%                       others not.
%
%The 'technical' description is given in generic_graph
%
%* this is of course only valid for the plotting functions that are
%implemeted and use 'generic_graph'.
%
%See Also
% gvf | qcd/private/generic_graph



end
