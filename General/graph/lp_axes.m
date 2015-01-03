function varargout = lp_axes(f, fct_handle, varargin)
%LP_AXES execute functin for all axes (subplots) of a figure
%
%Syntax
%   LP_AXES(f, fct_handle)
%   LP_AXES(f, fct_handle, arglist)
%
%Usage
%   LP_AXES(f, fct_handle) call fct_handle for all subplots of the figure f
%   LP_AXES(f, fct_handle, arglist) specify any input that the fuction
%       needs in the arglist
%
%Example
%   figure
%   subplot(2,1,1); subplot(2,1,2);
%   LP_AXES(gcf, @xlim, [0 100])
%
%Version History
%   29.10.2013  mah     refractored from xgrid_all
%
%See Also
%subplot | sca | function_handle | gca | gcf | (xgrid_all)

if nargin < 2 || isempty(f);
    f = gcf;
end

current_axes = gca;

h_axes = findobj(get(f, 'Children'), 'Type', 'Axes');

for ii = h_axes'
   sca(ii)
   if nargout == 0
       fct_handle(varargin{:});
   else
       varargout = cell(1, nargout); 
       [varargout{:}] = fct_handle(varargin{:});
   end
end

%restore previous state
sca(current_axes)




end
