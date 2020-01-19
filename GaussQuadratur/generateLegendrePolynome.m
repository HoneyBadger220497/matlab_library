function [p_n,p_n_handle] = generateLegendrePolynome(n)

%GENERATELEGENDREPOLYNOME(n) returns the Legendre Polynome of degree n as 
%                            a MATLAB polynomial as well as a function
%                            handle

if ~(n == fix(n)), error('Degree of Polynomial has to be an integer!'), end
if n < 0, error('Degree of Polynomial has to be a positive integer!'), end

if n == 0, p_n = [1]; p_n_handle = @(x) polyval(p_n,x); return, end
if n == 1, p_n = [1,0]; p_n_handle = @(x) polyval(p_n,x); return, end

p_k_m2 = [1];
p_k_m1 = [1,0];

for k = 2:n
    p_k = (2*k-1)/k*[p_k_m1,0] - (k-1)/k*[0,0,p_k_m2];
    p_k_m2 = p_k_m1;
    p_k_m1 = p_k;
end

p_n = p_k;
p_n_handle = @(x) polyval(p_n,x);

end

