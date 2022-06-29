function dec = SumProduct(NumIterations, H, Lch)

%%%%%%%%%% Initializations %%%%%%%%%%%%%%
Lc = [zeros(size(H,1),length(find(H(1,:)==1)))];
Lv = [zeros(size(H,2),length(find(H(:,1)==1)))];

check_node = H;variable_node = H;

%%%%%%%%%% Tanner graph creation %%%%%%%%%%%%%%%%
for i = 1:size(check_node,2)
    check_node([find(check_node(:,i) == 1)],i) = [1:length(find(H(:,1)==1))];
end
  
for j = 1:size(variable_node,1)
    
    variable_node(j,[find(variable_node(j,:) == 1)]) = [1:length(find(H(1,:)==1))];
    
end

%%%%%%%%%%%% Iterative Decoding %%%%%%%%%%%%%%%%
uy = 0;
while uy<NumIterations % '20' indicates the number of iterations
    
%%%%%%Variable Node%%%%%%%%%%
for jj = 1:size(Lv,1) 
    for i = 1:size(Lv,2) 
        cc = 0;
        col = find(variable_node(:,jj))';
        value = variable_node(col,jj)';
        col = col(1,1:size(col,2)~=i);
        value = value(1,1:size(value,2)~=i);
        
        for kk = 1:length(col)
            cc =  cc + Lc(col(kk),value(kk));      
        end
         Lv(jj,i) = Lch(jj) + cc;
    end         
end 

%%%%%%check node%%%%%%%%
cc = 0;
for jj = 1:size(Lc,1) 
 for i = 1:size(Lc,2)
     cc = 1;
     col = find(check_node(jj,:));
     value = check_node(jj,col);
     col = col(1,1:size(col,2)~=i);
     value = value(1,1:size(value,2)~=i);
     
        for kk = 1:length(col)
            cc = cc*tanh(0.5*Lv(col(kk),value(kk)));        
        end
     Lc(jj,i) = 2*atanh(cc); 
 end
end


%%%%%Decoding%%%%%%%%

for i = 1:length(Lch)
    fd = 0;
    gh_r = find(variable_node(:,i) ~= 0);
    gh_c = variable_node(gh_r,i);
    
    for kl = 1:length(gh_r)
        fd = fd + Lc(gh_r(kl),gh_c(kl));
    end
    dec(i) = Lch(i) + fd;   

end
% decc = 0;
% decc = dec;
% %%%%%%Hard Decision%%%%%%%%%
% dec(dec>0) = 0;
% dec(dec<0) = 1;
%  
% ds = mod(dec*H.',2);%received_vector*H_transpose
% Valid_code_check = find(ds == 1);%If Valid_code_check = [], then it is a valid codeword.
% 
% if Valid_code_check ~= 0
%     uy = uy+1;
% else
%     break
% end
uy = uy+1;
end

end