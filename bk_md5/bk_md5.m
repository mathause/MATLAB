function [ output_args ] = bk_md5( input_args )
%BK_MD5 Summary of this function goes here
%   Detailed explanation goes here





%folder =  'C:\Users\mah\Documents\MATLAB';

folder =  'C:\Users\mah\Documents';

files = [];

ignore = {}; %{'.git'};

files = lst_all(folder, files, ignore);


assb(files)



end

function files = lst_all(folder, files, ignore)

list = dir(folder);

%get rid of 'folder' ('.') and folder above ('..')
sel = strcmp({list(:).name}, {'.'}) |  strcmp({list(:).name}, {'..'});
list(sel) = [];

sel = false(size(list))';

for ii = 1:length(ignore);
    strcmp({list(:).name}, ignore{ii})
    sel = sel | strcmp({list(:).name}, ignore{ii});
end
list(sel) = [];

isdir = [list.isdir];

[list(:).fullname]=deal([]);
list = list';


for ii = find(~isdir)
    
   list(ii).fullname = fullfile(folder, list(ii).name); 
    
    
end



files = [files, list(~isdir)];

pt = find(isdir);
for ii = pt
    f = fullfile(folder, list(ii).name);
    files = lst_all(f , files, ignore);

end

end
