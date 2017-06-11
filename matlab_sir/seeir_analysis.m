clear;

[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

% Population y0
S = us_pop(1);
E1 = 0;
E2 = 0;
I = us_inc(1);
R =  0;

years = 63;

y0 = [S E1 E2 I R];
options = odeset('RelTol', 1e-5);
steps = 0:1:years-1;

[t, y] = ode45(@(t,y) seeir(t, y), steps, y0, options); 
% labels = {'S' 'E1' 'E2' 'I' 'R'};
% y = y(:, 2:3); labels = {'E1' 'E2'};
% y = y(:, 3:5); labels = {'E2' 'I' 'R'};
% y = y(:, 2:5); labels = {'E1' 'E2' 'I' 'R'};

labels = {'I' 'Real'};
plot_disease(t, y0, [y(:, 4) us_inc], labels, 'Years');

