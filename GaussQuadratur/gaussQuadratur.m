function I = gaussQuadratur(f,n)
%GAUSSQUADRATUR(F,N) returns the approximate integral of the function F
%                    from -1 to 1 using N+1 grid points
    
[~,p_n] = generateLegendrePolynome(n);
roots = legendreRoots(n+1);


w_k = 2*(1-roots.^2)./((n+1)^2*p_n(roots).^2);

I = sum(f(roots).*w_k);
end

