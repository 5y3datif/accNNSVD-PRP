clear;
addpath('algorithms', 'datasets');
M = load('atnt_faces.mat');
% Uncomment the line number 5 and comment line number 7, if your machine has GPU.
% X = gpuArray(M.X);
% Comment the line number 7, if your machine has GPU and you have already uncomment the line number 5. 
X = M.X;
% you may change the rank of factorization accordingly 
k = 15;
[W,H,Hhat,Y,Z,e,t,prpiter,tprp] = accNNSVD_PRP(X,k);