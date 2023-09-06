# 大規模言語モデル (Large Language Models、LLM) メモ

## 概要

※ Google の SGE(Search Generative Experience) で出てきたやつが、いい感じなのでコピペ。

大規模言語モデル(LLM) は、大量のテキストデータで学習した自然言語処理モデルです。LLM は、膨大な量のテキストデータを学習し、人間のような自然な言語生成や理解を実現することを目的としています。

LLM は、膨大な量のテキストデータを処理し、与えられたテキストに基づいて予測や応答を生成する能力を持っています。LLM は、文章の作成、翻訳、質疑応答などを行う生成系 AI の多くで活用されています。

LLM は、数千万から数十億のパラメータを持つ人工ニューラルネットワークで構成されています。LLM は、膨大なラベルなしテキストを使用して自己教師あり学習または半教師あり学習によって訓練されます。

## 有名な大規模言語モデル

- Google の「BERT」
- OpenAI の「GPT」
- Meta の「LLaMA」
- Microsft の「MT-NLG」

など。

## transformers でよく出てくる "pt" とは

PyTorch 形式

他に

- "pt"：PyTorch 形式
- "tf"：TensorFlow 形式
- "jax"：JAX 形式
- "np"：NumPy 形式

`class TensorType` 参照

[transformers/src/transformers/utils/generic.py at main · huggingface/transformers](https://github.com/huggingface/transformers/blob/main/src/transformers/utils/generic.py#L430)

## LLM のタスク

の一例

- テキスト生成 - Text generation
- 言語翻訳 - Language translation
- 質問応答 - Question answering (QA)
- 要約 - Summarization
- テキスト分類 - Text classification
- 自然言語推論 - Natural language inference (NLI)
- 文章の生成 - Creative text generation
- メールや手紙の作成 - Email or letter writing
- ストーリーの作成 - Story writing
- コードの生成 - Code generation
- 音楽の生成 - Music generation
- 画像の生成 - Image generation

...なんか微妙に違う。

- 文書分類 - document classification
- 感情分析 - sentiment analysis
- 自然言語推論 (naturallanguageinference;NLI)
- 意味的類似度計算 (semantictextualsimilarity;STS)
- 固有表現認識 (namedentityrecognition;NER)
- 要約生成 (summarizationgeneration)
- 質問応答 (questionanswering)

とかそういうやつだ。修正していく。

自己教師あり学習(self-supervised learning)
を大規模に
「自己教師あり学習なら大規模にできる」ということ

事前学習済み言語モデル (pre-trained language model; PLM)
をつくる

で、これと

下流タスクのデータセットで微調整 (fine-tuning)
or
プロンプト(prompt)

でタスクを解く。

## Transformers のチュートリアル

[イントロダクション - Hugging Face NLP Course](https://huggingface.co/learn/nlp-course/ja/chapter0/1?fw=pt)

NLP は 自然言語処理 (Natural Language Processing)。

英語版のほうが充実してる感じではある。
[Introduction - Hugging Face NLP Course](https://huggingface.co/learn/nlp-course/en/chapter0/1?fw=pt)

[Hugging Face Course の紹介と日本語翻訳について | hiromu NLP BLOG](https://hiromu-nlp.com/huggingface-course-intro/)

## Transformers のモデルのキャッシュを消す方法

検索すると
キャッシュディレクトリは

- macOS または Linux の場合: ~/.cache/huggingface
- Windows の場合: %APPDATA%/huggingface

で、変更は TRANSFORMERS_CACHE 環境変数で、

ぐらいのことはすぐ出てくるのですが、正式なドキュメントが見つからない。

- [Manage \`huggingface_hub\` cache-system](https://huggingface.co/docs/huggingface_hub/main/guides/manage-cache)
- [Cache management](https://huggingface.co/docs/datasets/cache) - データセット(datasets)の方

```bash
pip install huggingface_hub[cli]
huggingface-cli scan-cache
```

のようにマネージメントするのが「正しい」っぽい。

キャッシュの削除は `huggingface-cli delete-cache` で TUI で出来る。( --disable-tui オプションあり)

```console
$ huggingface-cli delete-cache
? Select revisions to delete: 0 revisions selected counting for 0.0.
❯ ○ None of the following (if selected, nothing will be deleted).

Model laion/mscoco_finetuned_CoCa-ViT-L-14-laion2B-s13B-b90k (2.6G, used 2 days ago)
  ○ 11cc43ad: main # modified 6 days ago
```

- [Clean your cache](https://huggingface.co/docs/huggingface_hub/guides/manage-cache#clean-your-cache)
- [Using TUI - Manage \`huggingface_hub\` cache-system](https://huggingface.co/docs/huggingface_hub/guides/manage-cache#using-the-tui)

[huggingface-hub · PyPI](https://pypi.org/project/huggingface-hub/)

## Transformers で扱える有名モデルと扱えない有名モデル

Hugging Face の Transformers ライブラリは、主に Transformer ベースのモデルをサポートしています。そのため、一部の非 Transformer ベースのモデルはサポートされていません。例えば、以下のようなモデルが該当します：

**CNN (Convolutional Neural Networks)**: 画像認識や音声認識などに広く使用されています。特に画像認識では、LeNet, AlexNet, VGGNet などが有名です。

**RNN (Recurrent Neural Networks)**: 時系列データや自然言語処理によく使用されます。LSTM (Long Short-Term Memory) や GRU (Gated Recurrent Unit) などが該当します。

**Autoencoders**: データの圧縮やノイズ除去、異常検出などに使用されます。

**GANs (Generative Adversarial Networks)**: 画像生成やテキスト生成に使用されます。DCGAN, Pix2Pix, CycleGAN などが有名です。

これらのモデルは、PyTorch や TensorFlow などの他の深層学習フレームワークで実装・使用することが可能です。

Hugging Face の Transformers ライブラリは、多くの有名な Transformer ベースのモデルをサポートしています。これらのモデルは、自然言語処理、コンピュータビジョン、音声認識など、さまざまなタスクに使用できます。

例えば、以下のようなモデルがあります：

**BERT (Bidirectional Encoder Representations from Transformers)**: Google によって開発された自然言語処理モデルです。文章分類、固有表現認識、質問応答などのタスクに使用されます。

**GPT-2 (Generative Pretrained Transformer 2)**: OpenAI によって開発された自然言語生成モデルです。文章生成、文章補完、文章要約などのタスクに使用されます。

**GPT-3 (Generative Pretrained Transformer 3)**: OpenAI によって開発された自然言語生成モデルです。GPT-2 よりも大規模で強力です。文章生成、文章補完、文章要約などのタスクに使用されます。

**T5 (Text-to-Text Transfer Transformer)**: Google によって開発された自然言語処理モデルです。文章分類、固有表現認識、質問応答、翻訳などのタスクに使用されます。

**RoBERTa (Robustly Optimized BERT Pretraining Approach)**: Facebook AI によって開発された自然言語処理モデルです。BERT を改良したもので、文章分類、固有表現認識、質問応答などのタスクに使用されます。

**Vision Transformer (ViT)**: Google によって開発されたコンピュータビジョンモデルです。画像分類や物体検出などのタスクに使用されます。

**Swin Transformer**: Microsoft Research Asia によって開発されたコンピュータビジョンモデルです。画像分類や物体検出などのタスクに使用されます。

これらはほんの一部です。Hugging Face の Transformers ライブラリには、さまざまなタスクに対応する多くのモデルが用意されています。

## AI における「モデル」とは

アルゴリズム、パラメータ、ハイパーパラメータ、データセットは、人工知能（AI）における「モデル」の主要構成要素です。

**アルゴリズム**は、モデルの学習に使用される手法を指します。例えば、線形回帰、決定木、ニューラルネットワークなどがあります。

**パラメータ**は、アルゴリズムがデータから学習する値です。これらはモデルの学習過程で最適化され、新たなデータに対する予測を行うために使用されます。

**ハイパーパラメータ**は、モデルの学習過程を制御するための設定値で、通常は手動で設定されます。例えば、学習率やエポック数（訓練データを何回繰り返して学習するか）などがあります。

**データセット**は、モデルの学習に使用されるデータの集合を指します。モデルは、データセットから特定のパターンを学習し、新たなデータに対する予測や分類を行うことができます。

これらの要素が組み合わさって、「モデル」と呼ばれるものが構成されます。

他に

- 学習データの分布
- モデルの解釈可能性

などの要素も、モデルの構成要素と考えられることもある。
