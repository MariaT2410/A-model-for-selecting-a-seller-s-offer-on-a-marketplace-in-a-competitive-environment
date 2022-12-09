function table = generalized_demand(fs,xs, N, K, w)
sizex = size(xs, 2);
table = zeros([sizex N]);
disp("g vgv");
disp(xs);
disp(fs);
disp(sizex);
for n=1:N
    x_ans = zeros([1 sizex]);
    for j=1:sizex
        tx = xs(j);
        sum1 = 0;
        for i = 1:K
            a = fs(i, 1, n);
            b = fs(i, 3, n);
            m = fs(i, 2, n);
            if tx == m
                curr_ans = 1;
            else
                if tx < m && tx >= a
                    curr_ans = (tx-a)/(m-a);
                else
                    if tx > m && tx <= b
                        curr_ans = 1 -(tx - m)/(b-m);
                    else 
                        curr_ans = 0;
                    end
                end
            end
            sum1 = sum1 +curr_ans * w(i);
        end
        x_ans(j) = sum1;
    end
    table(:, n) = x_ans';
end
end

