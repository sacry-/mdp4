clear;

path = './data/measles.csv';
measles = readtable(path);

S = 10000;
I = 1;
R = 0;
D1 = 0;
D2 = 0;

y0 = [S I R D1 D2];

% Time
years = 100;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;
[t, y] = ode45(@(t,y) sir(t, y), steps,y0,options); 

labels = {'S' 'I' 'R' 'D1' 'D2'};
plot_disease(t, y0, y, labels, 'Years');


function [ret] = sir(t, y)
    S = y(1);
    I = y(2);
    R = y(3);
    N = S + I + R;
    
    [beta, gamma, d, r1, r2, mu] = sirParams();
    dSdt = (mu * (N - S)) + (N * (0.036 / 365)) - beta * ((S * I) / N) + r2 * R;
    dIdt = beta * ((S * I) / N) - gamma * I - d * I + r1 * R - mu * I;
    dRdt = gamma * I - r1 * R - r2 * R - mu * R;
    dD1dt = d * I;
    dD2dt = mu * I + mu * R + mu * S;
    
    ret = [dSdt dIdt dRdt dD1dt dD2dt]';
end

function [beta, gamma, d, r1, r2, mu] = sirParams()
    beta = 0.9; % How many susceptible?
    gamma = 0.2;  % How many recover?
    d = 0.05;  % How many die?
    r1 = 0.05;  % Reinfection
    r2 = 0.95;  % Reinfection
    mu = 0.01;
end