function [ data ] = netcdfRead( fileNames, variables )
%NETCDFREAD reads variables from fileNames
%   fileNames:  a single filename or a cell of filenames pointing to the
%               netCDF files
%   variables:  a single variable or a cell of variables
%
%   var:        a n_var x _n_files cell
%               the values of variable{2} of filename{3} is stored in
%               var{2, 3}
%
%   Mathias Hauser @ ETHZ; Dec 2012


%check number of files
if iscell(fileNames);
    n_files = length(fileNames);
else %if only one -> make a cell
    fileNames = {fileNames};
    n_files = 1;
end

%check # of variables
if iscell(variables)
    n_var = length(variables);
else %if only one -> make a cell
    variables = {fileNames};
    n_var = 1;
end

%create the output variable
data = cell(n_var, n_files);

%we want read-only access
netcdf_nowrite_id = netcdf.getConstant('NOWRITE');

%loop through files
for i_file = 1:n_files
    
    fileName = fileNames{i_file};
    %open the file
    fileName
    ncid = netcdf.open(fileName, netcdf_nowrite_id);
    
    %loop through variables
    for var_i = 1:n_var;
        %get the id of the variable
        varid = netcdf.inqVarID(ncid, variables{var_i});
        
        %retrieve the variable
        data{var_i, i_file} = netcdf.getVar(ncid, varid, 'double');
        
        %replace fill value with nan, add offset, multiply by factor
        data{var_i, i_file} = replace_val( ncid, varid, data{var_i, i_file});
          
    end
    %close the file again
    netcdf.close(ncid);
end


%if n_var == 1 && n_files == 1; var = var{1}; end

end


function data = replace_val( ncid, varid, data)

% Replace _FillValue with NaN
try
    fillValue = netcdf.getAtt(ncid,varid,'_FillValue');
    data(data==fillValue) = NaN;
    
catch me
    % Just go on if the attribute is not present.
    if ~strcmp(me.identifier,'MATLAB:imagesci:netcdf:libraryFailure')
        rethrow(me);
    end
end

% Apply scale factor if present
try
    scale_factor = netcdf.getAtt(ncid,varid,'scale_factor');
    data         = data .* double(scale_factor);
catch me
    % Just go on if the attribute is not present.
    if ~strcmp(me.identifier,'MATLAB:imagesci:netcdf:libraryFailure')
        rethrow(me);
    end
end

% Add offset if present
try
    add_offset = netcdf.getAtt(ncid,varid,'add_offset');
    data       = data + double(add_offset);
catch me
    % Just go on if the attribute is not present.
    if ~strcmp(me.identifier,'MATLAB:imagesci:netcdf:libraryFailure')
        rethrow(me);
    end
end

end



