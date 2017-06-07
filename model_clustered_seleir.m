clear;

% Clusterd model
% Two clusters, one for general population, second for highly endemic

% Population
% Susceptibles
S10 = 1000000;
S20 = 1000000;
% Exposed early
E10 = 0;
E20 = 0;
% Latent early
L10 = 0;
L20 = 0;
% Exposed late
Es10 = 0;
Es20 = 0;
% Infected
I10 = 1;
I20 = 0;
% Recovered
R10 = 0;
R20 = 0;

y0 = [S10 E10 L10 Es10 I10 R10 S20 E20 L20 Es20 I20 R20];

% Time
years = 10;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;
[t, y] = ode45(@(t,y) clustered_seleir_model(t, y), steps,y0,options); 

c1 = {'U1' 'E1' 'L1' 'Es1' 'R1' 'Ap'};
c2 = {'U2' 'E2' 'L2' 'Es2' 'R2' 'Ae'};

plot_disease(t, y0(:, 1:6), y(:, 1:6), c1, 'Years');
plot_disease(t, y0(:, 7:12), y(:, 7:12), c2, 'Years');

function [ret] = clustered_seleir_model(t, y)
    % Cluster one
    U1 = y(1);
    E1 = y(2); 
    L1 = y(3); 
    Es1 = y(4); 
    Ap = y(5);
    R1 = y(6); 
    N1 = sum(y(1:6));
    
    % Cluster two
    U2 = y(7);
    E2 = y(8); 
    L2 = y(9); 
    Es2 = y(10); 
    Ae = y(11);
    R2 = y(12); 
    N2 = sum(y(7:end));
    
    [k, alpha, q, kL, kRp, ks, mu, beta, r, rE, gamma, gammaE, ~, ~, sigma] = modelParameters();
    B = 0.012;
    
    SF = F(U1, U2, N1, N2, E2, Es2, L2, R2);
    dS1dt = -(beta + gamma) * U1 + SF;
    EF = F(E1, E2, N1, N2, E2, Es2, L2, R2);
    dE1dt = beta * U1 - (alpha + gamma) * E1 + EF;
    LF = F(L1, L2, N1, N2, E2, Es2, L2, R2);
    dL1dt = alpha * (E1 + Es1) - (sigma * beta + gamma) * L1 + LF;
    EsF = F(Es1, Es2, N1, N2, E2, Es2, L2, R2);
    dEs1dt = sigma * beta * L1 - (alpha + gamma) * Es1 + EsF;
    RF = F(R1, R2, N1, N2, E2, Es2, L2, R2);
    dR1dt = -gamma * R1 + RF;
    dApdt = q * (k * E2 + ks * Es2 + kL * L2 + kRp * R2) - gamma * Ap;

    c1 = [dS1dt dE1dt dL1dt dEs1dt dApdt dR1dt];
    
    dS2dt = B - mu * U2 + gamma * U1 - SF;
    dE2dt = -(mu + alpha + k) * E2 + gamma * E1 - EF;
    dL2dt = alpha * (E2 + Es2) + gamma * L1 - (mu + kL) * L2 - LF;
    dEs2dt = gamma * Es1 - (ks + mu + alpha) * Es2 - EsF;
    dAedt = (1 - q) * (k * E2 + ks * Es2 + kL * L2 + kRp * R2) - gammaE * Ae;
    dR2dt = r * Ap + rE * Ae + gamma * R1 - (mu + kRp) * R2 - RF;
    
    c2 = [dS2dt dE2dt dL2dt dEs2dt dAedt dR2dt];
    
    ret = [c1 c2]';
end

function [ret] = F(X1, X2, N1, N2, E2, Es2, L2, R2)
    [k, ~, q, kL, kRp, ~, ~, ~, ~, ~, ~, ~, n, p, ~] = modelParameters();
    ret = q * (k * E2 + k * Es2 + kL * L2 + kRp * R2) * n * (p * X1 / N1 + (1 - p) * X2 / N2);
end

function [k, alpha, q, kL, kRp, ks, mu, beta, r, rE, gamma, gammaE, n, p, sigma] = modelParameters()
    k = 0.001; % from E to Ap
    alpha = 0.05; % from E to L
    kL = 0.0001; % from L to Es
    ks = 0.0001; % Es to Active TB (ks < k)
    kRp = 0.00008; % TB relapse
    
    q = 0.7; % Probability to be added to Ap
    mu = 0.00806; % mortality
    d = 0.05; % mortality TB Ap
    dE = 0.1; % mortality TB Ae
    
    r = 0.5; % recovery rate I1
    rE = 0.5; % recovery rate I2
    
    gamma = (mu + d + r); % per captia removal rate
    gammaE = (mu + dE + rE); % per captia removal rate of E
    
    beta = gamma; % infection when in an active cluster
    n = 20; % group of individuals that are highly subsceptible
    p = 0.125; % clustering coefficient
    sigma = 1; % ?
end
