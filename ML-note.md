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

$$\sigma(x) = \frac{1}{1 + e^{-x}}$$

-∞ ~ +∞ の数値を、0.0~1.0 の範囲の数値に変換する関数

#### 双曲線正接関数

$$\tanh(x) = \frac{e^{x} - e^{-x}}{e^{x} + e^{-x}}$$

-∞ ~ +∞ の数値を、-1.0~1.0 の範囲の数値に変換する関数。 `np.tanh(x)`

#### ReLU (Rectified Linear Unit)

$$\text{ReLU}(x) = \max(0, x)$$

`np.maximum(0, x)`

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

## バッチサイズ (Batch size)

どのくらいの数量(=サイズ)の訓練データをまとめて学習するか」を示す数値:

- 1 つの訓練データ : オンライン学習 (Online training)
- 複数の訓練データ : ミニバッチ学習 (Mini-batch training)
- 全ての訓練データ : バッチ学習 (Batch training)
