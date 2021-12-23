function [xf] = STFT(x,lframe,frameshift_ratio,nfft,fused_ratio)
% Function: calculate the STFT coefficients
% Input:	x               - the sensor signal in time domain (nsample*nch)
%           lframe         	- the length of frame(window)
%           frameshift_ratio- the ratio between frame shift and frame length
%           nfft            - the number fft points
%           fused_ratio	- the ratio between used frequency and valid frequency
% Output:	xf              - STFT coefficients (nf*nt*nch)
%
% Author:	Bing Yang, Key Laboratory of Machine Perception, Peking University

[nsample,nch] = size(x);
winshift = round(lframe*frameshift_ratio);
nt = fix((nsample-lframe)/winshift)+1;  % the number of time frames
nfft_valid = (nfft+mod(nfft,2))/2;      % non-repetitive frequency points
nf = ceil(nfft_valid*fused_ratio);      % the number of used frequency points
xf = zeros(nf,nt,nch);
for ch_idx = 1:1:nch
    % window and enframe
    [x_enframed,~] = enframe(x(:,ch_idx),lframe,winshift);	% rectanglar window nT*lwin
    
    % stft  
    for t_idx = 1:nt           
        ftemp = fft([x_enframed(t_idx,:) zeros(1,nfft-lframe)],nfft);
        xf(1:nf,t_idx,ch_idx) = ftemp(1:nf);
    end
end