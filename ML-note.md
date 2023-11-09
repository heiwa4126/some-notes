# ML (Machine Learning: 機械学習)ノート

しらんことだらけなのでメモとっとく。

## 学習コース

### Microsoft Learn

- [Python と Azure Notebooks での機械学習の概要 - Learn | Microsoft Docs](https://docs.microsoft.com/ja-jp/learn/paths/intro-to-ml-with-python/)
- [機械学習の短期集中コース - Learn | Microsoft Docs](https://docs.microsoft.com/ja-jp/learn/paths/ml-crash-course/)

- 意外と良かった。
- 無料
- Azure Notebooks(Jupyter Notebook のオンライン版)がちゃんと機動するまで時間がかかる
- 教材は[GitHub - MicrosoftDocs/ms-learn-ml-crash-course-python: Code samples for the ML Crash Course learning path.](https://github.com/MicrosoftDocs/ms-learn-ml-crash-course-python)にあるので、ローカルでもできるのが親切。
  - コード部分の解説は英語。でもそんなに難しくない
- Jupyter Notebook の「操作方法」ではなく「使いどころ」が理解できる。
- 「08. Neural Networks Introduction - Python」で'acc'は'accuracy'です。

### AWS hands-on

[AWS Hands-on Amazon Personalize/Forecast | AWS](https://pages.awscloud.com/event_JAPAN_Hands-on-Amazon-Personalize-Forecast-2019.html?trk=aws_introduction_page)

### その他

- [Introduction to Machine Learning | Machine Learning Crash Course](https://developers.google.com/machine-learning/crash-course/ml-intro?hl=ja)

- [機械学習 | Coursera](https://ja.coursera.org/learn/machine-learning)
  - [文系エンジニアが Coursera の機械学習コースを 1 ヶ月で修了したので振り返ってみました。 - Qiita](https://qiita.com/poly_soft/items/0f7c09470af4ad5dbd39)
- [AI Academy | Python・機械学習・AI を実践的に学べるプログラミング学習サービス](https://aiacademy.jp/)

- [Numpy 入門](https://www.codexa.net/numpy/)
- [Matplotlib 入門](https://www.codexa.net/matplotlib/)
- [Pandas 入門](https://www.codexa.net/pandas/)
- [線形代数 入門](https://www.codexa.net/linear-basics-2/)
- [統計入門(前編)](https://www.codexa.net/statistics-for-machine-learning-first/)
- [統計入門(後編)](https://www.codexa.net/statistics-for-machine-learning-second/)
- [線形回帰 入門](https://www.codexa.net/linear-regression-for-beginner/)

## 活性化関数 (Activation function)

$z = \sum_{i=1}^{n} (x_i \cdot w_i) + b$  
$a = f(z)$

の $f()$ が活性化関数

なぜ必要なのかは理解できない。でも無いと動かない。

無いと動かない例: [ニューラルネットワーク Playground - Deep Insider](https://deepinsider.github.io/playground/#activation=linear&activspacer=false&loss=mse&batchSize=10&batchFull=false&dataset=gauss&regDataset=reg-plane&learningRate=0.03&regularizationRate=0&noise=0&networkShape=4,2&seed=0.34347&showTrainData=true&showValidationData=false&showTestData=true&discretize=false&percTrainData=50&x=true&y=true&xTimesY=false&xSquared=false&ySquared=false&sinX=false&sinY=false&problem=classification&initOrigin=false&hideText=false) - 活性化関数が「線形」

フランク・ローゼンブラット (Frank Rosenblatt) が 1957 年に、
初めての単一層パーセプトロンモデルを提案し、
このモデルには「ステップ関数」と呼ばれる単純な活性化関数が使われていた。

このステップ関数は、入力がある閾値を超えると 1 を返し、それ以下の場合は 0 を返すという形状をしている。

これらの初期の活性化関数は微分可能ではなく、勾配降下法を用いた学習が難しいという問題があった。

勾配降下法: パラメータをちょっとだけ動かして様子を見る方法。なるほどステップ関数だとそれは無理っぽい。

### 有名活性化関数

#### シグモイド関数

$$
\sigma(x)
= \frac{1}{1 + e^{-x}}
= \frac{e^x}{1 + e^x}
$$

-∞ ~ +∞ の数値を、0.0~1.0 の範囲の数値に変換する関数。「ロジスティクス関数」と同じもの。

厳密にいうと上記のは「標準シグモイド関数 (Standard sigmoid function) =
ロジスティクス関数」らしい。

(般シグモイド関数は
$\sigma(x) = \frac{1}{1 + e^{-ax}}$
のように係数 a (ゲイン: gain) が入る)

> シグモイド曲線を見ると、パラメータの絶対値がある程度大きくなると微分値が 0 に近くなってしまうのがわかります。このために重みの更新がなかなか進まないのが欠点

#### 双曲線正接関数

$$\tanh(x) = \frac{e^{x} - e^{-x}}{e^{x} + e^{-x}}$$

-∞ ~ +∞ の数値を、-1.0~1.0 の範囲の数値に変換する関数。 `np.tanh(x)`

#### ReLU (Rectified Linear Unit)

$$\text{ReLU}(x) = \max(0, x)$$

numpy では `np.maximum(0, x)`

「ランプ関数」というらしい。
なんで「ランプ」? → [ランプ関数 - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%A9%E3%83%B3%E3%83%97%E9%96%A2%E6%95%B0)

ちなみに ReLU の導関数は

$\text{ReLU}'(x) = \begin{cases}
1 & \text{if } x > 0 \\
0 & \text{otherwise}
\end{cases}$

と定義されてるそうです。

## ロジット(logit)

$
\operatorname{logit}(p) = \log\left(\frac{p}{1-p}\right)
= \log(p) - \log(1-p)
$

シグモイド関数の逆関数。"**log**istic un**it**"の略。

## バックプロパゲーション

全然わからん。

損失関数の自動微分やると、weight と bias の各々で grad が得られるので、
これを学習率だけ勾配降下すればいいらしい。

フォワードプロパゲーションはよくわかる w。

PyTouch の tensor についている grad_fn がバックプロパゲーションに使われる、ということは豆知識として覚えておく。

バックプロパゲーションのステップは以下の通り:

1. 順伝播 (Forward Propagation): モデルの入力から出力を計算し、損失関数の値を得ます。
2. 損失関数の自動微分 (Automatic Differentiation): PyTorch や TensorFlow などのディープラーニングフレームワークは、損失関数の自動微分を提供しています。これにより、各パラメータに対する損失の勾配を計算できます。
3. バックワードパス (Backward Pass): 勾配が計算されたら、これを使って逆向きにモデルを辿り、各パラメータに対する損失の勾配を得ます。
4. パラメータの更新: 得られた勾配を使って、各パラメータを更新します。通常、学習率と呼ばれるハイパーパラメータを使用して、更新のスケールを制御します。

このプロセスを繰り返すことで、モデルは訓練データに適応し、損失を最小化するようになります。この手法は、勾配降下法の一種であり、学習率によって更新の大きさが調整されます。

**自動微分がどんだけ便利なのか**

これが「ああなるほど」ってわかるまで結構かかった...

## 勾配降下法

単純パーセプトロン(基本)だと

$w_i\leftarrow w_i-\rho\frac{\partial E}{\partial w_i}$

($\rho$ は学習率。固定値の時もあり、状況に応じて変動させる手法もあり)

ベクトルで書くなら

$w\leftarrow w-\rho\frac{dE}{dw}$

## バッチサイズ (Batch size)

どのくらいの数量(=サイズ)の訓練データをまとめて学習するか」を示す数値:

- 1 つの訓練データ : オンライン学習 (Online training)
- 複数の訓練データ : ミニバッチ学習 (Mini-batch training)
- 全ての訓練データ : バッチ学習 (Batch training)

これを勾配降下法的に見るならば

- 最急降下法 - 全部よませて(つまり「バッチ学習」)、誤差関数の平均などを取る
- 確率的勾配降下法 - 1 個または数個読ませて... 要はオンライン学習またはミニバッチ学習

## 線形分離可能

n 次元空間上にある点の集合を、
超平面(つまり n-1 次元の)で分けられれば、
それが「線形分離可能」

## W0

$w_0$ がバイアスなのか。

$wx+b$ でも

$w=\begin{pmatrix}
    w_0 \\
    w_1 \\
    \vdots \\
    w_n
\end{pmatrix}
 ,x=\begin{pmatrix}
    1 \\
    x_1 \\
    \vdots \\
    x_n
\end{pmatrix}
$ で $wx$ でもいい。

[高卒でもわかる機械学習 (1) 識別関数の前知識 – 頭の中に思い浮かべた時には](http://hokuts.com/2015/11/24/ml1_func/)

超平面は $wx=0$ 。

## パーセプトロン

単純パーセプトロンでは XOR が作れない。

OR、AND、NAND は単純パーセプトロンで作れる。
ので 多層パーセプトロン にすればできる。

## ワンホットエンコーディング

ラベルをワンホットエンコーディングするのは出力層の値と一緒に損失関数に食わせるためなのか。

## ニューラルネットワークの出力層のニューロンの数を表す記号

いろいろあるみたい

- $n_{out}$ (n_out)
- C
- K (まれ。もしくは特定分野)

## fill mask タスクなどでは出力層のニューロンの数はトークナイザーのボキャブラリの数と同一ですか?

同一らしい。すげえ。

QA や要約でも話は一緒。

翻訳は微妙:

- 出力言語のトークナイザーの数と同一
- マルチリンガルの翻訳タスクの場合、全言語の和になるかも。

「実際に Hugging Face Transformers で model から出力層のニューロンの数を得ることはできますか?」という質問には、結局 config 周りで得るしかないみたい。

それなら直接 config.json みても一緒なんだけど、それは本末転倒

いちおう例:

- [config.json · bert-base-uncased at main](https://huggingface.co/bert-base-uncased/blob/main/config.json) - vocab_size: 30522
- [config.json · RinInori/bert-base-uncased_finetuned_sentiments at main](https://huggingface.co/RinInori/bert-base-uncased_finetuned_sentiments/blob/main/config.json) - 感情分析のモデル。ラベルが 6 つだから出力層も 6 個 だろう...

fill-mask の `outout=model(**input)` で tensor のサイズを見ればわかるはず。あとでやってみる。

## 下流タスク

生成系 AI チャットいろいろに聞いたもののまとめ。

Q. NLP の「下流タスク」とは何ですか? 「下流(downstream)」にはどんな意味がこめられていますか? 上流タスクもあるんですか?

- 上流タスクとは、事前学習のために行われる教師なし学習のタスクです。
- 下流タスク(downstream task)」とは、ある事前学習済みモデルをベースに、新しいタスクを解くためにファインチューニングするタスクのことを指します。

具体的には、BERT や GPT などの事前学習済み言語モデルをベースモデルとして、その上に分類や質問応答などのタスク特化層を追加し、新しいデータセットでファインチューニングすることで、タスクを解くモデルを効率的に構築できます。

Q.
例えば fill-mask の bert-base-cased モデルを
Yelp Reviews データセット使って、
sequence classification タスク用 として fine-tuning したモデルを作った場合
どれが上流タスクでどれが下流タスクですか?

(答え省略)

Q.
この場合 bert-base-cased の出力層の後ろに
sequence classification タスク用の
ニューラルネットワークが構築されるのですか?

bert-base-cased の事前学習モデルを下流の sequence classification タスクで fine-tuning する場合、以下のようにモデルを構成します:

1. bert-base-cased のモデル(埋め込み層、encoder 層など)をロード
2. 出力層(上流タスクの fill-mask)の後ろに、新しい出力層を追加。
   この出力層は sequence classification のクラス数だけのニューロンを持つ。
3. 追加した出力層以外は固定し、出力層のみを新しいデータで fine-tuning
4. fine-tuning 後は、入力テキストから特徴量を抽出する bert-base-cased と、それを入力として分類を行う出力層を組み合わせて推論

このように、事前学習済みモデルの出力を入力として、タスク特化の層を追加するのが一般的な下流タスクの構成です。上流の特徴抽出能力を活用しつつ、下流のタスクに特化したネットワークを追加することで両立できています。

## モデルの入力のトークン数の制限値は、ニューラルネットワークの入力層のニューロンの数ですか?

これは「はい」と言い切れない。

## TODO: Conversational タスクをあとで pipeline()を使わずにやってみる。

## 横ベクトル・縦ベクトル

一応メモ書いとく。行ベクトル・列ベクトルより間違いにくい??ような気がする。

100 次元のサンプル。

横ベクトル(row vector):

$$
(x_1, x_2, \ldots, x_{100})
$$

縦ベクトル(column vector):

$$
\begin{pmatrix} y_1 \\ y_2 \\ \vdots \\ y_{100} \end{pmatrix}
$$
