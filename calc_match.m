function match = calc_match()

global index_matrix;
global N; %Количество покупателей
global K; %количество признаков
global L; %количество продавцов

%Ввод данных
K = 3; %количество покупателей
N = 3; %количество признаков
L = 3; %количество продавцов
v = [10 4 6]; % объем запрашевоемого товара покупателями
fg1 = [0.2 0.4 1; 0.2 0.6 1; 0.2 0.2 0.8]; %функции принадлежности желания покупателя для цены (n=1)
fg2 = [0.2 0.5 1; 0.5 1 1; 0.2 0.6 1];  %функции принадлежности желания покупателя для размера (n=2)
fg3 = [0 0.4 0.6; 0.4 0.4 1; 0 0 1];  %функции принадлежности желания покупателя для качества (n=3)



xg1 =[0 1.0]; % диапазон значений
f1q1 = [0.5 1 1]; %функции принадлежности желания продавца 1   для цены (n=1)
f1q2 = [0.4 0.6 0.8];  %функции принадлежности желания продавца 1 для размера (n=2)
f1q3 = [0.3 0.5 0.7];  %функции принадлежности желания продавца 1 для качества (n=3)
w =zeros(size(v));


f2q1 = [0.2 0.6 1]; %функции принадлежности желания продавца 2  для цены (n=1)
f2q2 = [0.3 0.5 0.7];  %функции принадлежности желания продавца 2 для размера (n=2)
f2q3 = [0.3 0.6 0.7];  %функции принадлежности желания продавца 2 для качества (n=3)

f3q1 = [0.4 1 0.8]; %функции принадлежности желания продавца 3  для цены (n=1)
f3q2 = [0.2 0.4 1];  %функции принадлежности желания продавца 2 для размера (n=2)
f3q3 = [0.5 1 1];  %функции принадлежности желания продавца 2 для качества (n=3)

fs(:,:,1) =fg1;
fs(:,:,2) =fg2;
fs(:,:,3) =fg3;

% весовой коэффициент для k-ого покупателя
for k = 1:size(v,2)
    w(k) = v(k)/sum(v);
end

xs = xg1(1):0.1:xg1(2);
sizex = size(xs, 2);
disp(sizex);
%% Обобщенный спрос + построение графика
%Расчет значений функции обобщенного спроса
disp('Расчет значений функции обобщенного спроса:')
table = generalized_demand(fs,xs, N, K, w);
disp(table);

%% Локальные соответствия предложения продавца обобщенному спросу
conformity = zeros([1 N]);
q = [0.5, 0.5, 0.6];%Продавец выставил товар с характеристиками
for n=1:N
    tx = q(n)
    for j=1:sizex
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
        conformity(1, n) = sum1
    end
end
disp('Соответствие товара обобщенному спросу:')
disp(conformity)

%% График возможностей 3 продавцов + построение графика
disp('Значения ФСО 1 продавца:')
table1 = limit_seller(f1q1, f1q2, f1q3, N, K, xs, w);
disp(table1);

disp('Значения ФСО 2 продавца:')
table2 = limit_seller(f2q1, f2q2, f2q3, N, K, xs, w);
disp(table2);

disp('Значения ФСО 3 продавца:')
table3 = limit_seller(f3q1, f3q2, f3q3, N, K, xs, w);
disp(table3);

%% Пересечение обобщенного спроса и ФСО
%Пересечение по каждому пункту обобщенного спроса по и ФСО продавца 
 
disp('Пересечение обобщ. спроса и ФСО 1');   
f1s = intersection_supply_demand(table, table1, N, sizex);
disp(f1s)  

disp('Пересечение обобщ. спроса и ФСО 2');   
f2s = intersection_supply_demand(table, table2, N, sizex);
disp(f2s)  

disp('Пересечение обобщ. спроса и ФСО 3');   
f3s = intersection_supply_demand(table, table3, N, sizex);
disp(f3s)  

%% Агрегирование(взвешанная сумма)
%qj =[6, 5, 6; 7, 5, 6; 8, 5, 6; 6, 6, 6] %qj=[x1, x2, x3]
w =[0.3, 0.5, 0.2];
qj =[9, 6, 7; 9, 7, 7; 10, 6, 6; 10, 7, 6] %qj=[x1, x2, x3]
disp('Вероятность p сделки (Выигрыш) и ФСО 1');   
F1 = winnings(w,f1s, qj, N);
disp(F1) 
disp('Вероятность p сделки (Выигрыш) и ФСО 2');   
F2 = winnings(w,f2s, qj, N);
disp(F2)
disp('Вероятность p сделки (Выигрыш) и ФСО 3');   
F3 = winnings(w,f3s, qj, N);
disp(F3)

%% Расчет локальных соответсвий возможностям продавцам
mus1 = zeros([1 N]);
fq1 = [f1q1', f1q2', f1q3'];
for n=1:N
    tx = q(n)
    a = fq1(1, n);
    b = fq1(3, n);
    m = fq1(2, n);
    if tx == m
        mus1(1, n) = 1;
    else
        if tx < m && tx >= a
            mus1(1,n) = (tx-a)/(m-a);
        else
            if tx > m && tx <= b
                mus1(1, n) = 1 -(tx - m)/(b-m);
            else
                mus1(1, n) = 0;
            end
        end
    end
end     
disp('Соответствие товара возможностям ПЕРВОГО продавца:')
disp(mus1)
mus2 = zeros([1 N]);
fq2 = [f2q1', f2q2', f2q3'];
for n=1:N
    for j=1:N
        tx = q(j)
        a = fq2(1, n);
        b = fq2(3, n);
        m = fq2(2, n);
        if tx == m
            mus2(1, n) = 1;
        else
            if tx < m && tx >= a
                mus2(1,n) = (tx-a)/(m-a);
            else
                if tx > m && tx <= b
                    mus2(1, n) = 1 -(tx - m)/(b-m);
                else
                    mus2(1, n) = 0;
                end
            end
        end  
    end
end     
disp('Соответствие товара возможностям ВТОРОГО продавца:')
disp(mus2)
%% Расчет матрицы игры
S = size(qj, 1);
M1=zeros(1,S);
    for j=1:S
        for l=1:S
            if F1(1,j)>F2(1,l)
                M1(j,l)=F1(1,j);
            elseif F1(1,j)<F2(1,l)
                    M1(j,l)=0;
            elseif F1(1,j)==F2(1,l)
                M1(j,l)=F1(1,j)/2;
            end   
        end
    end
disp('Матрица игры для 1 игрока');
disp(M1);
 
M2=zeros(1,S);
    for j=1:S
        for l=1:S
            if F2(1,j)>F1(1,l)
                M2(j,l)=F2(1,j);
            elseif F2(1,j)<F1(1,l)
                    M2(j,l)=0;
            elseif F2(1,j)==F1(1,l)
                M2(j,l)=F1(1,j)/2;
            end   
        end
    end

disp('Матрица игры для 2 игрока');
disp(M2);

%% Равновесие по Нешу

%максимальные элементы в строках
disp('2 продавец:')
Mnesh2=zeros(S,S);
for x=1:S
    e = M2(x,:);
    m = find(e==max(e));
    for w=1:S
        if(e(w) ~= e(m))
            e(w)=0;
            else e(w)=1;
        end
    end
    Mnesh2(x,:) = e;
end
disp(Mnesh2);



%максимальные элементы в столбцах
disp('1 продавец:')
Mnesh1=zeros(S,S);
for x=1:S
    e = M1(:,x);
    m = find(e==max(e));
    for w=1:S
        if(e(w) ~= M1(m))
            e(w)=-1;
        else e(w)=1;
        end
    end
    Mnesh1(:,x) = e;
end
disp(Mnesh1);


for xc=1:S
    for yv=1:S
        if(Mnesh1(xc,yv)==Mnesh2(xc,yv))
            coordinationx = xc;
            coordinationy = yv;
        end
    end
end
disp(coordinationx);
disp(coordinationy);
disp('1');
disp(M1(coordinationx,coordinationy));
disp('2');
disp(M2(coordinationx,coordinationy));




%% Расчет матриц игры ждя 3 игроков

S = size(qj, 1);
M1=zeros(1,S);
    for j=1:S
        for l=1:S
            if F1(1,j)>F2(1,l)
                M1(j,l)=F1(1,j);
            elseif F1(1,j)<F2(1,l)
                    M1(j,l)=0;
            elseif F1(1,j)==F2(1,l)
                M1(j,l)=F1(1,j)/2;
            end   
        end
    end
disp('Матрица игры для 1 игрока');
disp(M1);

%% Графики
figure;
grid on;
subplot(1, 3, 1),
hold on
plot(xs, table(:, 1), 'k');
plot(xs, table1(:, 1), 'r');
plot(xs, table2(:, 1), 'y');
% plot(xs, table3(:, 1), 'b');
hold off;
xlabel('x'),
ylabel('fg1'),
grid on;
subplot(1, 3, 2),
hold on;
plot(xs, table(:, 2), 'k');
plot(xs, table1(:, 2), 'r');
plot(xs, table2(:, 2), 'y');
% plot(xs, table3(:, 2), 'b');
hold off;
xlabel('x'),
ylabel('fg2'),
%title('Функция принадлежности обобщенного спроса для цены/размера/качества')
grid on;
subplot(1, 3, 3),
hold on;
plot(xs, table(:, 3), 'k');
plot(xs, table1(:, 3), 'r');
plot(xs, table2(:, 3), 'y');
% plot(xs, table3(:, 3), 'b');
hold off;
xlabel('x'),
ylabel('fg3'),
grid on;
return;
end
