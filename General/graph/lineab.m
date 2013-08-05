function lineab(a, b)



if nargin == 0
   b = 0;
   a = 0;
elseif nargin == 1
%    b = a;
%    a = 0;
b = 0;
end


ih = ishold;

if ~ih
    hold on
end


h = gca;
xlim = get(h, 'XLim');

% dx = diff(xlim);
% 
% assb(dx, xlim)
% 
% xlim(1) = xlim(1)*(1+dx/100);
% xlim(2) = xlim(2)*(1-dx/100);
% 
% assb(xlim, 'xlmin')


% xlim(1) = xlim(1) + eps;
% xlim(2) = xlim(2) - 2;

h = plot( xlim, a + xlim*b, 'k');

%uistack(h, 'bottom')




if ~ih
    hold off
end


end