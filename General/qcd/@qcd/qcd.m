classdef qcd
    properties
        time
        data
        
    end
    
    properties (Hidden = true, SetAccess = protected, Transient = true)
        time_hash
    end
    
    properties %(Transient = true)
        flag  
        
    end
    
    
    properties (Transient = true, SetAccess = protected)
        %t_hash
        period
        perstr
        flag_intern
        
        flag_unique
        
        ndat
    end
    
    
    
    
    
    
    
    methods
        function obj = qcd(varargin)
            % Constructor
            
            if nargin == 0
                
            elseif nargin == 1 && size(varargin{1},2) == 3
                
                obj.time = varargin{1}(:,1);
                
                obj.data = varargin{1}(:,2);
                obj.flag = int8(varargin{1}(:,3));
                obj.ndat = length( obj.time );
            elseif nargin == 3
                obj.time = varargin{1}(:,1);
                obj.data = varargin{2};
                obj.flag = int8(varargin{3});
                obj.ndat = length( obj.time );
            end
            qcd_check_integrity( obj );
        end
        
        
%         function t_hash = get.t_hash(obj)
%             t_hash = obj.time_hash;
%         end
        
        
%         function period = get.period(obj)
%             period(1) = obj.time(1);
%             period(2) = obj.time(end);
%         end
%         
%         
%        function perstr = get.perstr(obj)
%             perstr = sprintf('%s to %s', datestr(obj.time(1), 0), datestr(obj.time(end), 0));
%         end
        
        
        function obj = set.flag( obj, flag)
            if isempty( obj.flag ); ci = false; else ci = true; end

            %obj.flag = flag;
            
            flag_uq = unique(flag);
            obj.flag_unique = flag_uq;
            if numel(flag_uq) == 1
                obj.flag_intern = flag_uq;
            else
                obj.flag_intern = flag;
            end

            
            if ci
                qcd_check_integrity( obj, 'flag' );
            end
            
        end
        
        
        function flag = get.flag( obj )
            
            
           if isequal(size(obj.flag_intern), [1 1])
               flag = obj.flag_intern.*ones(size(obj.time,1),1, 'int8');
           else
               flag = obj.flag_intern;
           end
        end
        
        
        
        function obj = set.time(obj, time)
            
            if isempty( obj.time ); ci = false; else ci = true; end
            
            [time, hash] = common_time( time );
            
            obj.time = time;
            
            obj.time_hash = hash; %#ok<MCSUP>
            
             obj.period(1) = obj.time(1);
             obj.period(2) = obj.time(end);
             obj.perstr = sprintf('%s to %s', datestr(obj.time(1), 0), datestr(obj.time(end), 0));
            
            
            
            if ci
                qcd_check_integrity( obj, 'time' );
            end
            
            
        end
    end
    
end