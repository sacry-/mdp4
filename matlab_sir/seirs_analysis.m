clear;

% Population y0
S0 = 100;
E0 = 0;
I0 = 1;
R0 =  0;

days = 100;

y0 = [S0 E0 I0 R0];
options = odeset('RelTol', 1e-5);
steps = 0:1:days-1;
[t, y] = ode45(@(t,y) seirs(t, y), steps,y0,options); 

labels = {'S' 'E' 'I' 'R'};
plot_disease(t, y0, y, labels, 'Years');

