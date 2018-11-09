%% Make ye olde transvectants
max_order = 4;
syms Q(x, y)
m = floor(max_order/2);
for i = 1:m
    S{i} = transvectant(Q, Q, 2*i);
end

for i = 1:m
    for j = 1:m
        T{i, j} = transvectant(Q, S{i}, j);
    end
end

for i = 1:m
    for j = 1:m
        for k = 1:m
            V{i, j, k} = transvectant(S{i}, S{j}, k);
        end
    end
end