function [ output_args ] = bk_md5( input_args )
%BK_MD5 Summary of this function goes here
%   Detailed explanation goes here





folder =  'C:\Users\mah\Documents\MATLAB';


files = [];

files = lst_all(folder, files);


assb(files)



end

function files = lst_all(folder, files)

list = dir(folder);

%get rid of 'folder' ('.') and folder above ('..')
sel = strcmp({list(:).name}, {'.'}) | strcmp({list(:).name}, {'..'});
list(sel) = [];



isdir = [list.isdir];


files = [files; list(~isdir)];

pt = find(isdir);
for ii = pt
    f = fullfile(folder, list(ii).name);
    files = lst_all(f , files);

end

end
