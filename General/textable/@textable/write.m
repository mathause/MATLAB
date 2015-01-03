function [ output_args ] = write( obj )
%WRITE Summary of this function goes here
%   Detailed explanation goes here



if isempty(obj.placement)
    obj.placement = 'h!tbc';
end

[fileID, message] = fopen( obj.fullFile, 'W' );


cleanupObj = onCleanup( @() fclose( fileID));


if fileID < 3
    error('textable:write:invalFID', '%s', message);
end

if ~isempty(obj.TEX_root)
    wtf( ['%!TEX root = ' obj.TEX_root] );
end

wtf( ['\begin{table}[' obj.placement ']'] )
wtf( '{' )
wtf('\centering')

wtf( sprintf('\\caption{%s}', obj.caption) );

wtf( sprintf('\\label{tab:%s}', obj.label));

wtf( '\small' );

wtf( sprintf('\\begin{tabular}{%s}', obj.table_spec));
wtf( '\toprule' )

for ii = 1:obj.n_hlines
   wtf( obj.head{ii});
end


wtf('\midrule')


for ii = 1:obj.n_blines
   wtf( obj.body{ii});
end



wtf( '\bottomrule')
wtf( '\end{tabular}')
wtf( '') 
wtf( '} %end scope \centering')

if ~isempty(obj.footnote)
    wtf('\vspace*{1ex}')
    wtf(sprintf('\\footnotesize{%s}', obj.footnote))
end
wtf('\end{table}')



    function wtf( txt )
        %txt = strrep(txt, '\', '\\');
        %txt = strrep(txt, '%', '%%');
        fprintf(fileID, '%s\n', txt);
    end



end

