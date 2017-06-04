clear;

% 1 = S, 2 = E, 3 = I, 4 = R
SEIRstates = ['S' 'E' 'I' 'R'];
trans = [
    0.8, 0.1, 0.05, 0.05;
    0.0, 0.8, 0.15, 0.05;
    0.0, 0.0, 0.75, 0.25;
    0.9, 0.05, 0.05, 0.0
];

observations = [10000];
S = 1000 * rand(4,100);
E = 100 * rand(1,100);
I = 10 * rand(1,100);
R = 0 * rand(1,100);

emis = rand(4,100);

[seq, states] = hmmgenerate(10000, trans, emis, 'Statenames', SEIRstates);
estimatedStates = hmmviterbi(seq, trans, emis, 'Statenames', SEIRstates);
chars = unique(estimatedStates);
h = histc(estimatedStates, chars);
fprintf('"%c" %d times\n', [chars; h]);


