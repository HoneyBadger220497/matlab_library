function [A,res] = iter_jakob(A,iter,plot_freq)
%[B,RES] = ITER_JAKOB(A,iter,plot_freq) iterates over jakobi 
%          function for matrix A ITER times and plots the 
%          gershgorin function every PLOT_FREQ times, if the 
%          parameter is set to zero, no gershgorin discs are 
%          plotted
%          The residua of A not being a diagonal matrix 
%          are stored in RES
%          see also: JAKOBI, GERSHGORIN

if nargin < 3 || isempty(plot_freq), plot_freq = 0; end
if nargin < 2 || isempty(iter), iter = 100; end

res = zeros(1,iter);

    for k = 1:iter
        A_off_diag = A - diag(diag(A)); % off-diag-elements
    
        [~,lin_ind] = max(abs(A_off_diag(:))); % index of largest ODE
        [i,j] = ind2sub(size(A),lin_ind);
        A = jakobi(A,i,j); % call jakobi function
        
        A_off_diag_sqr = (A - diag(diag(A))).^2;
        res(k) = sum(A_off_diag_sqr(:));
    
        if ~mod(k,plot_freq)
            figure()
            gershgorin(A)
            title([num2str(k),' Iterations'],'FontSize',14)
        end
    end
end