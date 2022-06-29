clear all;
vt = [0 3;3 0;2 1;1 2;1 2;2 1;3 0;0 3]; %Output Look-up Table

sigma_next = [0 4;0 4;1 5;1 5;2 6;2 6;3 7;3 7]; %State look-up table
u = [0	0	1	0	1	1	0	1	0	0	1	1	1	0	0	1	1	0	0	1 0  0  0]; %Input Vector

%%%%%%%%Encoder%%%%%%%%%
ini_st = 0;
next_st = [0];
out = [];
for p = 0:length(u)-1
    
    if u(p+1) == 1
        
        out(p+1) = vt(ini_st+1,u(p+1)+1);
        nex_st = sigma_next(ini_st+1,u(p+1)+1);
        ini_st = nex_st;
        
    elseif u(p+1) == 0 
        
        out(p+1) = vt(ini_st+1,u(p+1)+1);
        nex_st = sigma_next(ini_st+1,u(p+1)+1);
        ini_st = nex_st;
    end
    
end


out_fin = de2bi(out,2,'left-msb');

%received vector
r = [1.0277 1.1168;1.519 1.2254;-1.1826 -0.46652;0.77888 -0.63308;0.47504 -1.385;1.2731 -1.6987;-0.73988 -0.72942;-1.024 0.44931; -0.73046 1.02;-0.94489 1.0106; 1.0872 1.6682; -0.96612 0.97924; 1.132 0.8478; 1.0305 -0.92926;-0.1638 -0.92626;0.65 1.021;-1.5563 0.81743;-1.3422 -1.3668;0.672 -0.90505;0.86992 0.59714;0.94946 -1.3097;-1.0656 1.3994;-0.8376 -1.1257];

%%%%%%%%%%%%Decoder%%%%%%%%%%%%%%
vt_b = [1 1 -1 -1;-1 -1 1 1;-1 1 1 -1;1 -1 -1 1;1 -1 -1 1;-1 1 1 -1;-1 -1 1 1;1 1 -1 -1];
ini_st = [zeros(1,8)];c = 1;
r_out = zeros(8,2*length(r));
%%%%%%%%Formation of trellis%%%%%%%%%%
 r_out(1,c) = r(1,1).*vt_b(ini_st(1)+1,1) + r(1,2).*vt_b(ini_st(1)+1,2);
 c = c+1;
 r_out(1,c) = r(1,1).*vt_b(ini_st(1)+1,3) + r(1,2).*vt_b(ini_st(1)+1,4); 
 c = c+1;   
 ini_st(5) = 4;ini_st(1)=0;
 
 for o = 2:4   
   
   if ini_st(2) == 1
   
   r_out(2,c) = r_out(3,c-2) + r(o,1).*vt_b(ini_st(2)+1,1) + r(o,2).*vt_b(ini_st(2)+1,2);
   c = c+1;
   r_out(2,c) = r_out(3,c-3) + r(o,1).*vt_b(ini_st(2)+1,3) + r(o,2).*vt_b(ini_st(2)+1,4);
   c = c-1;
   end
   
   if ini_st(4) == 3
   r_out(4,c) = r_out(7,c-2) + r(o,1).*vt_b(ini_st(4)+1,1) + r(o,2).*vt_b(ini_st(4)+1,2);
   c = c+1;
   r_out(4,c) = r_out(7,c-3) + r(o,1).*vt_b(ini_st(4)+1,3) + r(o,2).*vt_b(ini_st(4)+1,4);
   c = c-1;
   end
    
   if ini_st(1) == 0
       
   r_out(1,c) = r_out(1,c-2) + r(o,1).*vt_b(ini_st(1)+1,1) + r(o,2).*vt_b(ini_st(1)+1,2);
   c = c+1;
   r_out(1,c) = r_out(1,c-3) + r(o,1).*vt_b(ini_st(1)+1,3) + r(o,2).*vt_b(ini_st(1)+1,4); 
   c= c-1; 
   
   end
   
   if ini_st(6) == 5
   r_out(6,c) = r_out(3,c-1) + r(o,1).*vt_b(ini_st(6)+1,1) + r(o,2).*vt_b(ini_st(6)+1,2);
   c = c + 1;
   r_out(6,c) = r_out(3,c-2) + r(o,1).*vt_b(ini_st(6)+1,3) + r(o,2).*vt_b(ini_st(6)+1,4); 
   c = c - 1;
   end
   
   if ini_st(8) == 7
   r_out(8,c) = r_out(7,c-1) + r(o,1).*vt_b(ini_st(8)+1,1) + r(o,2).*vt_b(ini_st(8)+1,2);
   c = c +1;
   r_out(8,c) = r_out(7,c-2) + r(o,1).*vt_b(ini_st(8)+1,3) + r(o,2).*vt_b(ini_st(8)+1,4); 
   c = c-1;   
   end
   
   if ini_st(7) == 6
   r_out(7,c) = r_out(5,c-1) + r(o,1).*vt_b(ini_st(7)+1,1) + r(o,2).*vt_b(ini_st(7)+1,2);
   c = c +1;
   r_out(7,c) = r_out(5,c-2) + r(o,1).*vt_b(ini_st(7)+1,3) + r(o,2).*vt_b(ini_st(7)+1,4); 
   c = c -1;
   ini_st(4) = 3;ini_st(8)=7; 
   end
  
   if ini_st(3) == 2
   r_out(3,c) = r_out(5,c-2) + r(o,1).*vt_b(ini_st(3)+1,1) + r(o,2).*vt_b(ini_st(3)+1,2);
   c = c+1;
   r_out(3,c) = r_out(5,c-3) + r(o,1).*vt_b(ini_st(3)+1,3) + r(o,2).*vt_b(ini_st(3)+1,4); 
   c = c-1;
   ini_st(6) = 5;ini_st(2)=1;
   end
 
   if ini_st(5) == 4
   r_out(5,c) = r_out(1,c-1) + r(o,1).*vt_b(ini_st(5)+1,1) + r(o,2).*vt_b(ini_st(5)+1,2);
   c = c+1;
   r_out(5,c) = r_out(1,c-2) + r(o,1).*vt_b(ini_st(5)+1,3) + r(o,2).*vt_b(ini_st(5)+1,4); 
   ini_st(3) = 2;ini_st(7)=6;
   end
   
   c = c+1;
   
 end



 for o = 5:length(r)   
  
   r_out(2,c) = max(r_out(3,c-2), r_out(4,c-2))  + r(o,1).*vt_b(ini_st(2)+1,1) + r(o,2).*vt_b(ini_st(2)+1,2);
   c = c+1;
   r_out(2,c) = max(r_out(3,c-3), r_out(4,c-3)) + r(o,1).*vt_b(ini_st(2)+1,3) + r(o,2).*vt_b(ini_st(2)+1,4);
   c = c-1;
  
   r_out(4,c) = max(r_out(7,c-2), r_out(8,c-2)) + r(o,1).*vt_b(ini_st(4)+1,1) + r(o,2).*vt_b(ini_st(4)+1,2);
   c = c+1;
   r_out(4,c) = max(r_out(7,c-3), r_out(8,c-3)) + r(o,1).*vt_b(ini_st(4)+1,3) + r(o,2).*vt_b(ini_st(4)+1,4);
   c = c-1;
      
   r_out(1,c) = max(r_out(1,c-2), r_out(2,c-2)) + r(o,1).*vt_b(ini_st(1)+1,1) + r(o,2).*vt_b(ini_st(1)+1,2);
   c = c+1;
   r_out(1,c) = max(r_out(1,c-3), r_out(2,c-3)) + r(o,1).*vt_b(ini_st(1)+1,3) + r(o,2).*vt_b(ini_st(1)+1,4); 
   c= c-1; 
   
   r_out(6,c) = max(r_out(3,c-1), r_out(4,c-1)) + r(o,1).*vt_b(ini_st(6)+1,1) + r(o,2).*vt_b(ini_st(6)+1,2);
   c = c + 1;
   r_out(6,c) = max(r_out(3,c-2), r_out(4,c-2)) + r(o,1).*vt_b(ini_st(6)+1,3) + r(o,2).*vt_b(ini_st(6)+1,4); 
   c = c - 1;
   
   r_out(8,c) = max(r_out(7,c-1), r_out(8,c-1)) + r(o,1).*vt_b(ini_st(8)+1,1) + r(o,2).*vt_b(ini_st(8)+1,2);
   c = c +1;
   r_out(8,c) = max(r_out(7,c-2), r_out(8,c-2)) + r(o,1).*vt_b(ini_st(8)+1,3) + r(o,2).*vt_b(ini_st(8)+1,4); 
   c = c-1;
   
   r_out(7,c) = max(r_out(5,c-1), r_out(6,c-1)) + r(o,1).*vt_b(ini_st(7)+1,1) + r(o,2).*vt_b(ini_st(7)+1,2);
   c = c +1;
   r_out(7,c) = max(r_out(5,c-2), r_out(6,c-2)) + r(o,1).*vt_b(ini_st(7)+1,3) + r(o,2).*vt_b(ini_st(7)+1,4); 
   c = c -1;
   
   r_out(3,c) = max(r_out(5,c-2), r_out(6,c-2)) + r(o,1).*vt_b(ini_st(3)+1,1) + r(o,2).*vt_b(ini_st(3)+1,2);
   c = c+1;
   r_out(3,c) = max(r_out(5,c-3), r_out(6,c-3)) + r(o,1).*vt_b(ini_st(3)+1,3) + r(o,2).*vt_b(ini_st(3)+1,4); 
   c = c-1;
   
   r_out(5,c) = max(r_out(1,c-1), r_out(2,c-1)) + r(o,1).*vt_b(ini_st(5)+1,1) + r(o,2).*vt_b(ini_st(5)+1,2);
   c = c+1;
   r_out(5,c) =  max(r_out(1,c-2), r_out(2,c-2)) + r(o,1).*vt_b(ini_st(5)+1,3) + r(o,2).*vt_b(ini_st(5)+1,4); 
   
   c = c+1;
   
 end

 %%%%%%%%%%%Tracing the trellis backward%%%%%%%%%%%%%%
[row col] = find(r_out==max(r_out(1,end-1), r_out(2,end-1)));
ini_st = row;
bits = [zeros(1,length(u))];
vcx = [zeros(1,length(u))];
bits(1) = 0;
od = 1:2:size(r_out,2) - 2;
ev = 2:2:size(r_out,2)-2;
rq = length(od);
ri = length(ev);
vcx (1) = 3; % For estimated codeword

for pp = 2:length(u)
    
     if ini_st == 2
        
       [row col] = find(r_out==max(r_out(4,od(rq)),r_out(3,od(rq))));   
        bits(pp) = 0;
        if row == 3
        vcx(pp) = 2;
        else
            vcx(pp) = 1;
        end
        
     elseif ini_st == 3
    
       [row col] = find(r_out==max(r_out(5,od(rq)),r_out(6,od(rq))));       
        bits(pp) = 0;
        if row == 5
        vcx(pp) = 1;
        else
            vcx(pp) = 2;
        end
        
     elseif ini_st == 4
    
       [row col] = find(r_out==max(r_out(7,od(rq)),r_out(8,od(rq))));        
        bits(pp) = 0;
        if row == 7
        vcx(pp) = 3;
        else
            vcx(pp) = 0;
        end
      
     elseif ini_st == 1
    
       [row col] = find(r_out==max(r_out(1,od(rq)),r_out(2,od(rq))));    
        bits(pp) = 0;
        if row == 1
        vcx(pp) = 0;
        else
            vcx(pp) = 3;
        end
        
    elseif ini_st == 5
    
       [row col] = find(r_out==max(r_out(1,ev(ri)),r_out(2,ev(ri))));        
        bits(pp) = 1;
        if row == 1
         vcx(pp) = 3;
        else
            vcx(pp) = 0;
        end
   
    elseif ini_st == 6
    
       [row col] = find(r_out==max(r_out(3,ev(ri)),r_out(4,ev(ri))));       
        bits(pp) = 1;
         if row == 3
         vcx(pp) = 1;
        else
            vcx(pp) = 2;
         end
         
    elseif ini_st == 7
    
       [row col] = find(r_out==max(r_out(5,ev(ri)),r_out(6,ev(ri))));
        bits(pp) = 1;
        if row == 5
         vcx(pp) = 2;
        else
            vcx(pp) = 1;
        end
         
    elseif ini_st == 8
    
      [row col] = find(r_out==max(r_out(7,ev(ri)),r_out(8,ev(ri))));       
      bits(pp) = 1;
        if row == 7
         vcx(pp) = 0;
        else
            vcx(pp) = 3;
        end
  
     end
     ini_st = row;
     rq = rq -1;
     ri = ri-1;

end
    
bits = flip(bits); %Decoded bits obtaned from trellis
vcx = flip(vcx);
Error = sum(u-bits);


