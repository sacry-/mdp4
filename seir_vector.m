clear;

% Population y0
S0 = 100;
E0 = 20;
I0 = 5;
R0 =  5;

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

paramKeys = {'beta' 'gamma' 'sigma' 'mu' 'nu' 'rho'};
paramValues = {beta gamma sigma mu nu rho};
init = containers.Map(paramKeys, paramValues);

y0 = [S0 E0 I0 R0];
options = odeset('RelTol', 1e-5);
steps = 0:0.01:100;
[t, y] = ode45(@(t,y) seirVectorModel(t, y, init), steps,y0,options); 

S = y(:,1);
E = y(:,2);
I = y(:,3);
R = y(:,4);

figure; hold on
linewidth = 2;
a1 = plot(t,S, 'color', [1 .7 0], 'LineWidth', linewidth); M1 = "S";
a2 = plot(t,E, 'color', [0 .5 .9], 'LineWidth', linewidth); M2 = "E";
a3 = plot(t,I, 'color', [.8 0 0], 'LineWidth', linewidth); M3 = "I";
a4 = plot(t,R, 'color', [0 .5 0], 'LineWidth', linewidth); M4 = "R";
legend([a1, a2, a3, a4], [M1, M2, M3, M4]);
ylabel('Populations')
xlabel('Time')

function [ ret ] = seirVectorModel(t, y, params)
    S = y(1); 
    E = y(2); 
    I = y(3); 
    R = y(4);
    N = S + E + I + R;
    
    beta = params('beta');
    gamma = params('gamma');
    sigma = params('sigma');
    mu = params('mu');
    nu = params('nu');
    rho = params('rho');
    
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
