clear;

% Population y0
S = 200000;
E1 = 0;
E2 = 0;
I = 1;
R =  0;

years = 100;

y0 = [S E1 E2 I R];
options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;

[t, y] = ode45(@(t,y) seeir_model(t, y), steps, y0, options); 
% y = y(:, 2:3); labels = {'E1' 'E2'};
% y = y(:, 3:5); labels = {'E2' 'I' 'R'};
y = y(:, 2:5); labels = {'E1' 'E2' 'I' 'R'};

plot_disease(t, y0, y, labels, 'Years');

function [ ret ] = seeir_model(t, y)
    S = y(1); 
    E1 = y(2); 
    E2 = y(3); 
    I = y(4); 
    R = y(5);
    
    [b, mu, p1, p2, k1, k2, mui, beta, r] = seeirParams();
    
    dSdt = b - beta * I * S - mu * S;
    dE1dt = p1 * beta * I * S - (k1 + mu) * E1;
    dE2dt = p2 * beta * I * S - (k2 + mu) * E2;
    dIdt = (k1 * E1 + k2 * E2) - (r + mu + mui) * I;
    dRdt = r * I - mu * R;
    
    ret = [dSdt dE1dt dE2dt dIdt dRdt]';
end

function [b, mu, mui, p1, p2, k1, k2, beta, r] = seeirParams()
    b = 500;
    mu = 0.0222;
    mui = 0.139;
    p1 = 0.3;
    p2 = 0.7;
    k1 = 0.475;
    k2 = 0.0025;
    beta = 0.00005;
    r = 0.058;
end