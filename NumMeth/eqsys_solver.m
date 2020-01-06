function [X, FLAG, RES, ITER] = eqsys_solver(A, varargin)
% EQSYS_SOLVER Numerically solve a system of linear equations
%   X = EQSYS_SOLVER(A) returns the numerical solution of the system Ax = 0
%
%   X = EQSYS_SOLVER(A,b) is the same as x = EQSYS_SOLVER(A) with the
%   right side of the equation being b
%   
%   X = EQSYS_SOLVER(A,b,omega) is used only for the 'SOR'-algorithm
%   (s.u.)
%
%   X = EQSYS_SOLVER(A,b,omega,x0) uses x0 as a starting vector for the 
%   algorithm 'GS' or 'SOR'
%
%   X = EQSYS_SOLVER(...) with any of the previous you can specify the
%   following:
%               'tol' ... (num < 1) toleranz for the accuracy of the 
%               solution, 'tol' specifies the ratio of X and its change to 
%               the X in the previous iteration
%
%               'maxit' ... (num > 1) maximum number of iterations for the 
%               algorithm
%
%               'solver' ... (string) decide whether to use the 
%               Gauss-Seidel-Method ('GS'), the Gauss-Jordan-Method ('GJ')
%               or the
%               Successive-Overrelaxation-Method ('SOR')
%
%   [X,FLAG] = EQSYS_SOLVER(...) returns a FLAG, an integer corresponding
%   to the following meanings:
%                               0 algorithm finished successfully
%                               1 error occured during the process
%                               2 only the trivial solution x = 0 was found
%                               3 the maximum number of
%                                 iterations was exeeded without x 
%                                 converging as desired
%
%   [X,FLAG,RES] = EQSYS_SOLVER(...)  returns a vector of length 'maxit'
%   where each element corresponds to the relative accuracy of the vector X
%   in each iteration (only for "GS" and "SOR")
%
%   [X,FLAG,RES,ITER] = EQSYS_SOLVER(...) returns the number of iterations
%   performed (only for "GS" and "SOR")

FLAG = 1;

% INPUTS
    [b,x0,omega,tol,maxit,solver] = input_handler(A,varargin);
       
    
% The routines are distinguished:
if strcmp('GJ',solver)
    % GAUSS JORDAN 
    
    mat = [A,b];
    
    % Preconditioning the matrix so that the greatest elements are on the
    % diagonal
        for kond_ind = 1:(size(mat,2)-1)
            [~,line_ind] = max(mat(kond_ind:end,kond_ind));
            line_ind = line_ind + kond_ind - 1;
            mat([kond_ind,line_ind],:) = mat([line_ind,kond_ind],:);
        end
        
    % Gauss Jordan pivot
        for down_ind = 1:size(mat,1)
            mat(down_ind,:) = mat(down_ind,:)/mat(down_ind,down_ind);
            current_line = mat(down_ind,:);
            
            for sub_ind = (down_ind + 1):size(mat,1)
                mat(sub_ind,:) = mat(sub_ind,:) - ...
                                 current_line*mat(sub_ind,down_ind);
            end
        end
        for up_ind = size(mat,1):-1:1
            current_line = mat(up_ind,:);
            
            for sub_ind = (up_ind - 1):-1:1
                mat(sub_ind,:) = mat(sub_ind,:) - ...
                                 current_line*mat(sub_ind,up_ind);
            end
        end
      
    % Because we now have 1*x = b', our x can be identified as the modified
    % b-vector
        X = mat(:,end);
        
else
    % GAUSS SEIDEL / SOR
    n = size(A,2);
    X = reshape(x0,[n,1]);
    RES = zeros(1,maxit);
    RES_abs = zeros(1,20);
    
    current_res = tol + 1;
    ITER = 0;

    while (current_res > tol) && (ITER < maxit)
    
    % If SOR is chosen, the algorithm tries to find the optimal value for
    % omega within the first 20 iterations, after that, it sets omega to be
    % that value after which it continues the iteration
        if (ITER == 20) && strcmp('SOR',solver)
            omega = 2/(1+sqrt(1-abs(RES_abs(ITER))/abs(RES_abs(ITER-1))));
        end
    
        x_prev = X; % Store the previous value for calculation residue
    
    % Gauss-Seidel fixpoint     
        for i = 1:n
            X(i) = X(i) - omega*...
                      (X(i) + (A(i,1:n)*X - A(i,i)*X(i) - b(i))/A(i,i));
        end
        
    % Calculation residues    
            current_res_abs = norm(X-x_prev);
            current_res = max(current_res_abs./norm(X));
            
    % Incrementing the ITER counter and storing the residues     
            ITER = ITER + 1;
            RES(ITER) = current_res;
            RES_abs(ITER) = current_res_abs;
    end

        RES = RES(1:ITER);
        
    if ITER == maxit
        FLAG = 3;
    end
end

    if all(X == zeros(size(X)))
        FLAG = 2;
    else
        FLAG = 0;
    end

end

