function xgrid_all(f)
%XGRID_ALL call xgrid for all axes (subplots) of one figure
%
%Syntax
%   XGRID_ALL
%   XGRID_ALL(f)
%
%Usage
%   XGRID_ALL calls xgrid for all axes of the current figure (gcf)
%   XGRID_ALL(f) calls if for the specified figure
%
%Example
%   figure;
%   subplot(2,1,1); subplot(2,1,2);
%   XGRID_ALL
%
%Version History
%   06.09.2013  mah     created
%   29.20.2013  mah     factored out lp_axes
%
%See Also
%xgrid | subplot | lp_axes

if nargin < 1
    f = gcf;
end

lp_axes(f, @xgrid)

%old version
% if nargin < 1; f = gcf; end
% 
% 
% h_a = findobj( get( f, 'Children' ), 'Type', 'Axes' );
% 
% for ii = h_a'
%     
%    sca(ii)
%    xgrid();
%     
%     
% end



end
