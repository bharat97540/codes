load('signal12.mat')
%Given parameters
Nsc = 128;Ts = 0.058;Fc = 10^(4);Ncp = 20;Fs = 44100;F_delta = Ts^(-1);

%Downconversion
mi = R.*cos(2*pi*Fc*t);
mq = -R.*sin(2*pi*Fc*t);

%low pass filter
bandwidth_low_pass = (Nsc*F_delta)/2;
[b,a] = butter(8,(bandwidth_low_pass/(Fs/2)));

FilteredSignal_re= filter(b,a,mi);
FilteredSignal_im= filter(b,a,mq);

fill = FilteredSignal_re + 1j*FilteredSignal_im;%filtered Signal

%Downsample
Tcp = (Ncp*Ts)/Nsc;
Tofdm = Ts + Tcp;
downsample_factor = floor((Tofdm*Fs)/(Nsc+Ncp)) + 1;
downsampled = fill(1:downsample_factor:length(fill));

figure
plot(abs(downsampled))
%Synchronization

for t = 1:length(downsampled)-Nsc
    
   crr = corrcoef(downsampled(t:(Nsc/2)-1+t),downsampled((Nsc/2)+t:Nsc-1+t));
   cr_r(t) = crr(2,1);
   
end
figure
plot(abs(cr_r))
hold on
plot(real(cr_r),'--')
%pilot Extraction
start = find(cr_r==max(cr_r)) - 2;% starting a bit early to ensure never miss the data symbol
stop = start+Nsc-1;
pilot = fft(downsampled(start:stop));%converting to frequency domain

%Transmitted pilot
x = [zeros(1,128)];
randn('state',100);
P = sign(randn(1,Nsc/2));
x(1:2:end) = 2*P;

%Channel Estimation and Interpolation
b=1:2:128;
channel(b) = pilot(b)./x(b);

cv = 2:2:127;
channel(cv) = (channel(cv-1) + channel(cv+1))/2;
   
channel(128)= channel(127);

%Extraction of length m
Vl = downsampled(stop+Ncp+1:stop+Nsc+Ncp);
Vl_end = stop+Nsc+Ncp;

%calibration
cali = fft(Vl)./channel;

%decoding
decision = decoding(cali);

%convolutional decoder
ConstraintLength = 6;
trellis = poly2trellis(ConstraintLength,[77 45]);
deco = vitdec(decision(1:30),trellis,ConstraintLength,'term','hard');

%decoding of OFDM symbols
d = 1;
Length_m = (bi2de(deco(1:10)))*7;%obtaining the sample length from ASCII length found above.
N_OFDM_S = floor(Length_m/128) + 1;%Number of OFDM symbol required to decode.
final_dec = [];

for i=1:N_OFDM_S
samples = downsampled(Vl_end+Ncp+1:Vl_end+Ncp+Nsc);

cali_samples = fft(samples)./channel;
decision_samples = decoding(cali_samples);
final_dec(d:2*i*Nsc) = decision_samples;

d = d+2*Nsc;
Vl_end = Vl_end + Nsc+Ncp;
end

deco_samples = vitdec(final_dec,trellis,ConstraintLength,'term','hard');
final_dec = deco_samples(1:Length_m);

% Decimal to ASCII
wh=2.^[6:-1:0];
m=char(final_dec(1:7)*wh');
for l=2:floor(length(final_dec)/7)
m=[m char(final_dec(7*(l-1)+1:7*l)*wh')];         
end
m

%QPSK Decoding function
function f = decoding(n)
   r_re = real(n);r_im = imag(n);
  qwa_re = r_re;
  qwa_im = r_im;

  dece = qwa_re;
  dece(2,:) = qwa_im;
  dece = dece(:).';

  dece( dece > 0 ) = 0;
  dece( dece < 0 ) = 1;
  f = dece;

end
