clear; shg;

us_pop = csvread('us_1990_2015.csv',1,0);
years = us_pop(:,1);
totals = us_pop(:,2);
bar(years(1:10:length(years)), totals(1:10:length(years)))