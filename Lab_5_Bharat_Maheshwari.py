#I have done modulation for all the three cases at once to get the complex noise same for the cases: QPSK modulation + hamming code
#and QPSK modulation + hamming code + Interleaver.

#The output of the code is a graph contaning all the 3 combinations.

import numpy as np
import matplotlib.pyplot as plt
import math
import time


class Commlink:

    def __init__(self,word_length, separation_distance=2**3):
        
        p = np.array([[1,1,0,1],[1,0,1,1],[0,1,1,1]]) # Parity check matrix
        Ik = np.array([[1, 0, 0, 0],[0, 1, 0, 0],[0,0,1,0],[0,0,0,1]]) # Identity matrix of dimension k x k.
        Ink = np.array([[1, 0, 0],[0, 1, 0],[0,0,1]]) # Identity matrix of dimension (n-k) 
                            
        self.G = np.hstack((Ik,np.transpose(p))) # Generator Matrix
        self.H = np.hstack((p,Ink)) # Parity check matrix 
        
        self.Symbols = [0, 1, 2, 3] 
        self.constellation_map = [ 0.7071 + 1j*0.7071, -0.7071 + 1j*0.7071,0.7071 - 1j*0.7071, -0.7071 - 1j*0.7071] #gray coded constellation
        
        self.D = separation_distance
        self.N = word_length
        self.block_size = self.D * self.N
        
    def encode(self, data):
        
        codeword = np.dot(data,self.G) # Generating codeword

        return codeword%2
    
    def interleave(self, bitarray):     
            
        newarr = bitarray.reshape(self.D,self.N, order = 'C')    # Input in row-major order
        newarr = np.ravel(newarr,order = 'F')  
        
        return newarr
    
    def gray_constellation(self,bits,NO):
        
        Bit_List=[] #List of symbols obtained from the Input_Bits
        P = [] #List for manipulation
        List_to_str = ' '.join([str(i) for i in bits]) #List to string conversion
        
        for i in range(0,int(4*NO-3),4):
            P.append(List_to_str[i] + List_to_str[i+2])
    
        for i in range(0,len(P),1):   
            Bit_List.append(int(P[i], 2)) 
    
        Transmit_Symbol = np.array(Bit_List) #Transmit symbols
        
        Gray_Mapped_constellation = []

        
        for i in range(0,int(NO),1):
            Gray_Mapped_constellation.append(self.constellation_map[self.Symbols[Transmit_Symbol[i]]]);
        
        return Gray_Mapped_constellation
    
    def mod(self, bits_n, bits_h, bits_i):
            
        Gray_Mapped_constellation_n = self.gray_constellation(bits_n,int((len(bits_n)/2)))
        Gray_Mapped_constellation_h = self.gray_constellation(bits_h,int((len(bits_h)/2)))
        Gray_Mapped_constellation_i = self.gray_constellation(bits_i,int((len(bits_i)/2)))
    
        complex_noise_n = np.random.normal(0, math.sqrt(variance) , len(Gray_Mapped_constellation_n)) + 1j*np.random.normal(0, math.sqrt(variance) , len(Gray_Mapped_constellation_n)) # Noise
        complex_noise_hi = np.random.normal(0, math.sqrt(variance) , len(Gray_Mapped_constellation_h)) + 1j*np.random.normal(0, math.sqrt(variance) , len(Gray_Mapped_constellation_h)) # Noise    
        #complex_noise_i = np.random.normal(0, math.sqrt(variance) , len(Gray_Mapped_constellation_i)) + 1j*np.random.normal(0, math.sqrt(variance) , len(Gray_Mapped_constellation_i)) # Noise    
        
        Modulated_Signal_n = Gray_Mapped_constellation_n + complex_noise_n #Transmitted Symbols 
        Modulated_Signal_h = Gray_Mapped_constellation_h + complex_noise_hi #Transmitted Symbols
        Modulated_Signal_i = Gray_Mapped_constellation_i + complex_noise_hi #Transmitted Symbols
        
        return Modulated_Signal_n, Modulated_Signal_h, Modulated_Signal_i     
    
    
    def demod(self, received_sym,length):
        NOSR = length/2
        Received_Symbols = []
        
        for i in range(0,int(NOSR),1):
            l2 = []*500#List for manipulation
            sq = []#List for manipulation
            for j in range(0,4,1):
                l2.append(np.sum(np.power((received_sym[i]-self.constellation_map[j]),2)))
                sq.append(math.sqrt((np.real(l2[j]))**2 + (np.imag(l2[j]))**2))
                
            Received_Symbols.append(self.Symbols[sq.index(min(sq))])
        Received_Symbols = np.array(Received_Symbols)

        #Decimal to binary conversion

        a = []#List for manipulation
        get_bin = lambda x, n: format(x, 'b').zfill(n)    
        for o in range(0,int(NOSR),1):
            a.append((get_bin(Received_Symbols[o], 2)))

        List_to_str1 = ' '.join([str(i) for i in a])
        c = List_to_str1.replace(" ","") #Removing space " " from string
        
        vc = []#List for manipulation
        for u in range(0,len(c),1):
            vc.append(c[u])
        
        
        Received_bits = []
        for t in range(0,int(2*NOSR),1):
            Received_bits.append(int(vc[t]))
    
        Received_bits = np.array(Received_bits)  # Received bits

        return Received_bits
    
    def deinterleave(self, bitarray):
        
        bitarray = bitarray.reshape(self.N,self.D, order = 'C')
        new = np.ravel(bitarray,order='F') #de-interleave
       
        return new

    def decode(self, r):
        
        H_tran = np.transpose(self.H) # transpose of H
    
        syn = np.dot(r,H_tran)%2 # Generating Syndrome vector
    
        rt = [] # Vector for manipulations
        
        for i in range(0,len(H_tran),1):
            comparison = syn == H_tran[i]  
            arr_equal = comparison.all()
    
            if arr_equal == True:
                rt = i 
                
        r[rt] = r[rt] + 1 
        r = r[:4]
        return r%2

    
if __name__ == '__main__':
    
    a = np.random.randint(0, 2, 2**16) # Input data
    ll = int(((len(a)/4)*7))
    
    no = int((ll/7)) #codeword length
    dd = 7           # Separation distance
    
    Comm_Link = Commlink(no,dd)
    
    #Hamming code
    n=4
    hamming_in = [a[i * n:(i + 1) * n] for i in range((len(a) + n - 1) // n )] #list comprehension
    ff = [] 
    for i in range(0,len(hamming_in),1):
        tx = Comm_Link.encode(hamming_in[i]) # hamming encode
        
        ff.append(tx)
    ff = np.reshape(ff,(1,(ll)))  #input bits for QPSK modulation + hamming code
    
    #Interleaver
    interleaved = Comm_Link.interleave(ff[0]) #input bits for QPSK modulation + hamming code + Interleaver
    
    #function to get BER
    
    def check(value):
        df = [] #List for manipulation       
        for k in range(0,len(a),1):
            df.append(int(value[k] - a[k])) 
    
        return df.count(0)/len(a)
    
    nn = []
    hh = []
    ii = []
    var = np.linspace(0, 1, num=11, endpoint=True)
    
    for variance in var:
        
        #QPSK modulation
        tx_symbol_n, tx_symbol_h, tx_symbol_i  = Comm_Link.mod(a,ff[0],interleaved)#all modulation using the appropriate input for each case.
        rx_bits = Comm_Link.demod(tx_symbol_n,len(a))
        df_n = check(rx_bits)
        nn.append(df_n)
        
        #QPSK modulation + hamming code
        cv_r = []
        rx_bits = Comm_Link.demod(tx_symbol_h,len(ff[0]))    
        n_r = 7
        rx_bits = [rx_bits[i * n_r:(i + 1) * n_r] for i in range((len(rx_bits) + n_r - 1) // n_r )] 
        
        for i in range(0,len(rx_bits),1):    
            rx = Comm_Link.decode(rx_bits[i])
            cv_r.append(rx)
            
        cv_r = np.reshape(cv_r,(1,len(a)))
        
        df_h = check(cv_r[0])
        hh.append(df_h)
        
        #QPSK modulation + hamming code + Interleaver
        cv_r = []
        rx_bits = Comm_Link.demod(tx_symbol_i,len(interleaved))    
        
        deinterleaved = Comm_Link.deinterleave(rx_bits)
        n_r = 7
        deinterleaved = [deinterleaved[i * n_r:(i + 1) * n_r] for i in range((len(deinterleaved) + n_r - 1) // n_r )] 

        for i in range(0,len(deinterleaved),1):    
            rx = Comm_Link.decode(deinterleaved[i])
            cv_r.append(rx)
            
        cv_r = np.reshape(cv_r,(1,len(a)))
        df_i = check(cv_r[0])
        ii.append(df_i)
    
    plt.figure()    
    plt.subplots_adjust(top=5, bottom=3, left=3, right=5, hspace=0.35,wspace=0.35)
    plt.plot(var, nn,label = "QPSK modulation")
    plt.plot(var, hh, label="QPSK modulation + hamming code")
    plt.plot(var,ii, label="QPSK modulation + hamming code + Interleaver")
    plt.xlabel('Variance')
    plt.ylabel('BER')
    plt.xticks(var)
    plt.yscale('linear')
    plt.legend()
    plt.show()
       
        