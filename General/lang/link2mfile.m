function link_str = link2mfile( varargin ) %bla
%LINK2MFILE returns link to the specified file (as do warnigs and errors)
%
%Syntax
%   LINK2MFILE( fullPath )
%   LINK2MFILE( path, fileName )
%   LINK2MFILE( fileName )
%   LINK2MFILE( ..., line_no )
%   link_str = LINK2MFILE( ... )
%
%Usage
%   LINK2MFILE( fullPath ) displays a link to the file specified with
%       the absolute path
%   LINK2MFILE( path, fileName ) dito giving path and name of the file
%      separatly
%   LINK2MFILE( fileName ) uses 'which' to determine the file
%   LINK2MFILE( ..., line_no ) adds a link to open the file at a
%       specific line
%   link_str = LINK2MFILE( ... ); returns a string to be used with disp
%       or fprintf (add '\n')
%
%
%Example 1
%   create a link and display it
%   path = fullfile(matlabroot, 'toolbox', 'matlab', 'datafun');
%   file = 'std';
%   link_str = LINK2MFILE( path, file );
%   fprintf(1,'To open the file, press the link: %s\n', link_str);
%   LINK2MFILE( path, file, 32 )
%
%Example 2
%   link_str = LINK2MFILE( 'std' )
%
%Version History
%   31.05.2013 Mathias Hauser   created
%   17.06.2013 Mathias Hauser   rewritten
%
%See Also
%error | warning | fprintf | getMfile

narginchk(1,3)

is_num = cellfun( @isnumeric, varargin); %assume numeric input is line_no
if any(is_num)
    assert( sum(is_num) == 1, 'link_to_file:muliplLineNo', ...
        'Please specify only one numeric input for line_no');
    lineNo = varargin{is_num};
    validateattributes(lineNo, {'numeric'}, {'scalar', 'integer', 'real'});
    has_lineNo = true;
else
    has_lineNo = false;
    %line_no = 1;
end


[fullFile, pathstr, fileName] = getMfile(varargin{~is_num});

if has_lineNo
    link_str_int = sprintf('<a href="matlab:helpUtils.errorDocCallback(''%s'', ''%s'', 11)" style="font-weight:bold">%s</a> (<a href="matlab: opentoline(''%s'',%i,0)">line %i</a>)', fileName, fullFile, fileName, fullFile, lineNo, lineNo);    
else
    link_str_int = sprintf('<a href="matlab:helpUtils.errorDocCallback(''%s'', ''%s'', 11)" style="font-weight:bold">%s</a>', pathstr, fullFile, fileName);
end

if nargout == 0
    fprintf('%s\n', link_str_int);
else
    link_str = link_str_int;
end

end



