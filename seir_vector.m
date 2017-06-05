clear;

% Population
Sh0 = 1000;
Ih0 = 1;
Rh0 =  0;

% Vector (of attack)
Sv0 = 1000;
Iv0 = 0;

days = 40;

y0 = [Sh0 Ih0 Rh0 Sv0 Iv0];
options = odeset('RelTol', 1e-5);
steps = 0:0.01:days;
[t, y] = ode45(@(t,y) seirsVectorModel(t, y), steps,y0,options); 

labels = {'Sh' 'Ih' 'Rh' 'Sv' 'Iv'};
fprintf('%s = N0\n', strjoin(labels, ' + '));
fprintf('%s = N0 = %s\n', strjoin(string(y0)', ' + '), sum(y0));

figure; hold on
as = zeros(length(labels), 1);
colors = random_colors(length(labels), [.25 .25 .25]) * 0.8;
for i = 1:length(y0)
    label = labels(i);
    y_dim = y(:, i);
    as(i) = plot(t, y_dim, 'color', colors(i, :), 'LineWidth', 2); 
end
legend(as, labels);
ylabel('Populations')
xlabel('Days')

function [ ret ] = seirsVectorModel(t, y)
    Sh = y(1);
    Ih = y(2);
    Rh = y(3);
    Sv = y(4);
    Iv = y(5);
    
    Nh = Sh + Ih + Rh;
    
    [betaH, muH, gamma, M, betaV, muV, A, B] = modelParams();
    
    % Humans
    dShdt = muH * (Nh - Sh) - ((betaH * B) / (Nh + M)) * Sh * Iv;
    dIhdt = ((betaH * B) / (Nh + M)) * Sh * Iv - (muH + gamma) * Ih;
    dRhdt = gamma * Ih - muH * Rh;
    
    % Vectors (e.g. mosquitos)
    dSvdt = A - ((betaV * B) / (Nh + M)) * Sv * Ih - muV * Sv;
    dIvdt = ((betaV * B) / (Nh + M)) * Sv * Ih - muV * Iv;
    
    ret = [dShdt dIhdt dRhdt dSvdt dIvdt]';
end

% Nishiura (2006)
function [betaH, muH, gamma, M, betaV, muV, A, B] = modelParams()
    % How often does an infected mosquito meets a subsceptible human?
    betaH = 0.9;
    % The natural mortality rate of humans (this is unrelated to disease). 
    muH = 0.1;
    % The rate an infected recovers and moves into the resistant phase.
    gamma = 0.1;
    % Half saturation constant. Number of infections change with 
    % gaining more infections
    M = 3;
    % Rate of infection per mosquito per bite
    betaV = 1;
    % The natural mortality rate of the vector (this is unrelated to disease). 
    muV = 0.1;
    % How often does a mosquito bite a person?
    B = 1;
    % growth/recruitment of Sv to Iv
    A = 1;
end
