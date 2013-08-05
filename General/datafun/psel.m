function perc = psel(sel)
%PSEL returns percentage of elements that are true in a logical array
%
%Syntax
%   perc = PSEL(sel)
%
%Usage
%   perc = PSEL(sel) returns percentage of true in the logical array sel
%
%Version History
%   17.07.2013  mah     created
%
%See Also
%   logical | true | sum | size

perc = sum(sel) / size(sel, 1);
end