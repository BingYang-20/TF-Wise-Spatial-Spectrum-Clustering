 function [spec] = TFSpatSpect(pnp_evec,sv,flag)
% Function: calculate the TF-wise spatilal spectrum
% Input:	pnp_evec    - ranked eigenvectors with the first column is pe (nch*nch*nf*nt)
%           sv          - the steering vector (nch*ndoa*nf)
%           flag        - the flag for different kinds of spatial spectrum
%                         'pe_et': signal subspace with exponential transform
% Output:	spec        - TF-wise spatilal spectrum (nf*nt*ndoa)
%
% Author:	Bing Yang, Key Laboratory of Machine Perception, Peking University

[~,~,nf,nt] = size(pnp_evec);
[~,ndoa,~,~] = size(sv);
spec = zeros(nf,nt,ndoa);

if (strcmp(flag,'pe_et'))
    beta = 0.1;
    for t_idx = 1:nt
        for f_idx = 1:nf
            e = sv(:,:,f_idx);
            p = pnp_evec(:,1,f_idx,t_idx);                 
            pH = conj(permute(p,[2 1]));
            cos_sim = abs(pH*e)./norm(pH)./sqrt(dot(e,e));
            spec(f_idx,t_idx,:) = exp(-(cos_sim-1).^2./(2*beta^2));
        end
    end
    
else 
  	disp('TFSpatSpect parameter error!');
end