function properties = gershgorin(M,flag,tol)
%PROPERTIES = GERSHGORIN(M,FLAG,TOL) visualizes an estimation of 
%             the eigenvalues of the square matrix M,
%             the FLAG argument turns the plot of the exact eigenvalues on
%             or off (those are calculated with matlab's eig-function)
%
%             the output PROPERTIES is a structure of the matrix M's
%             properties, those are checked with an accuracy of TOL

if nargin < 3 || isempty(tol), tol = 10^-10; end
if nargin < 2 || isempty(flag), flag = 0; end

midpoints = diag(M); % Circle Centers are on the diagonal
radii_lines = sum(abs(M),2) - abs(midpoints);
radii_columns = sum(abs(M),1) - abs(midpoints');
r = min([radii_lines';radii_columns],[],1);

phi = linspace(0,2*pi,100);

% Functions for coordiants calculation
    x = @(m,r) real(m) + r*cos(phi); 
    y = @(m,r) imag(m) + r*sin(phi);


    for k = 1:length(midpoints)
        p(k) = plot(x(midpoints(k),r(k)),y(midpoints(k),r(k)));
        hold on         
    end
    
    axis equal
    set(p,'Color','b')
    xlabel('Re(z)','FontSize',14)
    ylabel('Im(z)','FontSize',14)
    grid on
    
    if flag
        EW = eig(M);
        plot(real(EW),imag(EW),'kx')
    end
    
    hold off
    
    if nargout
        properties = struct('unitary',false,...
                            'normal',false,...
                            'singular','unknown',...
                            'hermite',false,...
                            'symmetrical',false,...
                            'diagonal',false,...
                            'diagonal_dom',false,...
                            'sparsity',1);
        
        % Unitarity
        if all(all(abs(eye(size(M)) - M'*M) < tol))
            properties.unitary = true;
        end
        
        % Normality
        if all(all(abs(M'*M - M*M') < tol))
            properties.normal = true;
        end
        
        % Singularity
        if ~any(abs(midpoints').^2 <= r.^2)
            properties.singular = false;
        end
        
        % Hermiticity
        if all(all(abs(M' - M) < tol))
            properties.hermite = true;
        end
        
        % Symmetry
        if all(all(abs(M.' - M) < tol))
            properties.symmetrical = true;
        end
        
        % Diagonal Matrix
        if all(all(abs(M - diag(diag(M))) < tol))
            properties.diagonal = true;
        end
        
        % Diagonal Dominancy
        if all(abs(diag(M).') > abs(sum(M,1) - diag(M).'))
            properties.diagonal_dom = true;
        end
        
        % Sparsity
        L = M < tol;
        properties.sparsity = sum(L(:))/numel(M);
    end

end