load('Signal10.mat')
%Given parameters
Fc=4000; Ts=0.002267;Fs = 44100;

%Baseband Pulse generation
t0=0:0.00002267:Ts;
pulse = sin((pi*t0)/Ts);

%Pilot symbol at transmitter
pilot = 2 + 1j*2;

mi= [zeros(1,length(R))];mq = [zeros(1,length(R))];

%Downconversion of the received signal into inpahse and quadrature components
for m = 1:length(R)
    
    mi(m) = R(m).*cos(2*pi*Fc*(m/Fs));%Inphase
    mq(m) = -R(m).*sin(2*pi*Fc*(m/Fs));%Quadrature
    
end

mi = filter(pulse,1,mi);
mq = filter(pulse,1,mq);

%Envelope generation
em = sqrt((mi.^2) + (mq.^2));

%finding the first pilot using threshold
s = 0;%sum

for u = 1:length(em)
    
    s = s + em(u);
    
    ti = s/u;  %average_sum
    if em(u)/ti > 9.8  %if envelope to average noise ratio greater than threshold, pilot found
        break;
    end
    
end

% channel estimation
alpha = mi(u) + 1j*mq(u);%sample 'u' contains pilot start
channel = alpha/pilot; 

b = 1;
%QPSK decoding while the algorithm simultaneously checks for the end pilot
for x = u+100:100:length(em)

 if em(x)/ti > 9.3 %This is to detect second pilot
    %ASCII conversion of remaning bits if left, when the end pilot is found 
    dece = [dece zeros(7-length(dece))]; 
    wh=2.^[6:-1:0];
    m=char(dece(1:7)*wh');
    for l=2:floor(length(dece)/7),
    m=[m char(dece(7*(l-1)+1:7*l)*wh')];         
    end
    m
    break;
 end
    %channel calibration
    r(b) = (mi(x) + 1j*mq(x))./channel;

   %QPSK decoding
 r_re = real(r);r_im = imag(r);
 qwa_re = r_re;
 qwa_im = r_im;

 dece = qwa_re;
 dece(2,:) = qwa_im;
 dece = dece(:).';

 dece( dece > 0 ) = 0;
 dece( dece < 0 ) = 1;

 %ASCII conversion
 if (mod(length(dece),7)) == 0
 wh=2.^[6:-1:0];
 m=char(dece(1:7)*wh');
 for l=2:floor(length(dece)/7),
 m=[m char(dece(7*(l-1)+1:7*l)*wh')];         
 end
 
 end
 b = b+1;
end



