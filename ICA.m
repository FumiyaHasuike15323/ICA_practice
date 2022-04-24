clear; close all; clc;

[s1, Fs] = audioread('femaleBig.wav'); % 信号源1
s2 = audioread('maleBig.wav'); % 信号源2
x = [s1 s2].'; % 多次元観測信号

time = 10; % 観測時間
T = Fs*time; % サンプリング周波数時間
step = 1; % ステップサイズ
L = 30; % 反復回数
sigma = 1; % 分布のスケールに関するパラメータ

W = eye(2); % 分離行列を単位行列で初期化
I = eye(2); % 単位行列

for l = 0:1:30 % 自然勾配法によって分離行列Wを推定

        y = W*x;
        p = y./(sigma*abs(y)); % スコア関数(ラプラス分布)

        p = fillmissing(p,'constant',0); % NaNを0に

        R = p*y.';
        E = R/T;
        W = W-step*(E-I)*W;

end

y = W*x; % 分離信号

y = y.'/max(abs(y),[],"all");
yFemale = y(:, 1); % ステレオ音声の女採取
yMale = y(:, 2); % ステレオ音声の男採取

fileName1 = '分離後の女性声.wav';
audiowrite(fileName1,yFemale,Fs);

[yFemale,Fs] = audioread(fileName1);
sound(yFemale,Fs);

fileName2 = '分離後の男性声.wav';
audiowrite(fileName2,yMale,Fs);

[yMale,Fs] = audioread(fileName2);
sound(yMale,Fs);







