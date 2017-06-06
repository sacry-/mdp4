clear;

% Population
% Susceptibles
U = 10000;
% Exposed early
E = 0;
% Latent early
L = 0;
% Exposed late
Es = 0;
% Infected
Ap = 0;
Ae = 0;
% Recovered
R = 0;

y0 = [U E L Es Ap Ae R];

% Time
years = 10;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years;
[t, y] = ode45(@(t,y) compartmentModel(t, y), steps,y0,options); 

labels = {'U' 'E' 'L' 'Es' 'Ap' 'Ae' 'R'};
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
    k = 0.01; % Fast progression from E to I (active TB)
    alpha = 0.05; % Slow progression E to L
    kL = 0.001; % Low risk to High risk Es
    ks = 0.001; % High risk Es to Active TB
    
    q = 0.7; % New Active TB I1
    kRp = 0.005; % % New Active TB I2
    mu = 0.01; % mortality
    
    d = 0.05; % mortality TB I1
    dE = 0.1; % mortality TB I2
    p = 0.5;
    r = (1 - p); % recovery rate I1
    rE = (1 - p); % recovery rate I2
    
    gamma = (mu + d + r); % recovery compatments
    gammaE = (mu + dE + rE);
    
    Bt = 0.2; % constant addition to sucsceptibles
    
    sigma = 0.016; % ?
    Q0 = 15; % ?
end
