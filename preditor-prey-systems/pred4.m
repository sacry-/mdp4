function [ pred4 ] = pred4(t, y)
    w = y(1); 
    r = y(2); 
    tu = y(3);
    % Wolf
    wolf_pop = 0.1 * w * (1 - (sum(w + 0.01 * [r tu]) / 50));
    % Rabbit
    rabbit_pop = 0.8 * r * (1 - ((r + 0.06 * w) / 200));
    % Turkey
    turkey_pop = 0.4 * tu * (1 - ((tu + 0.03 * w) / 100));
    % column vector
    pred4 = [wolf_pop rabbit_pop turkey_pop]';
end
