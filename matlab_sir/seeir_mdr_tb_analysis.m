clear;


[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

% Population
% Susceptibles
SA0 = us_pop(1) / 2;
SB0 = us_pop(1) / 2;
% Latent early
LA0 = 0;
LB0 = 0;
% Latent late
LAm0 = 0;
LBm0 = 0;
% Infected
I0 = us_inc(1) / 2;
IM0 = us_inc(1) / 2;
% Recovered
T0 = 0;
TM0 = 0;

y0 = [SA0 SB0 LA0 LB0 LAm0 LBm0 I0 IM0 T0 TM0];

% Time
years = 30;

options = odeset('RelTol', 1e-5);
steps = 0:1:years-1;
[t, y] = ode45(@(t,y) seeir_mdr_tb(t, y), steps,y0,options); 

labels = {'I' 'Real'};
plot_disease(t, y0, [sum(y(:, [7 8]), 2) us_inc(1:30, :)], labels, 'Years');

