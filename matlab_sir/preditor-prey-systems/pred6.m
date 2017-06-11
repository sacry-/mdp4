clear;

% Population y0
rabbits = 100;
foxes = 30;
wolves = 20;
init = containers.Map({'r', 'f', 'w'}, {rabbits, foxes, wolves});

y0 = [rabbits foxes wolves];
options = odeset('RelTol', 1e-5);
steps = 0:0.01:100;
[t, y] = ode45(@(t,y) predPrey(t, y, init), steps,y0,options); 

r = y(:,1);
f = y(:,2);
w = y(:,3);

figure; hold on
a1 = plot(t,r); M1 = "Rabbit";
a2 = plot(t,f); M2 = "Fox";
a3 = plot(t,w); M3 = "Wolf";
legend([a1,a2,a3], [M1, M2, M3]);
ylabel('Populations')
xlabel('Time')

function [ ret ] = predPrey(t, y, init)
    r = y(1); % 100
    f = y(2); % 30
    w = y(3); % 10
    
    ret = setting1(r, f, w, init);
end

function [ ret ] = setting1(r, f, w, init)
    rk = init('r');
    fk = init('f');
    wk = init('w');
    
    ret = [
        grow(0.6, r, 2 * rk) + prey(0.01, r, f) + prey(0.001, r, w)
        decay(0.4, f) + predit(0.01, f, r) + prey(0.01, f, w)
        decay(0.4, w) + predit(0.01, w, f) + predit(0.001, w, r)
    ];
end

function [ret] = predit(dec, preditor, prey)
    ret = dec * preditor * prey;
end

function [ret] = prey(dec, prey, preditor)
    ret = - dec * prey * preditor;
end

function [ret] = grow(g, n, k)
    ret = growFinite(g, n, k);
end

function [ret] = decay(g, n)
    ret = - g * n;
end

% Helper
function [ret] = growExp(g, n, k)
    ret = g * n * (l - n);
end

% Grass consumption is finite for instance
function [ret] = growFinite(g, n, k)
    ret = g * (1 - (n / k)) * n;
end

% Preditors saturate and do not grow infitely
function [ret] = preditCon(dec, preditor, prey, s)
    ret = dec * ((preditor * prey) / (1 + prey / s));
end

