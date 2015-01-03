function [ RMSE ] = rsme( obs, pred )
%RSME returns root mean squared error
%
%To do: also calculate slope and rho
%
% Mathias Hauser
% 10.06.2013 mah created



RMSE = sqrt(nanmean((obs - pred).^2));






end

