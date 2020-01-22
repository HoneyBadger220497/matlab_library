function [p,p_prime] = genLegPol(n,x)
%GENLEGPOL calculates the N-th Legendre Polynomial's value at X as well as 
%          its derivative's value:
%          [P,P_PRIME] = genLegPol(N,X)
            

if ~(n == fix(n)), error('Degree of Polynomial has to be an integer!'), end
if n < 0, error('Degree of Polynomial has to be a positive integer!'), end

zero = zeros(size(x));
one = ones(size(x));

if n == 0, p = one; p_prime = zero; return, end
if n == 1, p = x; p_prime = one; return, end

p_k_m2 = one;
p_k_m1 = x;
p_k_prime_m2 = zero;
p_k_prime_m1 = one;

for k = 2:n
   p_k = (2*k-1)/k*x.*p_k_m1 - (k-1)/k*p_k_m2;
   p_k_prime = (2*k-1)/k*(p_k_m1 + x.*p_k_prime_m1) - (k-1)/k*p_k_prime_m2;
   
   p_k_m2 = p_k_m1;
   p_k_m1 = p_k;
   p_k_prime_m2 = p_k_prime_m1;
   p_k_prime_m1 = p_k_prime;
end

p = p_k;
p_prime = p_k_prime;

end

