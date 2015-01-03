function [fullName, pathstr, FileName] = getMfile(varargin)
%getMfile returns absolute path of m files
%
%Syntax
%   fullName = getMfile( name )
%   fullName = getMfile( path, name )
%   fullName = getMfile( fullName )
%   [fullName, pathstr, FileName] = getMfile( ... )
%
%Usage
%   fullName = getMfile( name ) returns the absolute path and file name of
%      the function specified by name, uses which to determine the function
%   fullName = getMfile( path, name ) dito using path and name of the file
%       as input
%   fullName = getMfile( fullName ) dito using the full path and name as
%       input
%   [fullName, pathstr, FileName] = getMfile( ... ) also returns the path
%      and the file name seperately
%
% 18.06.2013 Mathias Hauser created (from link2mfile)
%
%See Also
%which




assert(iscellstr(varargin), 'link_to_file:fnNotString', 'File Path/ Name must be strings')

fs = filesep;

%check if input is given as fileName, path
if nargin == 2 && any(fs ==  varargin{2})
    fullName = fullfile(varargin{[2 1]});
else
    fullName   = fullfile(varargin{:});
end

ptstr = fileparts(fullName);
%if fullName has no filesep in it, assume its only the name of the function
if ~exist(ptstr, 'dir');  
    fullName = use_which( fullName );
end




if nargout > 1
    
    [pathstr, name, ext] = fileparts(fullName);
    
    allowed_ext = {'.m'};
    
    
    if strcmp( ext, '')
        ext = '.m';
        fullName = [fullName ext];
    elseif ~any(strcmp(ext, allowed_ext))
        error('link_to_file:notMfile', 'File ending must be '''' or %s, istead it was %s', [allowed_ext{:}], ext)
    end
    
    FileName = [name ext];
    
end



end

function fullName = use_which( name )


    fullName = which( name );
    
    if isempty(fullName)
        error('link_to_file:fileNTfnd', 'The file %s could not be found using ''which''', fullName)
    elseif strcmp( fullName(1:8), 'built-in')
        fullName([1:10 end]) = [];
    elseif strcmp( fullName, 'variable')
        error('link_to_file:fileISvar', 'The file %s was identified as a variable', fullName)
    elseif strfind( fullName, 'Java method')
        error('link_to_file:Java', 'The file %s', fullName)
    end



end




