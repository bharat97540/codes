%
% EDI042 - Error Control Coding (Kodningsteknik)
% Lund University
%
% Created by Michael Lentmaier, 2015-12-01
%


% Project 2: 
% simulate the iterative decoding performance of an LDPC code
clear all;
load('H_1024_3_6.mat',"H");
figure(1); clf;

disp('Simulation running ...');

N=size(H,2); K=N-size(H,1);  R=K/N;
EbN0dB=0:10; Pb=[]; ErrVec=[]; 
EbN0=10.^(EbN0dB./10);
sigma2=1./(2*R*EbN0);
sigmaVec=sqrt(sigma2);

NumIterations=10;

numsim=1000; 
for ii=1:length(sigmaVec),  % different noise values
  ii
  err=0; 
  for k=1:numsim, % blocks to simulate
    
    % encoder: assume all-zero sequence sent
    v=zeros(1,N);                  
    
    % modulation to +1/-1
    x=1-2*v;        
    % AWGN channel
    r=x+sigmaVec(ii).*randn(1,N);      
    
    Lch = 2/sigma2(ii) .* r;
        
    Lout = SumProduct(NumIterations,H, Lch); % this function you should implement yourself
  
   err=err+sum(Lout<0); 
   end;
  % bit error rate
  Pb(ii)=err/(N*numsim); 
  ErrVec(ii)=err;
  
end;

semilogy(EbN0dB,Pb,'--','linewidth',2);
axis([0,15,1e-6, 0.5]); hold on; grid on;
xlabel('E_b/N_0 [dB]','FontSize',16,'FontWeight','bold'); 
ylabel('P_b','FontSize',16,'FontWeight','bold');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% uncoded BPSK as reference

% define SNR range
EbN0dB=-1:0.1:15; 
EbN0=10.^(EbN0dB./10);

% uncoded performance
PbUncoded=qfunc(sqrt(2*EbN0));

% plot results
figure(1); 
semilogy(EbN0dB,PbUncoded,'-.','linewidth',2);
legend('Practical BER','Theoretical BER' );
lgd.FontSize = 60;
lgd.FontWeight = 'bold';
set(gca,'FontSize',15,'FontWeight','bold');





