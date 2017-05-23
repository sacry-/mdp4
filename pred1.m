function [ pred1 ] = pred1(t, y)
    % Lotka-Volterra system of differential equations. 
    f = y(1); r = y(2);
    % fox:  x' = - d * x  -> d = birth_rate - death_rate
    % x' = (- d * x) + (x * e * y) and x(0) = x0
    % e is a positive constant, rabbites = source of food
    fox_decay = 0.5;
    growth_per_encounter = 0.01; 
    fox_pop = - fox_decay * f + growth_per_encounter * f * r;
    %  rabbits: y' = b * y - b = birth_rate - death_rate
    % y' = (b * y) - (c * x * y) and y(0) = y0.
    % c is a negative constant, more rabbits and foxes = decrease in
    % rabbits
    rabbit_growth = 0.5; 
    decay_per_encounter = 0.01;
    rabbit_pop = rabbit_growth * r - decay_per_encounter * f * r;
    % column vector
    pred1 = [fox_pop rabbit_pop]';
end