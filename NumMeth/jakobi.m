function A_new = jakobi(A,i,j)
%B = JAKOBI(A,i,j) performs jakobi-rotations on matrix A 
%                  for matrix elements i and j

% calculating phi
    if logical(A(i,i) - A(j,j))
        phi = atan(2*A(i,j)/(A(i,i)-A(j,j)))/2;
    else
        phi = pi/4;
    end
    
% generating rotational matrix    
    rot_mat = [cos(phi), -sin(phi); sin(phi), cos(phi)];
  
% find indices of rotaional matrix spots    
    rot_ind = sub2ind(size(A),[i,j,i,j],[i,i,j,j]);

% Unity with rotational matrix at the right spots    
    U = eye(length(A));
    U(rot_ind) = rot_mat;

% transforming A    
    A_new = U'*A*U;
end