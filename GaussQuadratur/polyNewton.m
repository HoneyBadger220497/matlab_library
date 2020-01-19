function [x,iter,res] = polyNewton(p,x0,maxit,min_res)
%NEWTON(p,x0) returns an approximate solution of p(x) = 0 starting
%             at x = X0, the search ends after MAXIT iterations at most. 
%             If the convergence rate |x_k+1 - x_k| drops below 
%             MIN_RES the iteration stops as well

if nargin < 4 || isempty(min_res), min_res = 1e-10; end
if nargin < 3 || isempty(maxit), maxit = 1000; end

x_j = x0;

for iter = 1:maxit
    res = polyval(p,x_j)/polyval(polyder(p),x_j);
    x_j = x_j - res;
    
     if abs(res) < min_res
         break
     end
end

x = x_j;
res = abs(res);
end

