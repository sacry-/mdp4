clear;

leg = {};
% year,week,state,state_name,disease,cases,incidence_per_capita
for elem = {'hepatitis', 'measles', 'rubella', 'smallpox', 'pertussis', 'mumps'}
    path = sprintf('./data/%s.csv', elem{1});
    hepa = readtable(path);
    hyears = table2array(hepa(:, 1));
    hcases = table2array(hepa(:, 6));
    % bar(hyears(1:1000:length(hyears)), hcases(1:1000:length(hyears)));
    [a,~,c] = unique(hyears);
    total_year = smooth(accumarray(c, hcases), 'moving');
    plot(smooth(a, 'moving'), total_year); hold on;
    leg = [leg, elem{1}];
end
hold off;
legend(leg);
