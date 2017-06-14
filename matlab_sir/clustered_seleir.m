function [ret] = clustered_seleir(t, y)
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
    
    dS2dt = 24 - mu * U2 + gamma * U1 - SF;
    dE2dt = -(mu + alpha + k) * E2 + gamma * E1 - EF;
    dL2dt = alpha * (E2 + Es2) + gamma * L1 - (mu + kL) * L2 - LF;
    dEs2dt = gamma * Es1 - (ks + mu + alpha) * Es2 - EsF;
    dAedt = (1 - q) * (k * E2 + ks * Es2 + kL * L2 + kRp * R2) - gammaE * Ae;
    dR2dt = r * Ap + rE * Ae + gamma * R1 - (mu + kRp) * R2 - RF;
    
    c2 = [dS2dt dE2dt dL2dt dEs2dt dAedt dR2dt];
    
    ret = [c1 c2]';
end

function [ret] = F(X1, X2, N1, N2, E2, Es2, L2, R2)
    [k, ~, q, kL, kRp, ks, ~, ~, ~, ~, ~, ~, n, p, ~] = modelParameters();
    ret = q * (k * E2 + ks * Es2 + kL * L2 + kRp * R2) * n * (p * X1 / N1 + (1 - p) * X2 / N2);
end

function [k, alpha, q, kL, kRp, ks, mu, beta, r, rE, gamma, gammaE, n, p, sigma] = modelParameters()
    k = 0.001; % from E to Ap
    alpha = 0.05; % from E to L
    kL = 0.0001; % from L to Es
    ks = 0.0001; % Es to Active TB (ks < k)
    kRp = 0.00008; % TB relapse
    
    q = 0.01; % Probability to be added to Ap
    mu = 0.00806; % mortality
    d = 0.001; % mortality TB Ap
    dE = 0.005; % mortality TB Ae
    
    r = 0.25; % recovery rate I1
    rE = 0.4; % recovery rate I2
    
    gamma = (mu + d + r); % per captia removal rate
    gammaE = (mu + dE + rE); % per captia removal rate of E
    
    beta = gamma; % infection when in an active cluster
    n = 24; % group of individuals that are highly subsceptible
    p = 0.125; % clustering coefficient
    sigma = 1; % ?
end