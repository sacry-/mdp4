clear;


[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

% Population
% Susceptibles
SA0 = 100000;
SB0 = SA0 * 0.06;
% Latent early
LA0 = SA0 * 0.2;
LB0 = SB0 * 0.2;
% Latent late
LAm0 = LA0 * 0.2;
LBm0 = LB0 * 0.2;
% Infected
I0 = 2000;
IM0 = I0 * 0.06;
% Recovered
T0 = 0;
TM0 = 0;

y0 = [SA0 LA0 LAm0 I0 T0 SB0 LB0 LBm0 IM0 TM0 0];

% Time
years = 10;

options = odeset('RelTol', 1e-5);
steps = 0:0.01:years-1;
[t, y] = ode45(@(t,y) seeir_mdr_tb(t, y), steps,y0,options); 

plots = 2;
if plots == 1
    labels = {'I'};
    infections = sum(y(:, [4 9]), 2);
    beta = (0:(40/(length(infections)-1)):40)';
    plot_disease(beta, y0, infections, labels, 'Beta');
elseif plots == 2
    c1 = {'Sa' 'Lb' 'Lam' 'I' 'Ta'};
    c2 = {'Sb' 'Lb' 'Lbm' 'I' 'Tb'};
    
    plot_disease(t, y0, y(:, 1:5), c1, 'Years');
    plot_disease(t, y0, y(:, 5:10), c2, 'Years');
end
