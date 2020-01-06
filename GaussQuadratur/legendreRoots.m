function roots = legendreRoots(n)
%LEGENDREROOTS Summary of this function goes here
%   Detailed explanation goes here

p = generateLegendrePolynome(n);
roots = zeros(1,n);

for k = 0:n-1
    x0_k = cos((4*k+3)*pi/(4*(n-1)+6));
    roots(k+1) = polyNewton(p,x0_k);
end

roots = sort(roots);
end

