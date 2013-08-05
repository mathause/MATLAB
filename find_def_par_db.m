function [ idx ] = find_def_par_db( def_par_db, param )
%FIND_DEF_PAR_DB finds position of param in def_par_db
%
%Syntax
%   idx = find_def_par_db( def_par_db, param )
%
%Version History
%   04.07.2013  mah     created


kk = 1;
for ii = 1:numel(def_par_db)

    k = strfind( def_par_db(ii).name, param);
    
    if ~isempty(k)
       fprintf( 'Found %s at %i\n', def_par_db(ii).name, ii); 
       idx(kk) = ii; %#ok<AGROW>
       kk = kk + 1;
    end

end



end

