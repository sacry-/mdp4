function [ years, incidence, totals, inc_rate ] = us_data()
    us_pop = csvread('./data/us_1990_2015.csv',1,0);
    pop_years = us_pop(:,1);
    totals = us_pop(:,2);

    us_tub = csvread('./data/us_1953_2015_tb_incidence.csv',1,0);
    years = flipud(us_tub(:, 1));
    incidence = flipud(us_tub(:, 2));
    inc_rate = flipud(us_tub(:, 3));
    
    totals = flipud(totals(1:find(pop_years == 1953)));
end

