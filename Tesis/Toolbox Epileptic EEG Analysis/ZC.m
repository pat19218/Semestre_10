function [zc] = ZC(eeg, umbral)
signo = 1;
zc=zeros(1,length(eeg)); %(CP)
%mav=[];    %(CP)
totZC=0;
for i = 1:length(eeg)
    signo = sign(eeg(i))+signo;
   
    %Si es positivo %(CP) ;
    if signo == 2
        signo = 1;
        zc(i)=0;

    elseif signo == 0
        totZC=totZC+1;
        zc(i)=1;
        
    elseif signo == -2
        signo = -1;
        zc(i)=0;

    else
        zc(i)=0;
    end 
    % i = i+1; %(CP)
    
end
end



