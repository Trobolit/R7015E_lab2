
%% Part 1
[u, y] = textread('Dataset1.txt','%f %f');
Ts = 0.080;

% Cross corr between u and y
Ruy = xcorr(u,y);

% Autocorr on u
Ru_vec = xcorr(u,u);
Rumtx = corrmtx(u,999,'autocorrelation');

% Form sys:
% Ruy(1) = | Ru(0), Ru(1) ... | |g(1)|
% Ruy(2) = | Ru(1), Ru(2) ... | |g(2)|
% ... .. ...
Ru = zeros(numel(Ru_vec),numel(Ru_vec));
for i=1:numel(Ru_vec)
    for j=1:numel(Ru_vec)
        if(i+j-1) <= numel(Ru_vec)
            Ru(i,j) = Ru_vec(i+j-1);
        end
    end
end

% Then Least squares for g?
% This by Ru-1 * Ruy?
g = Ru\Ruy;
gpseudo = pinv(Ru) * Ruy;
gmtx = Rumtx\Ruy;
gpmtx = pinv(Rumtx)*Ruy;

%Toeplitz ???

%% plot

figure(1);
hold on;
%loglog(abs(fft(g)));
%loglog(abs(fft(gpseudo)));
%loglog(abs(fft(gmtx)));
%loglog(abs(fft(gpmtx)));
subplot(2,1,1);
semilogx(20*log10(abs(fft(gpmtx))));
subplot(2,1,2);
semilogx(phase(fft(gpmtx)));
hold off;

figure(2);
hold on;
subplot(2,1,1);
plot(y);
subplot(2,1,2);
plot(u);
hold off;

%% Prt 2

Ghathat = fft(u).\fft(y);
figure(3);
hold on;
subplot(2,1,1);
semilogx(20*log10(abs(Ghathat)));
subplot(2,1,2);
semilogx(phase(Ghathat));
hold off;
%% Part 3
bsize = 2^4;
%Gsmooth = conv(bartlett(bsize),Ghathat) / sum(bartlett(bsize)); % has bad
%effects at endpoints of data due to zeros being averiaged together with
%small amounts of data. Below solves that.
Gsmooth = conv(bartlett(bsize),Ghathat.*abs(fft(u)).^2) ./ conv(bartlett(bsize),abs(fft(u)).^2);
figure(4);
hold on;
subplot(2,1,1);
semilogx(20*log10(abs(Gsmooth)));
subplot(2,1,2);
semilogx(phase(Gsmooth));
hold off;


%% What?
y = normrnd(0,10,[1,1000])+5*sin(linspace(0,100,1000));
figure(1);
plot(y);

figure(2);
[AC,offset] = myAutoCorr(y, true ,0.8);
plot(offset,AC);

figure(3);
[AC,offset] = myCrossCorr(y,5*sin(0:0.1:10), true ,0.8);
plot(offset,AC);