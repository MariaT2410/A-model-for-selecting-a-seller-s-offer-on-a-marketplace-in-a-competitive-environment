function F = winnings(w,fs,qj, N)
F =zeros(1,4);
    fsx1 = 0;
    fsx2 = 0;
    fsx3 = 0;
    fsx4 = 0;
    for n=1:N
        fsx1 = fs(qj(1, n), n)*w(1, n)+ fsx1;
    end  
    for n=1:N
        fsx2 = fs(qj(2, n), n)*w(1, n)+ fsx2;
    end  
    for n=1:N
        fsx3 = fs(qj(3, n), n)*w(1, n)+ fsx3;
    end  
    for n=1:N
        fsx4 = fs(qj(4, n), n)*w(1, n)+ fsx4;
    end  
F(1, 1) = fsx1;
F(1, 2) = fsx2;
F(1, 3) = fsx3;
F(1, 4) = fsx4;
end

