function [ pred2 ] = pred2(t, y, o)
    f = y(1); r = y(2); tu = y(3);
    % Fox 
    fox_pop = - o.f_dec * f + (o.f_grow * f * r) + (o.f_grow * f * tu);
    % Rabbit
    rabbit_pop = o.r_grow * r - o.r_dec * f * r;
    % Turkey
    turkey_pop = o.tu_grow * tu - o.tu_dec * f * tu;
    % column vector
    pred2 = [fox_pop rabbit_pop turkey_pop]';
end

