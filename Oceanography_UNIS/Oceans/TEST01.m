close all
S = [30,33];
T = [-1,13];
sigma = [24,25,26];

T1 = 0;
S1 = 31.15;
T2 = 9;
S2 = 32.30;

% setting up the tsdiagram
figure
tsdiagram(S, T, sigma );
hold on
title('Exercise "Getting started with MATLAB"')
plot(S1, T1, 'r*')
text(S1, T1, '  -original #1')
plot(S2, T2, 'r+')
text(S2, T2, '  -original #2')

% plotting the 1:2 mix
m1 = 1;
m2 = 2;
T = (m1 * T1 + m2 * T2) / (m1 + m2);
S = (m1 * S1 + m2 * S2) / (m1 + m2);

plot(S, T, 'g*')
text(S, T, '  -the 1:2 mix')
% plotting the 1:1 mix
m1 = 1;
m2 = 1;
T = (m1 * T1 + m2 * T2) / (m1 + m2);
S = (m1 * S1 + m2 * S2) / (m1 + m2);

plot(S, T, 'b*')
text(S, T, '  -the 1:1 mix')

% plotting the 2:1 mix
m1 = 2;
m2 = 1;
T = (m1 * T1 + m2 * T2) / (m1 + m2);
S = (m1 * S1 + m2 * S2) / (m1 + m2);

plot(S, T, 'k*')
text(S, T, '  -the 2:1 mix')

% finished
hold off