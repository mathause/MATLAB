function scf(f)
%SCF makes f the current figure
%
%Syntax
%   SCF(f)
%
%Usage
%   SCF(f) makes f the current axis (but does not put it in the
%   foreground)
%
%Version History
%   26.07.2013  mah     created (from sca)
%
% See Also
% sca | gcf | set


set(0, 'currentfigure', f);

end