function [wtf, pnp_evec] = SinSouTF(xf,tf_ad,th,way)
% Function: provide the binary TF weight for single source dominated TF bins, 
%           and the ranked eigenvectors of spatial correlation matrix
% Input:	xf          - the STFT of signal (nf0*nt0*nch)
%           tf_ad       - tf_ad(:,1) stores the number of time frames and frequency bins used for approximation of expectation,
%                         tf_ad(:,2) stores the shift of time frames and frequency bins
%       	th          - the threshold for selecting signle source dominant bins
%           way         - the method to count and localize sources
%                         'dpdt_dn': direct path dominance test with denoising
% Output:	wtf         - binary TF weight (nf*nt)
%           pnp_evec	- ranked eigenvectors with the first column is pe (nch*nch*nf*nt)
%
% Author:	 Bing Yang, Key Laboratory of Machine Perception, Peking University

[nf0,nt0,nch] = size(xf);
lt = tf_ad(1,1); dt = tf_ad(1,2);  
lf = tf_ad(2,1); df = tf_ad(2,2);  
nt = fix((nt0-lt)/dt)+1; 
nf = fix((nf0-lf)/df)+1; 
pnp_evec = zeros(nch,nch,nf,nt); 
ratio = zeros(nf,nt);
for t_idx = 1:nt
    for f_idx = 1:nf
        t_sta = (t_idx-1)*dt+1; t_end = min([(t_idx-1)*dt+lt,nt0]);
        f_sta = (f_idx-1)*df+1; f_end = min([(f_idx-1)*df+lf,nf0]);
        
        XF = zeros(nch,lt*lf);
        for ch_idx = 1:nch
            xf_set = xf(f_sta:f_end, t_sta:t_end, ch_idx);
            XF(ch_idx,:) = xf_set(:); % expanding
        end
        
        if (strcmp(way,'dpdt_dn'))
            C0 = XF*conj(permute(XF,[2 1]))/(lt*lf);
            C0 = DeNoise(C0,'tnm');
            [evec, eval] = eig(C0);
            [val, idx] = sort(abs(diag(eval)),'descend');
            pnp_evec(:,:,f_idx,t_idx) = evec(:,idx);
            ratio(f_idx,t_idx) = val(1)./val(2);

        else
            disp('SinSouTF parameter error!');
        end
        
    end
end
wtf = ratio>th;