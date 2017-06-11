clear;


% Clusterd model
% Two clusters, one for general population, second for highly endemic
[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

r1 = (40 / 100);
r2 = 1 - r1;

% Population
% Susceptibles
S10 = us_pop(1) * r1;
S20 = us_pop(1) * r2;
% Exposed early
E10 = 0;
E20 = 0;
% Latent early
L10 = 0;
L20 = 0;
% Exposed late
Es10 = 0;
Es20 = 0;
% Infected
I10 = us_inc(1) * r1;
I20 = us_inc(1) * r2;
% Recovered
R10 = 0;
R20 = 0;

y0 = [S10 E10 L10 Es10 I10 R10 S20 E20 L20 Es20 I20 R20];

% Time
years = 63;

options = odeset('RelTol', 1e-5);
steps = 0:1:years-1;
[t, y] = ode45(@(t,y) clustered_seleir(t, y), steps,y0,options); 

plots = 2;
if plots == 1
    c1 = {'U1' 'E1' 'L1' 'Es1' 'R1' 'Ap'};
    plot_disease(t, y0(:, 1:6), y(:, 1:6), c1, 'Years');
    c2 = {'U2' 'E2' 'L2' 'Es2' 'R2' 'Ae'};
    plot_disease(t, y0(:, 7:12), y(:, 7:12), c2, 'Years');
elseif plots == 2
    labels = { 'A' 'Real' };
    plot_disease(t, y0, [sum(y(:, [5 11]), 2) us_inc], labels, 'Years');
end
