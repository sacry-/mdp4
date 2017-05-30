
dfox = 10;
foxes = rand(dfox, 5);
drabbit = 50;
rabbits = rand(drabbit, 5);

pop_densities = [
   dfox drabbit
];

[island, grid, max_class] = createIsland(pop_densities);

F = createPop(island, grid, foxes);
Fs = reshape(F', 1, grid * grid);
R = createPop(island, grid, rabbits);
Rs = reshape(R', 1, grid * grid);

for iter = 0:100
end

function [F, R] = step(island, grid, F, R)
    % Fox eat rabbits
    eat = F & R;
    % do eating..
    
    % step rabbits
    R_new = stepPop(R, grid);
    % reproduce rabbits
    R_rep = R & R_new;
    
    % step foxes
    F_new = stepPop(F, grid);
    % reproduce Foxes
    F_rep = F & F_new;
    % do reproduction..
end

function [ret] = createPop(island, grid, cmatrix)
    b = size(cmatrix);
    p = b(1);
    x = randi(grid, [1,p]);
    y = randi(grid, [1,p]);
    idx = sub2ind(size(island), x, y);
    island(idx) = 1;
    ret = island;
end

function [island, grid, max_class] = createIsland(ptotal)
    classes = size(ptotal);
    max_class = max(classes);
    total = sum(ptotal);
    grid = ceil(2 * log(total));
    island = zeros(grid, grid);
end

function [M] = stepPop(M, grid)
    [xs_old, ys_old] = find(M==1);
    
    xs = zeros(size(xs_old));
    ys = zeros(size(ys_old));
    
    for i = 1:length(ys)
        x = floor(randn(1));
        y = floor(randn(1));
        if x == 0
            xs(i) = min(xs_old(i) + 1, grid);
        else
            xs(i) = max(xs_old(i) - 1, 0);
        end

        if y == 0
            ys(i) = min(ys_old(i) + 1, grid);
        else
            ys(i) = max(ys_old(i) - 1, 0);
        end
    end
   
    new_idx = sub2ind(size(M), xs, ys);
    M(new_idx) = 1;
    old_idx = sub2ind(size(M), xs_old, ys_old);
    M(old_idx) = 0;
end

function [border] = borderIsland(island)
    wall = -1;
    island(:,1) = wall;
    island(1,:) = wall;
    island(:,grid) = wall;
    island(grid,:) = wall;
    border = island;
end
