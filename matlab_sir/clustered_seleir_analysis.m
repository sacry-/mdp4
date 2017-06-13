clear;


% Clusterd model
% Two clusters, one for general population, second for highly endemic
[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

r1 = (40 / 100);
r2 = 1 - r1;

% Population
% Susceptibles
S10 =  us_pop(1) * r1;
S20 = us_pop(1) * r2;
% Exposed early
E10 = 10;
E20 = 10;
% Latent early
L10 = 5000;
L20 = 5000;
% Exposed late
Es10 = 5000;
Es20 = 5000;
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

plots = 4;
if plots == 1
    c1 = {'E1' 'L1' 'Es1' 'R1' 'Ap'};
    plot_disease(t, y0(:, 2:6), y(:, 2:6), c1, 'Years');
    c2 = {'E2' 'L2' 'Es2' 'R2' 'Ae'};
    plot_disease(t, y0(:, 8:12), y(:, 8:12), c2, 'Years');
elseif plots == 2
    SE = { 'S1' 'E1' 'S2' 'E2' };
    plot_disease(t, y0(:, 2:6), y(:, [1 2 7 8]), SE, 'Years');
    IR = { 'I1' 'R1' 'I2' 'R2' };
    plot_disease(t, y0(:, 2:6), y(:, [5 6 11 12]), IR, 'Years');
elseif plots == 3
    SE = { 'S' 'E' 'L' 'Es' 'I' 'R' };
    y1 = y(:,1:6);
    y2 = y(:,7:12);
    plot_disease(t, y0(:, 2:6), y1 + y2, SE, 'Years');
elseif plots == 4
    labels = { 'Infected' 'US 1953 - 2015' };
    plot_disease(t, y0, [sum(y(:, [5 11]), 2) us_inc], labels, 'Years');
    title("Clustered SELEIR");
end
