function [W,H,Hhat,Y,Z,e,t,prpiter,tprp] = accNNSVD_PRP(X,k)
    tstart = cputime;
    [W,H,Hhat,Y,Z] = NNSVD(X,k);    
    tnnsvd = cputime - tstart;
    delta = 0.0001;
    maxiter = 50;
    YTY = Y'*Y;
    ZZT = Z*Z';
    [W,H,Hhat,e,prpiter] = PRP(W,H,Hhat,YTY,ZZT,delta,maxiter);
    t = cputime - tstart;
    tprp = t - tnnsvd;
end
