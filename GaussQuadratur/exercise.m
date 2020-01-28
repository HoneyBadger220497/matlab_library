I_exact = log(3);
[I_app, err] = deal(zeros(1,16));
f = @(x) 1./(x+2);

for k = 1:16
    I_app(k) = gaussQuadratur(f,k);
    err(k) = abs(I_exact - I_app(k));
end

mat_res = abs(log(3) - integral(f,-1,1));

l = semilogy(err,'x');
hold on
semilogy([0,17],[1,1]*mat_res)
set(gca,'FontSize',15)
xlabel('St\"{u}tzstellen, $n$','Interpreter','latex','FontSize',20)
ylabel('$|I - I_n|$','Interpreter','latex','FontSize',20)
xlim([0,17])
legend('Gauss Quadratur','Matlab Routine')

set(l,'MarkerSize',9)
grid on
hold off

I_exact = log(3);
[I_app, err] = deal(zeros(1,16));
f = @(x) 1./(x+2);