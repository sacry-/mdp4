clear;

us_pop = csvread('./data/us_1990_2015.csv',1,0);
pop_years = us_pop(:,1);
totals = us_pop(:,2);

us_tub = csvread('./data/us_1953_2015_tb_incidence.csv',1,0);
years = fliplr(us_tub(:, 1));
incidence = fliplr(us_tub(:, 2));
inc_rate = fliplr(us_tub(:, 3));
smooth_inc = smooth(incidence);

plotNo = 3;
figure; hold on

if plotNo == 1
    bar(pop_years(1:10:length(pop_years)), totals(1:10:length(pop_years)));
    plot(pop_years, smooth(totals), '-', 'color', [1 .4 0], 'LineWidth', 2);
elseif plotNo == 2
    plot(years, smooth_inc, '-', 'color', [1 .4 0], 'LineWidth', 1);
    plot(years(end), smooth_inc(end), 'x', 'color', [0 0 0], 'LineWidth', 4, 'markers', 10);
    plot(years(1), smooth_inc(1), 'x', 'color', [0 0 0], 'LineWidth', 4, 'markers', 10);
elseif plotNo == 3
    pop_from_1953 = totals(1:find(pop_years == 1953));
    plot(years, smooth_inc ./ smooth(pop_from_1953), '-', 'color', [1 .4 0], 'LineWidth', 1);
end
