function [ pred3 ] = pred3(t, y, o)
    f = y(1); 
    w = y(2); 
    r = y(3); 
    tu = y(4);
    % Wolf
    wolf_pop = preditor(o.w_dec, o.w_grow, w, [r tu f]);
    % Fox 
    fox_pop = preditor(o.f_dec, o.f_grow, f, [r tu]) - pop_effect(o.f_dec, f, w);
    % Rabbit
    rabbit_pop = prey(o.r_grow, o.r_dec, r, [f w]);
    % Turkey
    turkey_pop = prey(o.tu_grow, o.tu_dec, tu, [f w]);
    % column vector
    pred3 = [fox_pop wolf_pop rabbit_pop turkey_pop]';
end

function [ret] = preditor(p_dec, p_grow, p, preys)
    ret = - p_dec * p + pop_effect(p_grow, p, preys);
end

function [ret] = prey(p_grow, p_dec, p, preditors)
    ret = p_grow * p - pop_effect(p_dec, p, preditors);
end

function [ret] = pop_effect(p_dec, p, preditors)
    ret = sum(p_dec * p * preditors);
end