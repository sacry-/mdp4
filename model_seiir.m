clear;

% Population y0
S0 = 200000;
E0 = 0;
If0 = 1;
Is0 = 0;
R0 =  0;

years = 100;

y0 = [S0 E0 If0 Is0 R0];
options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;

[t, y] = ode45(@(t,y) seiir_model(t, y), steps,y0,options); 
y = y(:, 3:5); labels = {'If' 'Is' 'R'};
%y = y(:, 3:4); labels = {'If' 'Is'};

plot_disease(t, y0, y, labels, 'Years');

% Models
function [ ret ] = seiir_model(t, y)
    S = y(1); 
    L = y(2); 
    If = y(3); 
    Is = y(4); 
    R = y(5);
    
    [b, mu, p, nu, f, q, omega, mui, c, beta] = seiirParams();
    lambda = beta * If;
    
    dSdt = b - lambda * S - mu * S;
    dLdt = (1 - p) * lambda * S - (nu + mu) * L;
    dIfdt = p * f * lambda * S + q * nu * L + omega * R - (mu + mui + c) * If;
    dIsdt = p * (1 - f) * lambda * S + (1 - q) * nu * L + omega * R - (mu + mui + c) * Is;
    dRdt = c * (If + Is) - (2 * omega + mu) * R;
    
    ret = [dSdt dLdt dIfdt dIsdt dRdt]';
end

function [b, mu, p, nu, f, q, omega, mui, c, beta] = seiirParams()
    b = 4400;
    mu = 0.0222;
    p = 0.05;
    nu = 0.00256;
    f = 0.70;
    q = 0.85;
    omega = 0.005;
    mui = 0.139;
    c = 0.058;
    beta = 0.00005;
end


