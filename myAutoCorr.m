function [y,k] = myAutoCorr(u,normalize,cutoff)
%MYAUTOCORR Summary of this function goes here
%   Detailed explanation goes here

kmax = numel(u);
y=zeros(1,kmax+1);
k = 0:kmax;

% loop through all possible offsets not equal to 0
for i=k

    % loop through signal, multiply by itself offset and sum
    for j=1:kmax
        if j-i>0 && j-i<kmax
            y(i+1) = y(i+1) + u(j)*u(j-i);
        end 
    end
    y(i+1) = y(i+1)/(kmax-i); % normalize to amount of data overlapping
    
end

%cut off end cutoff percentage
if cutoff < 1
    y = y(1:round(kmax*cutoff));
    k = k(1:round(kmax*cutoff));
end

if normalize
    y = y/max(y);
end


end

