clear;

% Population y0
wolves = 10;
rabbits = 100;
turkey = 50;

y0 = [wolves rabbits turkey];
options = odeset('RelTol', 1e-5);
[t, y] = ode45('pred4',[0 30],y0,options); 

w = y(:,1);
r = y(:,2);
tu = y(:,3);

figure; hold on
a1 = plot(t,w); M1 = "Wolf";
a2 = plot(t,r); M2 = "Rabbit";
a3 = plot(t,tu); M3 = "Turkey";
legend([a1,a2,a3], [M1, M2, M3]);
ylabel('Populations')
xlabel('Time')
