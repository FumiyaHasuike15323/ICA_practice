clear; close all; clc;

[s1, Fs] = audioread('女でかい.wav'); % 信号源1
s2 = audioread('男でかい.wav'); % 信号源2
x = [s1 s2].'; % 多次元観測信号

T = size(x.',1)/Fs; % 観測時間
discreteTime = linspace(0, T, T*Fs).'; % 離散時間(ベクトル)
deltaTime = T/(T*Fs);

myu = 10; % ステップサイズ
L = 30; % 反復回数

sigma = 1;

W = eye(2); % 分離行列を単位行列で初期化
I = eye(2); % 単位行列

for l = 0:1:L-1 % 自然勾配法によって分離行列Wを推定

        y = W*x;
        fai = y./(sigma*abs(y)); % スコア関数(ラプラス分布)
        R = fai*y.';
        E = R/T;

    W=W-myu*(E-I)*W;

end

for t = 0:deltaTime:T-deltaTime
    y = W*x; % 分離信号
end

y = y.'/max(abs(y),[],"all");
yFemale = y(:, 1); % ステレオ音声の女採取
yMale = y(:, 2); % ステレオ音声の男採取

fileName1 = 'sefaiaratedSfaieechFemale.wav';
audiowrite(fileName1,yFemale,Fs);

[sefaiarationSignaFemale,Fs] = audioread(fileName1);
sound(yFemale,Fs);

fileName2 = 'sefaiaratedSfaieechMale.wav';
audiowrite(fileName2,yMale,Fs);

[yMale,Fs] = audioread(fileName2);
sound(yMale,Fs);







