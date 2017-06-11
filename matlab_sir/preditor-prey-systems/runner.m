clear;

% Population y0
foxes = 1;
wolves = 1;
rabbits = 1;
turkey = 1;

% Rates
o = struct;
o.f_dec = 0.5;
o.f_grow = 0.01;
o.w_dec = 0.5;
o.w_grow = 0.01;
o.r_grow = 0.5;
o.r_dec = 0.01;
o.tu_grow = 0.5;
o.tu_dec = 0.01;

y0 = [foxes wolves rabbits turkey];
options = odeset('RelTol', 1e-5);
[t, y] = ode45(@(t,y) pred3(t,y,o),[0 100],y0,options); 

f = y(:,1);
w = y(:,2);
r = y(:,3);
tu = y(:,4);

figure; hold on
a1 = plot(t,f); M1 = "Fox";
a2 = plot(t,w); M2 = "Wolf";
a3 = plot(t,r); M3 = "Rabbit";
a4 = plot(t,tu); M4 = "Turkey";
legend([a1,a2,a3,a4], [M1, M2, M3, M4]);
ylabel('Populations')
xlabel('Time')
