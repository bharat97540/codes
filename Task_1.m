%Mapping 
%00 -1-i
%10 1-i
%11 1+i
%01 -1+i
clear all;
%Given parameters
Fc=4000; Ts=0.002267;Fs = 44100;

Eg = 1;%Normalized desired energy of the pulse
%Calculation of amplitude in order to acheive Eg = 1
A = sqrt((2*Eg)/Ts);

%Number of sample required for pulse generation
N = floor(Ts*Fs) + 1;

%SNR range for BER calculation
SNR = [0:1:10];%SNR in dB

%Intialization of BER 
BER_practical = [zeros(1,length(SNR))];

% for iter=1:10
%Implementation of Transmitter

%Input bit stream    
r_in = randi([0 1],1,10); 

%conversion of biTs into Inphase and quadrature componenTs
I_chan = 2*r_in(1:2:end)-1;
Q_chan = 2*r_in(2:2:end)-1;

%Baseband Pulse Generation
t=0:0.00002267:Ts;
pulse = A*sin((pi*t)/Ts);

%initializations
count = 1;jj = 1;
Transmit_signal = (zeros(1,N*length(r_in)/2));

%Generating transmit signal 
for e = 1:length(r_in)/2
      y34 = (I_chan(e) + 1j*Q_chan(e))*pulse;
     y_1 = real(y34).*cos(2*pi*Fc*t) - imag(y34).*sin(2*pi*Fc*t);   
    for m=1:length(t)-1
        
        Transmit_signal(jj) = y_1(m);
        jj = jj + 1;
        
    end
end
%generation of transmit signal delayed by 10 samples
transmit_signal_delay = delayseq(Transmit_signal.',10);
transmit_signal_delay = transmit_signal_delay.';

%Implementation of Receiver
group_no = 1;
gamma = (group_no/40);

for c = 0:length(SNR)-1
    pow = 10^(c/10);%SNR linear conversion
    N0 = (Eg/2)/pow; %noise power spectral density
    vara = ((N0/2))*Fs;%variance of the discrete time representation of continuous AWGN  

    %Received signal as per the description
    r = sqrt(1-(gamma^2)).*Transmit_signal + transmit_signal_delay.*(1-sqrt(1-(gamma^2))) + randn(1,length(Transmit_signal))*sqrt(vara);

    uu=1;
    %Downconversion of the received signal into inpahse and quadrature componenTs
    ert_re = [zeros(1,length(Transmit_signal))];ert_im = [zeros(1,length(Transmit_signal))];
        while uu<length(Transmit_signal) +1
        for m = 1:N
            ert_re(uu) = r(uu).*cos(2*pi*Fc*t(m));%Inphase
            ert_im(uu) = -r(uu).*sin(2*pi*Fc*t(m));%Quadrature
            uu = uu +1;
        end
        end

    %low pass filter
    ert_re = lowpass((ert_re),150,Fs);
    ert_im = lowpass((ert_im),150,Fs);

    %Matching filter
    fil_re = filter(pulse,1,ert_re);
    fil_im = filter(pulse,1,ert_im);

    %Sampling the filtered ouput at Ts
    ui = N:N:length(fil_re);
    
    %QPSK decoding
    qwa_re = fil_re(ui);
    qwa_im = fil_im(ui);

    dece = qwa_re;
    dece(2,:) = qwa_im;
    dece = dece(:).';

    dece( dece <= 0 ) = 0;
    dece( dece >= 1 ) = 1;
    
    %Calculation of pratical BER
    BER_practical(1,count) =BER_practical(1,count)+ numel(find(r_in-dece))./length(r_in);
    %Calculation of theoretical BER
    BER_theory(1,count) = qfunc(sqrt(((2*0.5)/N0)));

    count = count + 1;
 end
% end

figure,
semilogy(SNR,BER_practical(1,:)/10,'LineWidth',2);grid on
hold on;
semilogy(SNR,BER_theory(1,:),'-*'),grid on
xlabel('SNR [dB]','FontSize',20,'FontWeight','bold') 
ylabel('Bit Error Probability','FontSize',20,'FontWeight','bold')
h12 = zeros(2, 1);
h12(1) = plot(NaN,NaN,'-*');
h12(2) = plot(NaN,NaN,'-k');
legend('Location','northeast')
legend(h12, 'Theoretical BER','Practical BER');
lgd.FontSize = 60;
lgd.FontWeight = 'bold';
set(gca,'FontSize',20,'FontWeight','bold')
title('BER result Task 1')






