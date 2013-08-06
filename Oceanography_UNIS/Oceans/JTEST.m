disp('------------------- New Run -------------------------')
% Constants
deltaA = 1.3;
deltaI = 950;
Ch = 2 * 10^-3;
Cp = 1004;
Lf = 3.3 * 10^5;
cw = 4000;

% "My" variables
Va = 10; % air velocity [m/s]
Ta = -20; % air temperature [ C]
To = 0;  % starting surface water temperature [ C]
So = 34.5;  % starting salinity [  ]
D = 100;  % Depth [m]
[crap, startDensity] = swstate(So, To, 0);
startDensity = startDensity +1000;
disp(strcat('startDensity = ',num2str(startDensity)))

% FREEZING
disp('--- FREEZING ---')
Qs = deltaA * Ch * Cp * Va * (Ta - To);
disp(strcat('Qs = ',num2str(Qs)))

dHdT = Qs / (-Lf * deltaI);
disp(strcat('dh/dt = ',num2str(dHdT)))

dSdT = So * dHdT / D;
disp(strcat('dS/dt = ',num2str(dSdT)))

tid1 = 0;
tid2 = 10 * 60 * 60;
SA = So;
SB= SA + dSdT * (tid2- tid1);

[svan, sigmaA] = swstate(SA, -1.9, 0, 'dT');
[svan, sigmaB] = swstate(SB, -1.9, 0, 'dT');
%disp(strcat('volume anomaly = ',num2str(svan), ' (kg/(m^3 * le-8)'))
disp(strcat('densitet-1000 (sigmaT-A) = ',num2str(sigmaA), ' (kg/m^3)'))
disp(strcat('densitet-1000 (sigmaT-B) = ',num2str(sigmaB), ' (kg/m^3)'))

densitet = startDensity + (sigmaA + sigmaB)/2 * (SB - SA);
disp(strcat('Density after freezing = ',num2str(densitet)))
disp(strcat('difference = ',num2str(densitet - startDensity)))

% COOLING
disp('--- COOLING ---')
dTdT = Qs / (D * cw * startDensity);
disp(strcat('dt/dt = ',num2str(dTdT)))


% Jamførelse

T1 = 0;
T2= T1 + dTdT * (tid2- tid1);

[svan, sigma1] = swstate(So, T1, 0, 'dT');
%disp(strcat('volume anomaly = ',num2str(svan), ' (kg/(m^3 * le-8)'))
disp(strcat('densitet-1000 (sigmaT) før T1 = ',num2str(sigma), ' (kg/m^3)'))

[svan, sigma2] = swstate(So, T2, 0, 'dT');
%disp(strcat('volume anomaly = ',num2str(svan), ' (kg/(m^3 * le-8)'))
disp(strcat('densitet-1000 (sigmaT) før T2 = ',num2str(sigma), ' (kg/m^3)'))

densitet = startDensity + (sigma1 + sigma2)/2 * (T2 - T1);
disp(strcat('Density after cooling = ',num2str(densitet)))
disp(strcat('difference = ',num2str(densitet - startDensity)))

disp('------------------ End of Run -----------------------')