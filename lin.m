function fun = lin(u)
if u <= -1
    fun = -1;
elseif (u >= -1) && (u <= 1)
    fun = u;
else
    fun = 1;
end
end