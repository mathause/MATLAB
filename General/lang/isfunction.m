function [tf] = isfunction( fct )
%isfunction true for functions (false for scripts)
%
%
%
% 11.06.2013 Mathias Hauser     created

if any( strcmp(fct, '.'))
    if strcmp(fct(end-1:end), '.m' )        
    else
        error('Wrong File ending')
    end
else
    fct = [fct '.m'];
end


%[fullName, pathstr, FileName] = getMfile(varargin)


%'function' in ascii code see char(fc)
fc = [102   117   110    99   116   105   111   110];


kind = exist( fct, 'file');

switch kind
    
    case 0
        error('isfunction:not_ex', 'The file fct (%s) does not exist', fct);
    case 2
        fid = fopen( fct );
        str = fread(fid, [1 8]);
        tf = isequal(str, fc);
        
    case {3,4,5,6}
        tf = true;
    otherwise
        tf = false;
        
end










end