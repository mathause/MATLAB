function str = bytes2str(NumBytes)
% BYTES2STR converts integer bytes to scale-appropriate size
%
%See Also
%ByteSize
scale = floor(log(NumBytes)/log(1024));
switch scale
    case 0
        str = sprintf('%.0f b',NumBytes);
    case 1
        str = sprintf('%.2f kb',NumBytes/(1024));
    case 2
        str = sprintf('%.2f Mb',NumBytes/(1024^2));
    case 3
        str = sprintf('%.2f Gb',NumBytes/(1024^3));
    case 4
        str = sprintf('%.2f Tb',NumBytes/(1024^4));
    case -inf
        % Size occasionally returned as zero (eg some Java objects).
        str = 'Not Available';
    otherwise
       str = 'Over a petabyte!!!';
end
end