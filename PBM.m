function [yr] = PBM(y,T,N,W)

yd = zeros(N*N,T); % 使い捨てのy
yr = zeros(N,T); % 正規のy

inv_W = inv(W);

for i = 0:1:N-1
   
    yd(N*i+1,:) = y(i+1,:);

    yd(N*i+1:N*(i+1),:) = inv_W*yd(N*i+1:N*(i+1),:);

    yr(i+1,:) = yd(N*i+1,:); % 補正したN個の各々の信号から1つ取り出す

end