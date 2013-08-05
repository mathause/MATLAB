function sca(ax)
%SCA makes ax the current axis
%
%Syntax
%   SCA(ax)
%
%Usage
%   SCA(ax) makes ax the current axis (but does not put it in the
%   foreground)
%
%Version History
%   16.07.2013  mah     created
%
% See Also
% scf | gca | set



f = get(ax, 'Parent');
set(0, 'currentfigure', f);
set(f, 'currentaxes', ax);





end