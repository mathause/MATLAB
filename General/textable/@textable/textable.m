classdef textable
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        pt %path
        fn %filename
        
        fullFile %pt + fn
        
        
        table_spec
        
        placement
        
        n_col
        n_blines
        n_hlines
        
        TEX_root
        
        caption
        label
        
        head
        body
        
        footnote
        
        
        formSpec
    end
    
    methods
        
        function obj = textable(varargin)
            
            obj.fullFile = varargin{1};
            obj.table_spec = varargin{2};
            
            
            obj.body = {}; obj.n_blines = 0;
            obj.head = {}; obj.n_hlines = 0;
            
            obj.TEX_root = [];
            
        end
        
        function obj = midrule(obj)
            obj.n_blines = objj.blines + 1;
            obj.body{obj.n_blines} = '\midrule';
            
        end
        
        
        function obj = add_line(obj, varargin)
            obj.n_blines = obj.n_blines + 1;
            
            obj.body{obj.n_blines} = sprintf( obj.formSpec, varargin{:});
            
        end
        
        function obj = add_head(obj, txt)
            obj.n_hlines = obj.n_hlines + 1;
            
            obj.head{obj.n_hlines} = txt;
            
        end
        
    end
    
end

