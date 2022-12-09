function table = limit_seller(fq1, fq2, fq3, N, K, xs, w)
fq1 = [fq1', fq2', fq3'];
sizex = size(xs, 2);
table = zeros([sizex N]);
for n=1:N
    x_ans = zeros([1 sizex]);
    for j=1:sizex
        tx = xs(j);
        sum2 = 0;
        for i = 1:K
            a = fq1(1, n);
            b = fq1(3, n);
            m = fq1(2, n);
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
            sum2 = sum2 + curr_ans * w(i);
        end   
        x_ans(j) = sum2;       
    end
        table(:, n) = x_ans';
end   
%disp('Значения ФСО продавца:')
%disp(table)%table-ФСО 
end

