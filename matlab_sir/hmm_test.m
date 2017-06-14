clear;

[ us_years, us_inc, us_pop, us_inc_rate ] = us_data();

% 1 = S, 2 = E, 3 = I, 4 = R
SEIRstates = ['S' 'E' 'I' 'R'];
trans = [
    0.8, 0.1, 0.05, 0.05;
    0.0, 0.8, 0.15, 0.05;
    0.0, 0.0, 0.75, 0.25;
    0.9, 0.05, 0.05, 0.0
];

d = 2;
if d == 1
    Sr = 1000 * rand(4, 100);
    Er = 100 * rand(4, 100);
    Ir = 10 * rand(4, 100);
    Rr = 1 * rand(4, 100);
    emis = [Sr Er Ir Rr];
else
    S = [us_pop zeros(3, 63)']';
    E = [zeros(1, 63)' rand(1, 63)' rand(1, 63)' zeros(1, 63)']' * 0.01;
    I = [zeros(1, 63)' zeros(1, 63)' us_inc us_inc]';
    R = ones(4, 63);
    emis = [S E I R];
end

n = us_pop(end) / 1000;
[seq, states] = hmmgenerate(n, trans, emis, 'Statenames', SEIRstates);
estimatedStates = hmmviterbi(seq, trans, emis, 'Statenames', SEIRstates);
res = sum(estimatedStates==states)/length(states);
chars = unique(estimatedStates);
h = histc(estimatedStates, chars);
fprintf('"%c" %d times\n', [chars; h]);
fprintf('n = %d\n', n);
pstates = hmmdecode(seq,trans, emis);


