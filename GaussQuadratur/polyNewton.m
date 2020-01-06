function x = polyNewton(p,x0,maxit)
%NEWTON(p,x0) returns an approximate solution of p(x) = 0 starting
%             at x = x0

if nargin < 3 || isempty(maxit), maxit = 1000; end

x_j = x0;

for j = 1:maxit
    x_j = x_j - polyval(p,x_j)/polyval(polyder(p),x_j);
end

x = x_j;

end

