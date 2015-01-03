

a = cycl(rand(2000));


b = rand(2000);


c = rand(2000);

nr = 100;


t_a = NaN(nr,1);
for ii = 1:nr
    tic;
        c = times(a,a);
    t_a(ii) = toc;
end

t_b = NaN(nr,1);
for ii = 1:nr
    tic;
        c = times(b,b);
    t_b(ii) = toc;
end

t_c = NaN(nr,1);
for ii = 1:nr
    tic;
        c = times(a,b);
    t_c(ii) = toc;
end


mean(t_a)
mean(t_b)
mean(t_c)










