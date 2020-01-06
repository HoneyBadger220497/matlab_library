function [b,x0,omega,tol,maxit,solver] = input_handler(A,in)
  % INPUT_HANDLER is used in EQUSYS_SOLVER to handle inputs, not to be used as
  % standalone ...

% searching b
    val_b = @(s) isnumeric(s) && (length(s(:)) == size(A,2));
    L_b = cellfun(val_b,in);
    ind_b = find(L_b,1);
        if any(L_b)
            b = reshape(in{ind_b},[size(A,2),1]);
            in(ind_b) = [];
        else
            b = zeros(size(A,2));
        end

% searching solver
    val_solv = @(s) ischar(s) && any(strcmp({'GS','SOR','GJ'},s));
    L_solv = cellfun(val_solv,in);
    ind_solv = find(L_solv,1);
        if any(L_solv)
            solver = in{ind_solv};
            in(ind_solv) = [];
        else
            solver = 'GS';
            disp('GS algorithm is used')
        end

% searching x0
    val_x0 = @(s) isnumeric(s) && (length(s(:)) == size(A,2));
    L_x0 = cellfun(val_x0,in);
    ind_x0 = find(L_x0,1);
        if any(L_x0)
            if strcmp('GJ',solver)
            % warning that x0 cannot be used with gauss-jordan
            warning(['Input argument "x0" can"t be used with this solver',...
                ' routine. Choose "SOR" or "GS" if you want to use a ',...
                'starting vector for the iteration'])
            else
                x0 = reshape(in{ind_x0},[size(A,2),1]);
                in(ind_x0) = [];
            end
        else
            x0 = zeros(size(A,2),1);
        end

% searching omega
    val_omega = @(s) isnumeric(s);
    L_omega = cellfun(val_omega,in);
    ind_omega = find(L_omega,1);
        if any(L_omega)
            if ~strcmp('SOR',solver)
            % warning that omega has to be set to 1 if the chosen routine
            % is any other than SOR
             warning(['Input argument "omega" can"t be used with this solver',...
                ' routine. Choose "SOR" if you want to use a value',...
                ' for omega other than 1'])

            % finally omega is forced to be 1
                omega = 1;
                in(ind_omega) = [];
            else
                omega = in{ind_omega};
                in(ind_omega) = [];
            end
        else
            omega = 1;
        end

% searching tol
    val_tol = @(s) isnumeric(s) && (s < 1);
    L_tol = cellfun(val_tol,in);
    ind_tol = find(L_tol,1);
        if any(L_tol)
            tol = in{ind_tol};
            in(ind_tol) = [];
        else
            tol = eps;
        end

% searching maxit
    val_maxit = @(s) isnumeric(s) && (s > 1);
    L_maxit = cellfun(val_maxit,in);
    ind_maxit = find(L_maxit,1);
        if any(L_maxit)
            maxit = in{ind_maxit};
            in{ind_maxit} = [];
        else
            maxit = 10^4;
        end
end
