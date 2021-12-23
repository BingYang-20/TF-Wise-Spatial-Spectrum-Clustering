function [scm_denoised] = DeNoise(scm,way)
% Function: remove noise from spatial correlation matrix 
% Input:	scm          - the spatial correlation matrix
%           way          - the method to denoise
%                          'tnm' - trace norm minimization [1]
% Output:	scm_denoised - the denoised spatial correlation matrix 
%
% Reference: [1] N. Ito, E. Vincent, N. Ono, and S. Sagayama, "Robust estimation of directions-of-arrival in diffuse noise based on matrix-space sparsity,"
%            INRIA,Le Chesnay, France, Res. Rep. RR-8120, 2012.   
% Author:    Bing Yang, Key Laboratory of Machine Perception, Peking University

M = size(scm,1);
dftm = exp(-1j*2*pi/M).^((0:M-1)' * (0:M-1));
P = dftm/sqrt(M);
PH = conj(permute(P,[2 1]));
if (strcmp(way,'tnm'))
    K = 20;
    th = 0.01;
    Y0 = PH * scm * P;
    C_off = P * (Y0.*~eye(M)) * PH;
    C_pre = scm;
    C = C_pre;
    t_pre = 1;
    t = t_pre;
    k = 0;
    while(1)
        mu = max(0.7^k,10^(-4))*norm(C_off,'fro');
        Z = C + (t_pre-1)/t*(C-C_pre);
        Y = P * ((PH * Z * P).*eye(M)) * PH + C_off;
        Y = ( triu(Y,0) + conj(permute(triu(Y,1),[2 1]))+...
            tril(Y,0) + conj(permute(tril(Y,-1),[2 1])) )*0.5; % trick; hermitian
        [yvec, yval] = eig(Y);
        C_pre = C;
        C = yvec * max(real(yval)-mu*eye(M),0) * conj(permute(yvec,[2 1])); % trick: real
        t_pre = t;
        t = (1+sqrt(1+4*t_pre^2))/2;
        k = k+1;
        if((k>K)||(norm(C-C_pre,'fro')/norm(C_pre,'fro')<th))
            break;
        end
    end
    scm_denoised = C;
 
else
    disp('DeNoise parameter error!');
end
