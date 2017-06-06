clear;

% Population
% Susceptibles
S10 = 10000;
S20 = 200;
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
I10 = 0;
I20 = 0;
% Recovered
R10 = 0;
R20 = 0;

y0 = [S10 E10 L10 Es10 I10 R10 S20 E20 L20 Es20 I20 R20];

% Time
years = 10;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;
[t, y] = ode45(@(t,y) clusterModel(t, y), steps,y0,options); 

labels = {'S1' 'E1' 'L1' 'Es1' 'R1' 'I1' 'S2' 'E2' 'L2' 'Es2' 'R2' 'I2'};
fprintf('%s = N0\n', strjoin(labels, ' + '));
fprintf('%s = N0 = %s\n', strjoin(string(y0)', ' + '), sum(y0));

figure; hold on
as = zeros(length(labels), 1);
colors = random_colors(length(labels));
for i = 1:length(y0)
    label = labels(i);
    y_dim = y(:, i);
    as(i) = plot(t, y_dim, 'color', colors(i, :), 'LineWidth', 2); 
end
legend(as, labels);
ylabel('Populations')
xlabel('Time')


function [ret] = clusterModel(t, y)
    % Cluster one
    S1 = y(1);
    E1 = y(2); 
    L1 = y(3); 
    Es1 = y(4); 
    I1 = y(5);
    R1 = y(6); 
    N1 = S1 + E1 + L1 + Es1 + I1 + R1;
    
    % Cluster two
    S2 = y(7);
    E2 = y(8); 
    L2 = y(9); 
    Es2 = y(10); 
    I2 = y(11);
    R2 = y(12); 
    N2 = S2 + E2 + L2 + Es2 + I2 + R2;
    
    [k, alpha, q, kL, kRp, ks, mu, beta, r, rE, gamma, gammaE, n, p, o, B] = modelParameters();
    
    SF = F(S1, S2, N1, N2, E2, Es2, L2, R2);
    dS1dt = -(beta + gamma) * S1 + SF;
    EF = F(E1, E2, N1, N2, E2, Es2, L2, R2);
    dE1dt = beta * S1 - (alpha + gamma) * E1 + EF;
    LF = F(L1, L2, N1, N2, E2, Es2, L2, R2);
    dL1dt = alpha * (E1 + Es1) - (o * beta + gamma) * L1 + LF;
    EsF = F(Es1, Es2, N1, N2, E2, Es2, L2, R2);
    dEs1dt = o * beta * L1 + (alpha + gamma) * Es1 + EsF;
    dI1dt = q * (k * E2 + ks * Es2 + kL * L2 + kRp * R2) - gamma * I1;
    RF = F(R1, R2, N1, N2, E2, Es2, L2, R2);
    dR1dt = -gamma * R1 + RF;
    
    c1 = [dS1dt dE1dt dL1dt dEs1dt dI1dt dR1dt];
    
    dS2dt = B - mu * S2 + gamma * S1 - SF;
    dE2dt = -(mu + alpha + k) * E2 + gamma * E1 - EF;
    dL2dt = alpha * (E2 + Es2) + gamma * L1 - (mu + kL) * L2 - LF;
    dEs2dt = gamma * Es1 - (ks + mu + alpha) * Es2 - EsF;
    dI2dt = (1 - q) * (k * E2 + ks * Es2 + kL * L2 + kRp * R2) - gammaE * I2;
    dR2dt = r * I1 + rE * I2 + gamma * R1 - (mu + kRp) * R2 - RF;
    
    c2 = [dS2dt dE2dt dL2dt dEs2dt dI2dt dR2dt];
    
    ret = [c1 c2]';
end

function [ret] = F(S1, S2, N1, N2, E2, Es2, L2, R2)
    [k, alpha, q, kL, kRp, ks, mu, beta, r, rE, gamma, gammaE, n, p, o, B] = modelParameters();
    ret = q * (k * E2 + k * Es2 + kL * L2 + kRp * R2) * n * (p * S1 / N1 + (1 - p) * S2 / N2);
end

function [k, alpha, q, kL, kRp, ks, mu, beta, r, rE gamma, gammaE, n, p, o, B] = modelParameters()
    k = 0.01; % Fast progression from E to I (active TB)
    alpha = 0.05; % Slow progression E to L
    kL = 0.001; % Low risk to High risk Es
    ks = 0.001; % High risk Es to Active TB
    q = 0.01; % New Active TB I1
    kRp = 0.005; % % New Active TB I2
    mu = 0.01; % mortality
    d = 0.05; % mortality TB I1
    dE = 0.1; % mortality TB I2
    r = 0.95; % recovery rate I1
    rE = 0.6; % recovery rate I2
    beta = 0.25; % infection when in an active cluster
    gamma = mu + d + r; % recovery rates
    gammaE = mu + dE + rE; % recovery rates
    n = 0.9; % group of individuals that are highly subsceptible
    p = 0.1; % clustering coefficient
    o = 0.016; % ?
    B = 0.2; % constant addition to sucsceptibles
end
