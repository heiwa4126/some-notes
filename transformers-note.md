# Transformers のメモ

Hugging Face 🤗 の。
LLM のノートに書いてたのがだんだん大きくなりすぎたので分ける。

## accelerate

便利。PyTorch 専用?

- [accelerate · PyPI](https://pypi.org/project/accelerate/) - このサンプルが
- [Using pipeline on large models with 🤗 accelerate:](https://huggingface.co/docs/transformers/pipeline_tutorial#using-pipeline-on-large-models-with-accelerate) - こっちのサンプルも
- [huggingface の accelerate を使って訓練時の CUDA out of memory を回避する #自然言語処理 - Qiita](https://qiita.com/m__k/items/518ac10399c6c8753763)

## モデル、 アーキテクチャ、チェックポイント

[Load pretrained instances with an AutoClass](https://huggingface.co/docs/transformers/autoclass_tutorial)

アーキテクチャとはモデルの骨格のことであり、
チェックポイントとは与えられたアーキテクチャに対する重みのことである。

例えば、BERT はアーキテクチャであり、
bert-base-uncased はチェックポイントである。

モデルは、アーキテクチャまたはチェックポイントのどちらかを意味する一般的な用語である。

## PEFT

[PEFT](https://huggingface.co/docs/peft/index)

> PEFT(Parameter-Efficient Fine-Tuning)は、モデルの全パラメータを微調整することなく、訓練済みの言語モデル(PLM)を様々な下流アプリケーションに効率的に適応させるためのライブラリです。大規模な PLM のファインチューニングは法外なコストがかかるため、PEFT メソッドは少数の(余分な)モデルパラメータのみをファインチューニングし、計算コストとストレージコストを大幅に削減します。最近の最新の PEFT 手法は、完全なファインチューニングに匹敵する性能を達成しています。
>
> PEFT は、DeepSpeed とビッグモデル推論を活用した大規模モデル用の Transformers Accelerate とシームレスに統合されています。

[Load adapters with 🤗 PEFT](https://huggingface.co/docs/transformers/peft)

> PEFT(Parameter-Efficient Fine Tuning)法は、fine-tuning の際に事前に学習したモデルのパラメータを凍結し、その上に少数の学習可能なパラメータ(アダプター)を追加する。アダプターはタスク固有の情報を学習するように訓練される。このアプローチは、完全にファインチューニングされたモデルに匹敵する結果を出しながら、メモリ効率が非常に高く、計算量が少ないことが示されている。

Transformers の PEFT がサポートするメソッドは、標準では

- [Low Rank Adapters (LoRA)](https://huggingface.co/docs/peft/conceptual_guides/lora)
- [IA3](https://huggingface.co/docs/peft/conceptual_guides/ia3)
- [AdaLoRA](https://arxiv.org/abs/2303.10512)

など。リストは [PEFT - Supported methods](https://huggingface.co/docs/peft/index#supported-methods)

他のメソッドも追加可能(ドキュメント参照)

サポートするモデルは
[PEFT - Supported models](https://huggingface.co/docs/peft/index#supported-models)

参考記事:

- [Load adapters with 🤗 PEFT](https://huggingface.co/docs/transformers/peft)
- [Quicktour](https://huggingface.co/docs/peft/quicktour)
- [[翻訳] Hugging face の PEFT のクイックツアー #huggingface - Qiita](https://qiita.com/taka_yayoi/items/9196444274d6a63cda76)

たとえばチュートリアル
[Fine-tune a pretrained model](https://huggingface.co/docs/transformers/training)の
Bert で分類の場合は
[これ](https://huggingface.co/docs/peft/index#sequence-classification)
を見て、

task_type:

- "SEQ_CLS" - シーケンスのクラス分類(Sequence Classification)タスク
- "SEQ_2_SEQ_LM" - シーケンス間の変換(Sequence-to-Sequence Language Modeling)タスク。例えば文章の翻訳。
- "CAUSAL_LM" - 果関係を考慮した言語モデリング(Causal Language Modeling)タスク
- "TOKEN_CLS" - トークンごとのクラス分類(Token Classification)タスク。例えば、固有表現抽出(NER)
- "QUESTION_ANS" - 質問応答(Question Answering)タスク
- "FEATURE_EXTRACTION" - フィーチャーの抽出(Feature Extraction)タスク

## Trainer の compute_metrics

[Trainer](https://huggingface.co/docs/transformers/main_classes/trainer)

compute_metrics()関数は、Trainer の 1 エポック終了後に呼び出されます
(ストラテジによって変わる。後述)。

具体的には以下のタイミングで呼ばれます:

- 訓練時の各エポック終了後に、訓練データで evaluate()が呼ばれ、そこで compute_metrics()が呼び出される
- 評価用データで evaluate()が呼ばれたときに、compute_metrics()が呼び出される

訓練途中で評価したい場合は、Trainer の args に evaluation_strategy='steps'などを指定することで、
所定のステップごとに evaluate()し、compute_metrics()を呼び出すこともできます。

**compute_metrics()の戻り値はあくまで中間評価のためで、fine-tuning 自体には影響しない。**

- [compute_metrics](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.Trainer.compute_metrics)
- [huggingface/transformers の Trainer の使い方と挙動 #bert - Qiita](https://qiita.com/nipo/items/44ce3aaf6acd4e2649d1#compute_metrics)

## accuracy

`accuracy = (予測が正解だったサンプル数) / (全サンプル数)`

例えば、100 個のサンプルに対してモデルが 80 個正解で 20 個不正解だった場合、accuracy は 80/100=0.8=80%となります。

accuracy は 0 から 1 の間の値をとり、1 に近いほどモデルの性能が高いことを示します。

分類タスクでは、accuracy がもっとも基本的で重要な評価指標の 1 つとして、広く使用されています。

[Accuracy - a Hugging Face Space by evaluate-metric](https://huggingface.co/spaces/evaluate-metric/accuracy)

## F1 スコア (F 値, F-measure)

accuracy はクラス不均衡データに対して脆弱なため、F1 スコア等の指標と合わせて使用することが多いです。

クラス不均衡データとは:
あるクラスのデータ数が他のクラスに比べて極端に少ないデータセットのことです。
例えば、100 個のデータの内、90 個が「クラス A」、10 個が「クラス B」であるようなデータセットは、クラス不均衡が発生しています。

この場合、単純に accuracy を計算すると、
全てのサンプルを「クラス A」と予測するモデルでも 90%の高い accuracy が出てしまいます。

F1 スコアは、
適合率(Precision, Positive predict value,PPV) と
再現率(Recall)(=感度(Sensitivity)) の
調和平均です。

- [F 値 (評価指標) - Wikipedia](<https://ja.wikipedia.org/wiki/F%E5%80%A4_(%E8%A9%95%E4%BE%A1%E6%8C%87%E6%A8%99)>)
- [感度とか特異度とか | Tech Blog | CRESCO Tech Blog](https://www.cresco.co.jp/blog/entry/5987.html)
- [F1 - a Hugging Face Space by evaluate-metric](https://huggingface.co/spaces/evaluate-metric/f1)

## Trainer の 損失関数(loss function)

compute_loss で指定するんだけど、デフォルトは None.

None だと、モデルの設定に基づいて自動的に設定されます。
分類タスクの場合、BertForSequenceClassification を使用すると、
クロスエントロピー損失(交差エントロピー)がデフォルトで設定されます。

[損失関数とは？ニューラルネットワークの学習理論【機械学習】 – 株式会社ライトコード](https://rightcode.co.jp/blog/information-technology/loss-function-neural-network-learning-theory)
