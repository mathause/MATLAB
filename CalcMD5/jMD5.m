function [ MD5 ] = jMD5( data )
%JMD5 Summary of this function goes here
%   Detailed explanation goes here

x = java.security.MessageDigest.getInstance('MD5');
x.update(data);
MD5 = double(typecast(x.digest, 'uint8'))';



end

