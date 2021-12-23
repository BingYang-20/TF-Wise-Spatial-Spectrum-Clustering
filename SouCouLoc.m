function [doa_est] = SouCouLoc(wtf,func,doa_set,way,th)
% Function: joint count and localize sound sources
% Input:	wtf    	- the weight for single source dominated TF bins (nf*nt)
%       	func 	- the function related to candidate DOAs (nf*nt*ndoa)
%       	doa_set	- the candidate DOAs (1*ndoa)
%           way  	- the method to count and localize sources
%                     'ssc'  : spatial specttrum clustering [1]
%         	th     	- the threshold if needed
% Output:	doa_est	- DOA estimates (K*1)
%
% Reference: [1] B. Yang, H. Liu, C. Pang, and X. Li, "Multiple sound source counting and localization based on TF-wise spatial spectrum clustering," 
%            IEEE/ACM Transactions on Audio, Speech, and Language Processing, vol. 27, no. 8, pp. 1241¨C1255, 2019.
% Author:    Bing Yang, Key Laboratory of Machine Perception, Peking University
% History:   2020-02-10 - Initial version
% Copyright Bing Yang

[nf,nt,ndoa] = size(func);
ntf = sum(sum(wtf));

if (strcmp(way,'ssc'))
    % first remaining determination
    wr = wtf;
    % first new source detection
    k_temp = 1;
    func_r(:,k_temp) = sum(sum(repmat(wr,[1,1,ndoa]).* func,1),2);
    [costr,doa_idx_temp(k_temp,1)] = max(func_r(:,k_temp));
    
    max_k = 10;
    while(k_temp<max_k) % external iteration 
        
        % association adjustment        
        max_iter = 5;
        iter_idx = 0;
        costk = 0;
        while(iter_idx<max_iter) % internal iteration
            iter_idx = iter_idx+1;
            % TF bin assignment
            wk = zeros(nf,nt,k_temp);
            for t_idx = 1:nt
                for f_idx = 1:nf
                    if(wtf(f_idx,t_idx)>0)
                        values = func(f_idx,t_idx,doa_idx_temp(:,1));
                        [peak,k_idx] = max(values);
                        if (peak>th)
                            wk(f_idx,t_idx,k_idx) = 1;
                        end
                    end
                end
            end
            % DOA estimation
            func_k = zeros(ndoa,k_temp);
            costk_pre = costk;
            costk = 0;
            for k_idx = 1:k_temp
                func_doa_weighted = repmat(wk(:,:,k_idx),[1,1,ndoa]).* func;
                func_k(:,k_idx) = sum(sum(func_doa_weighted,1),2);
                [costk_temp,doa_idx_temp(k_idx,1)] = max(func_k(:,k_idx));
                costk = costk + costk_temp;
            end
            % stop criterion
            delta = 1;      % adjustable
            if (abs(costk-costk_pre)<delta)
                break;
            end
        end
        
        % remaining determination
        wr(:,:,k_temp+1) = 1-sum(wk,3);
        func_doa_weighted = repmat(wr(:,:,k_temp+1).*wtf,[1,1,ndoa]).* func;
        func_r(:,k_temp+1) = sum(sum(func_doa_weighted(:,:,:),1),2);
        costr_pre = costr;
        % new source detection
        [costr,doa_idx_temp(k_temp+1,1)] = max(func_r(:,k_temp+1));
        
        % stop criterion
        gama = [ntf*0.02,ntf*0.003];     % adjustable
        ntf_d = sum(sum(abs(wr(:,:,k_temp+1)-wr(:,:,k_temp))));
        costr_d = abs(costr-costr_pre);
        if k_temp~=1 && ((ntf_d<gama(1)) || (costr_d<gama(2)))
            break;
        end
        
        k_est = k_temp;
        doa_idx_est = doa_idx_temp(1:k_est);
        k_temp = k_temp+1;
    end
    doa_est = doa_set(doa_idx_est)';

else
    disp('SouCouLoc parameter error!');
end
