clear;

% Population y0
foxes = 20;
rabbits = 60;

y0 = [foxes rabbits];
options = odeset('RelTol', 1e-5);
[t, y] = ode45(@(t,y) predPreyExp(t, y),[0 100],y0,options); 

f = y(:,1);
r = y(:,2);

figure; hold on
a1 = plot(t,f); M1 = "Fox";
a2 = plot(t,r); M2 = "Rabbit";
legend([a1,a2], [M1, M2]);
ylabel('Populations')
xlabel('Time')

function [ret_val] = predPreyExp(t, y)
    fd = 0.5;
    fg = 0.005;
    rg = 0.5;
    rd = 0.01;

    f = y(1); 
    r = y(2); 
       
    s1 = [f fg fd];
    s2 = [r rg rd];
    
    ret_val = expVolterra(s1, s2);
end

% Exponential growth equation
function [ev] = expVolterra(s1, s2)
    ev = [
        s1(1) * s1(2) * s2(1) - s1(3) * s1(1)
        s2(1) * s2(2) - s2(3) * s1(1) * s2(1)
    ];
end
