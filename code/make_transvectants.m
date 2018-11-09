%% Make ye olde transvectants
max_order = 4;
syms Q(x, y)
m = floor(max_order/2)+1;
fd = fopen('foo.tex', 'w');
fprintf(fd, '%s\n', '\documentclass{article}')
fprintf(fd, '%s\n', '\usepackage{amsmath, breqn}')
fprintf(fd, '%s\n', '\begin{document}')
fprintf(fd, '%s\n', 'S: \begin{dgroup}')
for i = 1:m
    S{i} = simplify(transvectant(Q, Q, 2*(i-1)));
    fprintf(fd, '%s\n%s\n%s\n', '\begin{dmath}', ...
        latex(S{i}), '\end{dmath}');
end
fprintf(fd, '%s\n', '\end{dgroup}')
fprintf(fd, '%s\n', 'T: \begin{dgroup}')
for i = 1:m
    for j = 1:m
        T{i, j} = transvectant(Q, S{i}, j-1);
        fprintf(fd, '%s\n%s\n%s\n', '\begin{dmath}', ...
            latex(T{i, j}), '\end{dmath}');
    end
end
fprintf(fd, '%s\n', '\end{dgroup}')
% fprintf(fd, '%s\n', 'V: \begin{dgroup}')
% for i = 1:m
%     for j = 1:m
%         for k = 1:m
%             V{i, j, k} = transvectant(S{i}, S{j}, k-1);
%             fprintf(fd, '%s\n%s\n%s\n', '\begin{dmath}', ...
%                 latex(V{i, j, k}), '\end{dmath}');
%         end
%     end
% end
% fprintf(fd, '%s\n', '\end{dgroup}')
fprintf(fd, '%s\n', '\end{document}')
fclose(fd)