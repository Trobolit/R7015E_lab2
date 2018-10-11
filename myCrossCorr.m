function [y,k] = myCrossCorr(u1, u2,normalize,cutoff)
%MYAUTOCORR numel u1 > numel u2
%   Detailed explanation goes here

if numel(u2) > numel(u1)
    error('u2 larger than u1, error');
end
kmax = numel(u1);
k2max = numel(u2);
y=zeros(1,kmax+1);
k = 0:kmax;

%TODO ::: Fix offsets in for loops.

% loop through all possible offsets which sum does not equal 0
for i=k
    % loop through signal, multiply by itself offset and sum
    for j=-k2max:k2max
        if j-i>0 && j-i<k2max
            y(i+1) = y(i+1) + u1(j)*u2(j-i);
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

