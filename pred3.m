function [ pred3 ] = pred3(t, y, o)
    f = o.f(y(1)); w = o.f(y(2)); r = o.f(y(3)); tu = o.f(y(4));
    % Wolf
    wolf_pop = - o.w_dec * w + (o.w_grow * w * r) + (o.w_grow * w * tu);
    % Fox 
    fox_pop = - o.f_dec * f + (o.f_grow * f * r) + (o.f_grow * f * tu) - (o.w_grow * w);
    % Rabbit
    rabbit_pop = o.r_grow * r - ((o.r_dec * f * r) + (o.r_dec * w * r));
    % Turkey
    turkey_pop = o.tu_grow * tu - ((o.tu_dec * f * tu) + (o.tu_dec * w * tu));
    % column vector
    pred3 = [fox_pop wolf_pop rabbit_pop turkey_pop]';
end

