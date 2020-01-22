function [roots, stats] = legendreRoots(n, min_res, max_iter)
%LEGENDREROOTS(n) returns the N roots of the N-th legendre polynomial in
%                 ascencding order. Calculation of zeros works with 
%                 newtons method.
%

% default values
if nargin < 2 || isempty(min_res), min_res = 1e-10; end
if nargin < 3 || isempty(max_iter), max_iter = 1000; end

% init 
[roots, iterations, residuum] = deal(zeros(1,n));
% loop over zeros
for k = 0:n-1
    x_k_j = cos((4*k+3)*pi/(4*(n-1)+6)); % start approximation of zeros
    
    % newton methods loop
    for j = 1:max_iter 
        [p, p_prime] = legendrePolynom(n,x_k_j); 
        res = p/p_prime;
        x_k_j = x_k_j - res;
        
        if abs(res) < min_res
            break
        end
    end
    
    % store result
    roots(k+1) = x_k_j;
    iterations(k+1) = j;
    residuum(k+1) = abs(res);
end

% outputs
roots = sort(roots);
stats = struct();
stats.residuum = residuum;
stats.iterarions = iterations;

end %legendreRoots 