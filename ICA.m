clear; close all; clc;

[s1, Fs] = audioread('femaleBig.wav'); % 観測信号1
s2 = audioread('maleBig.wav'); % 観測信号2
x = [s1 s2].'; % 多次元観測信号

N = numel(x(:,1)); % 音源の数

time = 10; % 観測時間
T = Fs*time; % サンプリング周波数時間
step = 0.5; % ステップサイズ
L = 30; % 反復回数
sigma = 1; % 分布のスケールに関するパラメータ

W = eye(N); % 分離行列を単位行列で初期化
I = eye(N); % 単位行列

for l = 1:30 % 自然勾配法によって分離行列Wを推定

        y = W*x;
        p = y./(sigma*abs(y)); % スコア関数(ラプラス分布)
        p = fillmissing(p,'constant',0); % NaNを0に
        R = p*y';
        E = R/T;
        W = W-step*(E-I)*W;

end

y = W*x; % 分離信号

[yr] = PBM(y,T,N,W); % プロジェクションバック関数

rootName = 'file';
extension = '.wav';

for i = 1:N % 分離した音声書き出し(生成とファイル名自動)

    yr(i,:) = yr(i,:)/max(abs(yr(i,:)),[],"all");

    fileName = [rootName,num2str(i),extension];
    
    audiowrite(fileName,yr(i,:),Fs);

end

 % SDR計算
    s = audioread('speech_female.wav'); % 信号源
    se = yr(1,:);
    [SDR,SIR,SAR,perm] = bss_eval_sources(se,s);




