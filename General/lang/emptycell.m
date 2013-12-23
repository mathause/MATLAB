function tf = emptycell(A) 
%EMPTYCELL returns a logical array indicating if a cell is empty
%
%Syntax
%   tf = EMPTYCELL(A)
%
%Usage
%   tf = EMPTYCELL(A) returns a logical array with the same size as A 
%       that indicates if the single cells are empty or not
%
%Example
%   tf = EMPTYCELL({[], 1, [], 2});
%   tf = EMPTYCELL({});
%
%Version History
%   22.08.2013  Mathias Hauser@MCH  created
%
%See Also
%   isempty | cellfun

assert(iscell(A), 'emptycell:inp_nt_cell', 'Input must be a cell')


if any(size(A) == 0)
    tf = true;
else
    tf = cellfun(@isempty, A);
end