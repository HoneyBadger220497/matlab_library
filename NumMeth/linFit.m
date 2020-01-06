function [k,dk,d,dd] = linFit(x,y,dx,dy)
  % [K,dK,D,dD] = LINFIT(X,Y,dX,dY) performs a linear fit of X and Y with errors
  % dX and dY taken into account and returns the slope of the line K (with error
  % dK) as well as the line's y-intercept D (with error dD).
  % If one doesn't specify dX (empty array), only the error of Y is used; the
  % same goes for dY

    if nargin > 2
      if isempty(dx), dx = 0; end
      if nargin < 4 || isempty(dy), dy = 0; end
        
        g = 1./(dy + dx).^2;
    else
        g = ones(size(x));
    end
    beta = [sum(g.*y.*x);g.'*y];
    A = [g.'*(x.^2),g.'*x;g.'*x,sum(g)];
    a = A\beta;

    C = inv(A);

    k = a(1);
    d = a(2);
    dk = sqrt(C(1,1));
    dd = sqrt(C(2,2));

end
