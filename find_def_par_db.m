function [ idx, names ] = find_def_par_db( param, varargin )
%FIND_DEF_PAR_DB finds position of param in def_par_db
%
%Syntax
%   FIND_DEF_PAR_DB(param)
%   FIND_DEF_PAR_DB(param, def_par_db)
%   idx = FIND_DEF_PAR_DB(...)
%   [idx, names] = FIND_DEF_PAR_DB(...)
%
%Usage
%   FIND_DEF_PAR_DB(param) prints the linear index of the position of
%       param in def_par_db (uses the 'global def_par_db')
%   FIND_DEF_PAR_DB(param, def_par_db) dito, explicitly passing def_par_db
%   idx = FIND_DEF_PAR_DB(...) returns the linear index
%   [idx, names] = FIND_DEF_PAR_DB(...) also returns the found names
%
%Input
%   param:  can be a regular expression (see regexp)
%
%Version History
%   04.07.2013  Mathias Hauser@MCH  created
%   22.08.2013         "            vectorized, regexp
%
%See Also
%regexp

if nargin == 1
    global def_par_db %#ok<TLEV>
    assert(~isempty(def_par_db), 'find_def_par_db:gl_empty', ...
        'def_par_db not defined as global variable')
else
    def_par_db = varargin{1};
end




name = {def_par_db.name};

ec = cellfun(@isempty, name);

name = name(~ec);

startIndex = regexp(name, param);

tf = ~emptycell(startIndex);

pt = find(~ec);

idx_int = pt(tf);
if ~isempty(idx_int)
    fprintf('Found:\n No Parameter\n-------------\n')
    for ii = idx_int
        %fprintf( 'Found %s at %i\n', def_par_db(ii).name, ii);
        fprintf( '%2i: %s\n', ii, def_par_db(ii).name);
    end
end

if nargout > 1
   idx = idx_int; 
    
    names = {def_par_db(idx).name};
end


end

