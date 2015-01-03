function ByteSize(in, fid) %#ok<INUSL>
% BYTESIZE writes the memory usage of the provide variable to the given file
% identifier. Output is written to screen if fid is 1, empty or not provided.
%See Also
%bytes2str


if nargin == 1 || isempty(fid)
    fid = 1;
end
varargin
s = whos('in');
fprintf(fid,'%s\n', bytes2str(s.bytes));
end

