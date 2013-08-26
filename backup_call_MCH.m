function backup_call_MCH



from_root = 'C:\Users\mah\Documents';
to_root = 'H:\Backup';



Mb = 1024^2;

folders = {'CloudCam', 'Intercomparison', 'LaTex', 'MATLAB'};

max_size = [Mb, Mb, Inf, Mb];

exclude{1} = {'pictures', 'movies'};
exclude{2} = {'Last scripts_201303', 'data_for_extern', '.git'};
exclude{3} = {'Examples', '*.log', '*.aux', '*.bbl', '*.toc', '*.gz', '*.out', '*.bak', '*.blg'};
exclude{4} = {};


no_of_fold = numel(folders);

for ii = 1:no_of_fold
    
    from = fullfile(from_root, folders{ii});
    to   = fullfile(to_root, folders{ii});
    
    def.max_size = max_size(ii);
    def.exclude = exclude{ii};
    backup(from, to, def);
    
end


end