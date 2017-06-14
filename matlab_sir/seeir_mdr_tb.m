function [ ret ] = seeir_mdr_tb(t, y)
    SA = y(1);
    LA = y(2);
    LAm = y(3);
    I = y(4);
    T = y(5);
    SB = y(6);
    LB = y(7);
    LBm = y(8);
    IM = y(9);
    TM = y(10);
    % Whole Population
    N = SA + SB + LA + LB + LAm + LBm + I + IM + T + TM;
    
    [epsilon, kappa, nu, gamma, mui, mut, eta, o, chi, phi, phim] = diseaseParams();
    [pi, mu, rho] = epidemicParams();
    [iota, delta, deltam, omega, beta, ~] = controlParams();
    
    lambda = beta * rho * (I + o * T) / N;
    lambdaD = chi * lambda;
    lambdaM = (beta * 0.7) * rho * (IM + o * TM) / N;
    lambdaDM = chi * lambdaM;
    
    dSAdt = (1 - iota) * pi * N - (lambda + lambdaM + mu) * SA;
    dSBdt = iota * pi * N + phi * T + phim * TM - (lambda + lambdaDM + mu) * SB;
    dLAdt = lambda * SA + lambdaD * (SB + LB + LBm) - (epsilon + kappa + mu) * LA;
    dLAmdt = lambdaM * SA + lambdaDM * (SB + LB + LBm) - (epsilon + kappa + mu) * LAm;
    dLBdt = kappa * LA + gamma * I - (lambdaD + lambdaDM + nu + mu) * LB;
    dLBmdt = kappa * LAm + gamma * IM - (lambdaD + lambdaDM + nu + mu) * LBm;
    dIdt = epsilon * LA + nu * LB + (1 - eta) * omega * T - (gamma + delta + mui) * I;
    dIMdt = epsilon * LAm + nu * LBm + eta * omega * T + omega *  TM - (gamma + deltam + mui) * IM;
    dTdt = delta * I - (phi + omega + mut) * T;
    dTMdt = deltam * IM - (phim + omega + mut) * TM;
    
    ret = [dSAdt dLAdt dLAmdt dIdt dTdt dSBdt dLBdt dLBmdt dIMdt dTMdt]';
end

function [epsilon, kappa, nu, gamma, mui, mut, eta, o, chi, phi, phim] = diseaseParams()
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

function [pi, mu, rho] = epidemicParams()
    pi = 0.025; % Birth rate during sensivity Analysis - United Nations Department of Economic and Social Affairs
    mu = 0.016; % TB-free mortality - WHO (2013b) ~ u
    rho = 0.35; % Infectious propertion - WHO (2013c) ~ p
end

function [iota, delta, deltam, omega, beta, mdr] = controlParams()
    iota = 0.65; % BCG vaccination rate - World Bank (2013) ~ t
    delta = 0.72; % Detection rate - WHO (2013c) ~ d
    deltam = 0; % MDR-TB detection
    omega = 0.25; % Default rate - WHO (2013c) ~ w
    beta = 24; % Effective contact rate
    mdr = 0.06; % proportion of cases MDR-TB 4-6%
end

function [Ti] = probabilities(t)
    Vn = [1 0 0 0];
    In = [0 0 1 0]';
    [epsilon, kappa, nu, gamma, mui, ~, ~, ~, ~, ~, ~] = diseaseParams();
    [~, mu, ~] = epidemicParams();
    A = [
        1 - (epsilon + kappa + mu) * t, kappa * t, epsilon * t, mu * t;
        0, 1 - (nu + mu) * t, nu * t, mu * t;
        0, gamma * t , 1 - (gamma + mui) * t, mui * t;
        0, 0, 0, 1;
    ];
    accu = 0;
    for n = 1:t
        accu = accu + (Vn * A.^n * In);
    end
    Ti = t * accu;
end
