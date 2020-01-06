function I = gaussQuadratur(f,n)
%GAUSSQUADRATUR Summary of this function goes here
%   Detailed explanation goes here
    
[~,p_n] = generateLegendrePolynome(n);
roots = legendreRoots(n+1);


w_k = 2*(1-roots.^2)./((n+1)^2*p_n(roots).^2);

I = sum(f(roots).*w_k);
end

