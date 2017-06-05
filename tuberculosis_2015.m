clear;

% Population
labels = {'SA' 'SB' 'LA' 'LB' 'LAm' 'LBm' 'I' 'IM' 'T' 'TM'};
% Susceptibles
SA0 = 100000;
SB0 = SA0 * 0.2;
% Latent early
LA0 = SA0 * 0.1;
LB0 = SB0 * 0.2;
% Latent late
LAm0 = LA0 * 0.2;
LBm0 = LB0 * 0.2;
% Infected
I0 = LA0 * 0.1 + LB0 * 0.1;
IM0 = LAm0 * 0.1 + LBm0 * 0.1;
% Recovered
T0 = I0 * 0.1;
TM0 = IM0 * 0.1;

y0 = [SA0 SB0 LA0 LB0 LAm0 LBm0 I0 IM0 T0 TM0];

fprintf('%s = N0\n', strjoin(labels, ' + '));
fprintf('%s = N0 = %s\n', strjoin(string(y0)', ' + '), sum(y0));

options = odeset('RelTol', 1e-5);
steps = 0:0.01:100;
[t, y] = ode45(@(t,y) tuberculosisModel(t, y), steps,y0,options); 

figure; hold on
as = zeros(length(labels), 1);
for i = 1:length(labels)
    label = labels(i);
    y_dim = y(:, i);
    as(i) = plot(t, y_dim, 'LineWidth', 2); 
end
legend(as, labels);
ylabel('Populations')
xlabel('Time')

function [ ret ] = tuberculosisModel(t, y)
    SA = y(1);
    SB = y(2);
    LA = y(3);
    LB = y(4);
    LAm = y(5);
    LBm = y(6);
    I = y(7);
    IM = y(8);
    T = y(9);
    TM = y(10);
    N = SA + SB + LA + LB + LAm + LBm + I + IM + T + TM;
    
    [epsilon, kappa, nu, gamma, mui, mut, eta, o, chi, phi, phim] = diseaseParameters();
    [pi, mu, rho] = epidemiologicalParameters();
    [iota, delta, deltam, omega, beta, mdr] = modifiableParameters();
    
    lambda = beta * rho * (I + o * T) / N;
    lambdaD = chi * lambda;
    lambdaM = (beta * mdr) * rho * (IM + o * TM) / N;
    lambdaDM = chi * lambdaM;
    
    dSAdt = (1 - iota) * pi * N - (lambda + lambdaM + mu) * SA;
    dSBdt = iota * pi * N + phi * T + phim * TM - (lambda + lambdaM + mu) * SB;
    dLAdt = lambda * SA + lambdaD * (SB + LB + LBm) - (epsilon + kappa + mu) * LA;
    dLAmdt = lambdaM * SA + lambdaDM * (SB + LB + LBm) - (epsilon + kappa + mu) * LAm;
    dLBdt = kappa * LA + gamma * I - (lambdaD + lambdaDM + nu + mu) * LB;
    dLBmdt = kappa * LAm + gamma * IM - (lambdaD + lambdaDM + nu + mu) * LBm;
    dIdt = epsilon * LA + nu * LB + (1 - eta) * omega * T - (gamma + delta + mui) * I;
    dIMdt = epsilon * LAm + nu * LBm + eta * omega * T - (gamma + deltam + mui) * IM;
    dTdt = delta * I - (phi + omega + mut) * T;
    dTMdt = deltam * IM - (phim + omega + mut) * TM;
    
    ret = [dSAdt dSBdt dLAdt dLBdt dLAmdt dLBmdt dIdt dIMdt dTdt dTMdt]';
end

function [epsilon, kappa, nu, gamma, mui, mut, eta, o, chi, phi, phim] = diseaseParameters()
    epsilon = 0.129; % Early progression - Diel et al. (2011) ~ e
    kappa = 0.821; % Transition to late latency ~ k
    nu = 0.075; % Reactivation - Blower et al. (1995) ~ v
    gamma = 0.63; % Spontaneous Recovery - Tiemersma et al. (2011) ~ y
    mui = 0.37; % TB death rate ~ u
    mut = 0.5 * mui; % Treated TB death rate - Harries et al. (2001) ~ u
    eta = 0.035; % Amplification - Cox et al. (2007) ~ n
    o = 0.21; % Treatment modification of infectiousness - Fitzwater et al. (2010) ~ o
    chi = 0.49; % Partial immunity - Colditz et al. (1994) ~ x
    phi = 2; % 2 per year, Drug susceptible treatment rate - WHO (2010) ~ ?
    phim = 0.5; % 0.5 per year, MDR-TB treatment rate ~ ?
end

function [pi, mu, rho] = epidemiologicalParameters()
    % pi = 0; % Birth rate during run-is
    pi = 0.025; % Birth rate during sensivity Analysis - United Nations Department of Economic and Social Affairs
    mu = 0.016; % TB-free mortality - WHO (2013b) ~ u
    rho = 0.35; % Infectious propertion - WHO (2013c) ~ p
end

function [iota, delta, deltam, omega, beta, mdr] = modifiableParameters()
    iota = 0.65; % BCG vaccination rate - World Bank (2013) ~ t
    delta = 0.72; % Detection rate - WHO (2013c) ~ d
    deltam = 0; % MDR-TB detection
    omega = 0.25; % Default rate - WHO (2013c) ~ w
    beta = 24; % Effective contact rate
    mdr = 0.06; % proportion of cases MDR-TB 4-6%
end