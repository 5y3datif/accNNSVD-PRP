clear;
addpath('algorithms', 'datasets');
% Test number of negative elements in W and H. X is generated using random number.
m = 500;
n = 1000;
% Number of runs for the test
runs = 25;
% Stores Number of negative elements in X, W and H
% All three vectors are initialized to all ones vector but
% after successfull execution of the following code all three vectors 
% become all zeros vector.
no_neg_x = ones(runs,1);
no_neg_w = ones(runs,1);
no_neg_h = ones(runs,1);
% you may change the rank of factorization accordingly 
k = 15;
for ii=1: runs
    % Uncomment the line number 19 and comment line number 21, if your machine has GPU.
    % X = gpuArray(100*rand(m,n));
    % Comment the line number 21, if your machine has GPU and you have already uncomment the line number 19.
    X = 100*rand(m,n);
    % Number of negative elements in X
    no_neg_x(ii) = nnz(min(X,0))/(m*n);
    [W,H,Hhat,Y,Z,e,t,prpiter,tprp] = accNNSVD_PRP(X,k);
    % Number of negative elements in W and H
    no_neg_w(ii) = nnz(min(W,0))/(m*k);
    no_neg_h(ii) = nnz(min(H,0))/(k*n);
end
if ~isempty(find(no_neg_x,1,'first'))
    fprintf("X in the %dth run contain negative entries.\n", find(no_neg_x,1,'first'));
else
    fprintf("X has no negative entries.\n");
end

if ~isempty(find(no_neg_w,1,'first'))
    fprintf("W in the %dth run contain negative entries.\n", find(no_neg_w,1,'first'));
else
    fprintf("W has no negative entries.\n");
end

if ~isempty(find(no_neg_h,1,'first'))
    fprintf("H in the %dth run contain negative entries.\n", find(no_neg_h,1,'first'));
else
