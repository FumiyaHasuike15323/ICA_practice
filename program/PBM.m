function [yrVector] = PBM(yVector,sampFreqTime,N,W)

ydVector = zeros(N*N,sampFreqTime); % 使い捨てのyVector
yrVector = zeros(N,sampFreqTime); % 正式なyVector

inv_W = inv(W);

for i = 0:1:N-1
   
    ydVector(N*i+1,:) = yVector(i+1,:); % 奇数行をyVector, 偶数行を0Vectorに

    ydVector(N*i+1:N*(i+1),:) = inv_W*ydVector(N*i+1:N*(i+1),:); % 分離信号yVectorに対するスケール補正

    yrVector(i+1,:) = ydVector(N*i+1,:); % 補正したことによって生成されたyVectorのそれぞれにおけるN個の信号から代表して1つ取り出す

end