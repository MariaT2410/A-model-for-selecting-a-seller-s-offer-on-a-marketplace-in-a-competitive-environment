function fs = intersection_supply_demand(supply,demand, N, sizex)
fs = zeros([sizex N]);
x_ans1 = zeros([1 sizex]);
for n = 1:N
    for i = 1:sizex
        if (supply(i, n)<=demand(i, n))&&(supply(i, n)~= 0)
            x_ans1(i) = supply(i, n);
        else 
            x_ans1(i) = 0;
        end 
    end
    fs(:, n) = x_ans1';
end
end

