%% author Mouzakitis Nikolaos
%%        A quick transformation of		       
%% ECG data to R_R peaks using the Pan-Tompkins method.
%%	run in Octave 4.2.2			       

load ecg.mat;
data = val;

t = 1:3600;

figure(1)
plot(t, data)
title('ECG Signal')

%% apply a filter mask in 1 dimension
fdata=data;
n = 5;
for i=1+2*n:3600-2*n

	tmp = 0;

	for j = i-n:i+n
		tmp+=data(j);		
	endfor
	
	fdata(i) = tmp/(2*n+1);
endfor


figure(2)
plot(t, fdata)
title('Filtered')

ddata=zeros(1,3600);
%% Differentiating the fdata signal

for i=2:3600-1
	ddata(i) = fdata(i+1)-fdata(i);
endfor

figure(3)
plot(t, ddata)
title('Differentiated ecg')

%% Squaring signal

sdata = zeros(1, 3600);
for i = 1:3600
	sdata(i) = ddata(i)*ddata(i);
endfor

figure(4)
plot(t, sdata)
title('Squared signal')

n = 30
for i=1+n:3600
	tmp = 0;
	for j= i-n:i
		tmp+=sdata(j);	
	endfor
	wdata(i) = (1/n+1)*tmp;

endfor

figure(5)
plot(t, wdata)
title('Window process')

%%% Normalizing the output in closed [0,1]
lmin = min(wdata);
lmax = max(wdata);
nwdata = zeros(1,3600);

for i = 1:3600
	nwdata(i) = ( wdata(i) - lmin)/(lmax-lmin);
endfor

figure(6)
plot(t, nwdata)
title('Normalized Window process')


%% 

for i = 1:3600
	if( nwdata(i) > 0.6)
		nwdata(i) = .9;
	endif	
	if( nwdata(i) <= 0.6)
		nwdata(i) = .0;
	endif
endfor

figure(7)
plot(t, nwdata)
title('Pulse Wave')


