I_exact = log(3);
[I_app, err] = deal(zeros(1,16));
f = @(x) 1./(x+2);

for k = 1:16
    I_app(k) = gaussQuadratur(f,k);
    err(k) = abs(I_exact - I_app(k));
end

semilogy(err,'o')
xlabel('St\"{u}tzstellen, $n$','Interpreter','latex','FontSize',15)
ylabel('$|I - I_n|$','Interpreter','latex','FontSize',15)
grid on