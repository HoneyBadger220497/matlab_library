I_exact = log(3);
[I_app, err] = deal(zeros(1,4));
f = @(x) 1./(x+2);

for k = 1:4
    I_app(k) = gaussQuadratur(f,2^k);
    err(k) = abs(I_exact - I_app(k));
end

semilogy(err,'o')