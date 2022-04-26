clear; close all; clc;

[obsSig1, Fs] = audioread('../input/femaleBig.wav'); % 観測信号1
obsSig2 = audioread('../input/maleBig.wav'); % 観測信号2
xVector = [obsSig1 obsSig2].'; % 多次元観測信号

N = numel(xVector(:,1)); % 音源や観測信号の数

obsTime = 10; % 観測時間
sampFreqTime = Fs*obsTime; % サンプリング周波数時間
stepSize = 0.5; % ステップサイズ
repNum = 30; % 反復回数
scalPar = 1; % 分布のスケールに関するパラメータ

W = eye(N); % 分離行列を単位行列で初期化
I = eye(N); % 単位行列

KLdiv = zeros(1,repNum); % KLdivergence

for l = 1:repNum % 自然勾配法によって分離行列Wを推定

        yVector = W*xVector;
        scoFun = yVector./(scalPar*abs(yVector)); % スコア関数(ラプラス分布)
        scoFun = fillmissing(scoFun,'constant',0); % NaNを0に
        R = scoFun*yVector'; % 経験期待値の計算で使うサイズNの正方行列
        expExp = R/sampFreqTime; % 経験期待値

        p_yVector = exp(-abs(yVector)/scalPar)/(2*scalPar);
        KLdiv(1,l) = -log(det(W))-(sum(log(p_yVector),'all'))/sampFreqTime;
       
        W = W-stepSize*(expExp-I)*W;
end

h_Axis = 1:repNum; % KLdivergence減衰グラフの横軸

plot(h_Axis,KLdiv) % KLdivergence減衰グラフ

yVector = W*xVector; % 分離信号

[yrVector] = PBM(yVector,sampFreqTime,N,W); % プロジェクションバック法(関数)

% 分離した音声書き出し(生成とファイル名自動)
rootName = 'file';
extension = '.wav';

for i = 1:N

    yrVector(i,:) = yrVector(i,:)/max(abs(yrVector(i,:)),[],"all"); % 各要素を1以下に補正(1より大きいとうまくいかんらしい)

    fileName = [rootName,num2str(i),extension]; % ファイル名自動生成
    
    audiowrite("../output/" + fileName,yrVector(i,:),Fs); % outputというファイルに格納

end

  sigSource1 = audioread('../inputWav/speech_female.wav'); % 信号源1
  sigSource2 = audioread('../inputWav/speech_male.wav'); % 信号源2

  se = yrVector; % 分離信号をがっちゃんこ
  s = [sigSource1 sigSource2].';  % 信号源をがっちゃんこ

[SDR,SIR,SAR,perm] = bss_eval_sources(se,s) % SDR計算(関数)←数値が大きいほど良いらしい

