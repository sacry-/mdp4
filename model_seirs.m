clear;

% Population y0
S0 = 100;
E0 = 20;
I0 = 5;
R0 =  5;

days = 25;

y0 = [S0 E0 I0 R0];
options = odeset('RelTol', 1e-5);
steps = 0:0.01:days;
[t, y] = ode45(@(t,y) seirs_model(t, y), steps,y0,options); 

labels = {'S' 'E' 'I' 'R'};
plot_disease(t, y0, y, labels, 'Days');


function [ ret ] = seirs_model(t, y)
    S = y(1); 
    E = y(2); 
    I = y(3); 
    R = y(4);
    N = S + E + I + R;
    
    [beta, gamma, sigma, mu, nu, rho] = modelParams();
    
    exposure = beta * (S * I / N);
    vaccinate = nu * S;
    infect = sigma * E;
    recovery = gamma * I;
    acquiescence = rho * R;
    
    mortS = mu * (N - S);
    dSdt =  acquiescence + mortS - exposure - vaccinate;
    mortE = mu * E;
    dEdt = exposure - infect - mortE;
    mortI = mu * I;
    dIdt = infect - recovery - mortI;
    mortR = mu * R;
    dRdt = recovery + vaccinate - acquiescence - mortR;
    
    ret = [dSdt dEdt dIdt dRdt]';
end

function [beta, gamma, sigma, mu, nu, rho] = modelParams()
    % The parameter controlling how often a susceptible-infected 
    % contact results in a new exposure.
    beta = 0.9;
    % The rate an infected recovers and moves into 
    % the resistant phase.
    gamma = 0.2;
    % The rate at which an exposed person becomes infective.
    sigma = 0.5;
    % The natural mortality rate (this is unrelated to disease). 
    % This models a population of a constant size.
    mu = 0;
    % The rate at which susceptible become vaccinated.
    nu = 0;
    % The rate at which resistant people lose their 
    % resistance and become susceptible again.
    rho = 0.05;
end