function [W,H,Hhat,Y,Z] = NNSVD(X,k)

% *********
%   Input
% *********
% X      : input nonnegative m-by-n matrix.
% k      : rank of the sought NMF decomposition.
%
% **********
%   Output
% **********
% (Y,Z)  : rank-p truncated SVD of X so that YZ approximates X, 
%          where p = floor(k/2+1).
% (W,H)  : m-by-k and k-by-n nonnegative matrices s.t. WH are the 
%          corresponding nonnegative elements of YZ.
% Hhat   : k-by-n nonnegative matrix s.t. WHhat equal to WH - YZ.
 

    [~,n] = size(X);
    p = floor(k/2+1); 
    [U,S,V] = svds(X,p); 
    Y = U*sqrt(S); 
    Z = sqrt(S)*V'; 
    % Best rank-one approximation
    W(:,1) = abs(Y(:,1)); 
    H(1,:) = abs(Z(1,:)); 
    Hhat = zeros(k,n); 
    % Next (k-1) rank-one factors
    i = 2; j = 2; 
    while j <= k
        if mod(j,2) == 0
            W(:,j) = max(Y(:,i),0); 
            H(j,:) = max(Z(i,:),0);
            Hhat(j,:) = max(-Z(i,:),0);
        else 
            W(:,j) = max(-Y(:,i),0); 
            H(j,:) = max(-Z(i,:),0);
            Hhat(j,:) = max(Z(i,:),0);
            i = i+1;
        end
        j = j+1; 
    end
    
    % Scale (W,H): this is important for HALS.
    WtYZ = (W'*Y)*Z; 
    WtW = W'*W; 
    HHt = H*H';
end