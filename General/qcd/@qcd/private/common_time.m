function [ time, hash ] = common_time( time )
%COMMON_TIME assigns time to a common time (i.e. a handle)


mlock;

persistent qcd_time time_hash


hash = [];
if isempty(qcd_time)
    
    assign_time( 1 );
    
    return
else
    
    
    sz = size(qcd_time);
    
    
    
    for ii = 1:sz
        
        if isequal(qcd_time{ii}, time)
            time = qcd_time{ii};
            %time_hash = time_hash{ii};
            hash = time_hash{ii};
            return
            
        end
        
    end
    
    
    
    
    
    
end


IDX = length( qcd_time ) + 1;

assign_time( IDX );


function assign_time( IDX )

    
    assert( all(diff(time) > 0), 'qcd:c_t:time_not_monotonic',...
        'The time vector must be monotonically inceasing');
    assert( ~any(isnan(time)), 'qcd:c_t:time_NaN',...
        'The time vector may not contain NaN''s.');
    
    
    qcd_time{IDX} = time;
    %obj.time = time;
    
    time_hash{IDX} = CalcMD5(time, [], 'Dec');
    
    
    time = qcd_time{IDX};
    hash = time_hash{IDX};

end



end

