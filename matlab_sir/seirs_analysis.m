clear;

[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

% Population y0
S0 = us_pop(1);
E0 = 0;
I0 = us_inc(1);
R0 =  0;

days = 63;

y0 = [S0 E0 I0 R0];
options = odeset('RelTol', 1e-5);
steps = 0:1:days-1;
[t, y] = ode45(@(t,y) seirs(t, y), steps,y0,options); 

labels = {'I' 'Real'};
plot_disease(t, y0, [y(:, 3) us_inc], labels, 'Years');

