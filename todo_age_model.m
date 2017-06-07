clear;

% Population
% Susceptibles
U = 100000;
% Exposed early
E = 0;
% Latent early
L = 0;
% Exposed late
Es = 0;
% Infected
Ap = 100;
Ae = 100;
% Recovered
R = 0;

y0 = [U E L Es Ap Ae R];

% Time
years = 10;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;
[t, y] = ode45(@(t,y) compartmentModel(t, y), steps,y0,options); 

labels = {'U' 'E' 'L' 'Es' 'Ap' 'Ae' 'R'};
plot_disease(t, y0, y, labels, 'Years');


function [ret] = compartmentModel(t, y)
    U = y(1);
    E = y(2); 
    L = y(3); 
    Es = y(4);
    Ap = y(5);
    Ae = y(5);
    R = y(6); 
    N = U + E + L + Es + Ap + Ae + R;
    
    [k, alpha, q, kL, kRp, ks, mu, r, rE, gamma, gammaE, sigma, Bt, Q0] = modelParameters();
    
    dUdt = Bt - mu * U - gamma * Q0 * (U / N) * Ap;
    dEdt = gamma * Q0 * (U / N) * Ap - (k + mu + alpha) * E;
    dLdt = alpha * (E + Es) - (mu + kL) * L - sigma * gamma * Q0 * (L / N) * Ap;
    dEsdt = sigma * gamma * Q0 * (L / N) * Ap - (ks + mu + alpha) * Es;
    dApdt = q * (k * E + ks * Es + kL * L + kRp * R) - gamma * Ap;
    dAedt = (1 - q) * (k * E + ks * Es + kL * L + kRp * R) - gammaE * Ae;
    dRdt = r * Ap + rE * Ae - (mu + kRp) * R;
    
    ret = [dUdt dEdt dLdt dEsdt dApdt dAedt dRdt]';
end


function [k, alpha, q, kL, kRp, ks, mu, r, rE, gamma, gammaE, sigma, Bt, Q0] = modelParameters()
    k = 0.01; % from E to Ap
    alpha = 0.05; % from E to L
    kL = 0.001; % from L to Es
    ks = 0.001; % Es to Active TB (ks < k)
    kRp = 0.005; % TB relapse
    
    q = 0.7; % Probability to be added to Ap
    mu = 0.01; % mortality
    d = 0.05; % mortality TB Ap
    dE = 0.1; % mortality TB Ae
    
    r = 0.5; % recovery rate I1
    rE = 0.5; % recovery rate I2
    
    gamma = (mu + d + r); % recovery or death compatments
    gammaE = (mu + dE + rE); % recovery or death compatments
    
    Bt = 0.5; % constant addition to sucsceptibles
    sigma = 0.2; % ?
    Q0 = 25; % ?
end
