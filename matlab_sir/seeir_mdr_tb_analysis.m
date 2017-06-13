clear;


[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

% Population
% Susceptibles
SA0 = 1000;
SB0 = 100000;
% Latent early
LA0 = 0;
LB0 = 0;
% Latent late
LAm0 = 0;
LBm0 = 0;
% Infected
I0 = 5;
IM0 = 5;
% Recovered
T0 = 0;
TM0 = 0;

y0 = [SA0 LA0 LAm0 I0 T0 SB0 LB0 LBm0 IM0 TM0];

% Time
years = 10;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years-1;
[t, y] = ode45(@(t,y) seeir_mdr_tb(t, y), steps,y0,options); 

labels = {'SA' 'LA' 'LAm' 'I' 'T' 'SB' 'LB' 'LBm' 'IM' 'TM'};
plot_disease(t, y0, y, labels, 'Years');

