function [ ret ] = seirs(t, y)
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
    
    dSdt =  acquiescence + mu * (N - S) - exposure - vaccinate;
    dEdt = exposure - infect - mu * E;
    dIdt = infect - recovery - mu * I;
    dRdt = recovery + vaccinate - acquiescence - mu * R;
    
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
