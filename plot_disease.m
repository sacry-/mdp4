function [] = plot_disease(t, y0, y, labels, xLabel)
    fprintf('%s = N0\n', strjoin(labels, ' + '));
    fprintf('%s = N0 = %s\n', strjoin(string(y0)', ' + '), sum(y0));

    figure; hold on
    as = zeros(length(labels), 1);
    colors = random_colors(length(labels), [0 0 0]) * 0.8;
    lineStyles = {'-' '--' ':' '-.'};
    for i = 1:length(labels)
        line = lineStyles{mod(i, length(lineStyles)) + 1};
        y_dim = y(:, i);
        as(i) = plot(t, y_dim, line, 'color', colors(i, :), 'LineWidth', 2); 
    end
    legend(as, labels);
    ylabel('Populations')
    xlabel(xLabel)
end