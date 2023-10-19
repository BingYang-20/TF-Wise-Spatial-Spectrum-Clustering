function [doa_est] = MSSL(x)
% Function: Multiple sound source localization
% Input:	x       - the sensor signal in time domain (nsample*nch)
% Output:	doa_est	- DOA estimates

% Reference: B. Yang, H. Liu, C. Pang, and X. Li, "Multiple sound source counting and localization based on TF-wise spatial spectrum clustering," 
%            IEEE/ACM Transactions on Audio, Speech, and Language Processing, vol. 27, no. 8, pp. 1241-1255, 2019.
% Author:    Bing Yang, Key Laboratory of Machine Perception, Peking University
% History:   2020-02-10 - Initial version
% Copyright Bing Yang

% trnsform into TF domain
Fs = 16000;
lframe = round(Fs*0.032);  	% frame length = 32ms/512samples
frameshift_ratio = 0.5;   	% frameshift_ratio = frame shift/lframe
nfft = lframe;           	% fft number
fused_ratio = 4000/(Fs/2);	% fused_ratio = used frequency/valid frequency; using 0-4kHz
[xf] = STFT(x,lframe,frameshift_ratio,nfft,fused_ratio);

% compute the TF weight and eigenvectors
tf_ad = [4,1;8,4];
th = 3;
[wtf, evec] = SinSouTF(xf,tf_ad,th,'dpdt_dn');

% constrct the TF-wise spatial spectrum
load('sv.mat');   % steering vector 
[spec] = TFSpatSpect(evec,sv,'pe_et');

% count and localize sound sources
doa_set = 1:1:360;
[doa_est] = SouCouLoc(wtf,spec,doa_set,'ssc',0.5);


