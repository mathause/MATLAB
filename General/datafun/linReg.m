function [p R] = linReg( X, Y )
%Calculates a linear regression
%   p = [m q] (can be used with polyval)
%   m: Steigung
%   q: Achsenabschnitt
%   S: Statistics
%   S.R = R^2
%   S.Res sum of residuals
%   
%   Requires the Statistics Toolbox;   
%
%   Mathias Hauser
%   Version 1.0

X_m = nanmean(X);
Y_m = nanmean(Y);

sigma_XY = nanmean(X.*Y) - X_m * Y_m;

sigmaX2 = nanmean(X.^2) - X_m^2;
sigmaY2 = nanmean(Y.^2) - Y_m^2;



m = sigma_XY/(sigmaX2);

q = Y_m - m*X_m;

p = [m q];


%Alternatively
% p = polyfit(X,Y);


%Residuals
Y_eval = polyval(p,X);
Residuals = Y-Y_eval;

R_squared = (sigma_XY)^2/(sigmaX2*sigmaY2);
%Alternatively
% rho = corr(X,Y);
% R_squared = rho^2;



R = R_squared;
% S.Res = Residuals;


%Teststatistic
% H_0: m = 0;
% H_A: m ~= 0;

n = length(X);


% sigma_res2 = 1/(n-2)*sum(Residuals.^2);

% sigma_m2 = sigma_res2/sum((Y-Y_m).^2);

% T = m/sqrt(sigma_m2)

% p_Value = (1-tcdf(abs(T),n-2)) * 2


% figure(1)
% subplot(2,2,1)
% qqplot(Residuals)
% 
% subplot(2,2,2)
% hist(Residuals,min(n/5,20))
% 
% subplot(2,2,3)
% plot(Y,Residuals,'+')


end