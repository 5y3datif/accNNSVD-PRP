function [W,H,Hhat,e,t] = PRP(W,H,Hhat,YTY,ZZT,delta,maxiter)

% *********
%   Input
% *********
% W,H,Hhat  : m-by-r, r-by-n and r-by-n nonnegative matrices
% --- Optional ---
% delta  : stoppong parameter for the low-rank correction (default: 0.05).
% maxiter: maximum number of iteration for the low-rank correction 
%           (default: 20).
%
% **********
%   Output
% **********
% W,H,Hhat  : Updated W,H,Hhat matrices using single Nesterov Gradient 
%             acceleration on WHat = (YZ -WH)
% e         : relative error ||YZ-WH||_F/||YZ||_F of the initialization (W,H)
%             throughout the low-rank correction updates.
% k         : number of iterations

    if nargin <= 5
        delta = 0.00001;
    end
    if nargin <= 6
        maxiter = 20;
    end
    
%     W = (W > 0).*W + 1e-12*(W == 0);
    H = (H > 0).*H + 1e-12*(H <= 0);
    Hhat = (Hhat > 0).*Hhat - 1e-12*(Hhat == 0);
        
    Hprev = H;
    V = H;
    Vhat = Hhat;
    alpha = 1;
    e = zeros(maxiter,1);
    WTW = W'*W;
    HhatHhatT = Hhat*Hhat';
    nYZ = sqrt( sum (sum((YTY).*(ZZT))));
    nWHhat = sqrt(sum(sum((WTW).*(HhatHhatT))));
    e0 = nWHhat/nYZ;
    e = e0;
    ePrev = e0; 
    L = norm(WTW);
    t = 1;
    while (t == 1 || ePrev-e > delta*e0) && t <= maxiter
        deltaH = min(V, ((1/L)*2*WTW*Vhat));
        H = ((V - deltaH) ~= 0).*(V - deltaH) + 1e-18*((V - deltaH) == 0);
        Hhat = ((Vhat - deltaH) ~= 0).*(Vhat - deltaH) + 1e-18*((Vhat - deltaH) == 0);

        % Computing error
        HhatHhatT = Hhat*Hhat';

        nWHhat = sqrt(sum(sum((WTW).*(HhatHhatT))));
        ePrev = e;
        e = nWHhat/nYZ;
        
        % Applying Nesterov momentum
        alphaNew = (1 + sqrt(4*alpha^2 + 1))/2;
        
        if alpha == 1
            V = H;
            Vhat = Hhat;
        else
            V = H + ((alpha -1)/alphaNew)*(H - Hprev);        
            Vhat = Hhat + ((alpha -1)/alphaNew)*(H - Hprev);

            VhatVhatT = Vhat*Vhat';

            nWVhat = sqrt(sum(sum((WTW).*(VhatVhatT))));
            
            eV = nWVhat/nYZ;
            
            %Hot restart
            if (e - eV) < 0
                V = H; Vhat = Hhat; alphaNew = 1;
            end
        end
        
        % Prepare for next itertion.
        Hprev = H;
        alpha = alphaNew;
        t = t+1;
    end
    
    H = (H ~= 1e-18).*H;
    Hhat = (Hhat ~= 1e-18).*Hhat;
end
