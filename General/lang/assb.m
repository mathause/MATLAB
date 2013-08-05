function assb( variable, varargin )
%assb does what assignin('base',...) does
%
%Syntax
% assb(variable, ...)
% assb(variable, 'name', ...) 
%
%Description
% assb(variable, ...), assigns the variable under its name in the
% 'Workspace'. If the variable has an empty inputname ('', e.g. using 
% struct.field, var{1} or 5), it assigns it unter the name 'var', 'var1' etc.
%
% assb(variable, 'name', ...) saves variable under 'name'
%
% The assb function can take as many inputs as you like and the input of a
% variable may or may not be followed by a 'name'.
% Of course assb does only make sense when called from a function.
%
%CAUTION: variables in the workspace are overwritten
%
%Examples   
% variable = 5; variable1 = 1; struct.field = 7;
% assb(variable, variable1, 'OtherName', struct.field)
%
% Mathias Hauser v3.8
%
%See Also
% assignin

%Version History
%   2010  Version 2.0
%   Update 2013.05.23 v 2.0 -> v 3.0
%       no inputname if struct-field as input
%       self generated var names are now updated
%   18.06.2013  Mathias Hauser v3.8 added caller info

%check input


narginchk(1, Inf);

st = dbstack('-completenames');

assignin('base', 'st', st)

if length(st) > 1
    try
        link_str = link2mfile(st(2).file, st(2).line);
        link_str = [' (in: ' link_str ')'];
    catch exception %#ok<NASGU>
        link_str = sprintf(' (in: %s (line %i))', st(2).name, st(2).line );
        %rethrow(exception)
    end
else
    link_str = '';
end

%make one cell array of 'variable' and optional variables in varargin
variable = [{variable}, varargin];

no_of_vars = length(variable); %number of inputs

ii = 1; %control structure

%to get the names of the variables in the workspace
%existing_vars = evalin('base', 'who');

existing_vars = {};
all_var_names = {};
while ii <= no_of_vars %loop until the last entry is assigned
    if  ii + 1 <= no_of_vars && ischar(variable{ii + 1}) && strcmp(inputname(ii + 1),'')%if a name is given
        var_name = variable{ii + 1};
        var = variable{ii};
        
        ii = ii + 2; %two inputs have been 'used'
    else %no name given
        inputname(ii);
        if strcmp(inputname(ii),'') %if a only numerical value is given (not a variable)
            var_name = genvarname('var',existing_vars); %name it var
            var = variable{ii};
            existing_vars{end + 1} = var_name; %#ok
            warning('assb:NoInputName','Input name could not be determined! -> saved under %s', var_name);
        else %a variable is given as input
            
            %assignin('base',num2str(inputname(ii)),variable{ii});
            var_name = inputname(ii);
            var = variable{ii};
            
        end
        ii = ii + 1;
    end
    
    
    all_var_names = [all_var_names {var_name}]; %#ok<AGROW>
    assignin('base',var_name,var);
end

formstr = repmat( ' %s,', 1, length(all_var_names));
fprintf(1, ['assb:' formstr(1:end-1) '%s\n'], all_var_names{:}, link_str);

end
