function [ RHO ] = nancorr( X, Y )
%correlation for time series with NaNs
%   Detailed explanation goes here

Xmean = nanmean(X);
Ymean = nanmean(Y);

X = X - Xmean;
Y = Y - Ymean;

XY = X.*Y;

stdX = nanstd(X);
stdY = nanstd(Y);

if stdX == 0 || stdY == 0
    warning( 'The standard deviation cannont be 0 (std(X) = %f, std(Y) = %f', stdX, stdY)
end

RHO = nanmean(XY)/(stdX*stdY);


end

