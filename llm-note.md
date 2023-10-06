# 大規模言語モデル (Large Language Models;LLM) メモ

というかほぼ NLP で ほぼ Hugging Face Transformers で PyTorch

- [大規模言語モデル (Large Language Models;LLM) メモ](#大規模言語モデル-large-language-modelsllm-メモ)
  - [概要](#概要)
  - [有名な大規模言語モデル](#有名な大規模言語モデル)
  - [transformers でよく出てくる "pt" とは](#transformers-でよく出てくる-pt-とは)
  - [LLM のタスク](#llm-のタスク)
  - [LLM の代表的なタスク](#llm-の代表的なタスク)
    - [タスクもっと](#タスクもっと)
  - [Transformers のチュートリアル](#transformers-のチュートリアル)
  - [Transformers のモデルのキャッシュを消す方法](#transformers-のモデルのキャッシュを消す方法)
  - [Transformers で扱える有名モデルと扱えない有名モデル](#transformers-で扱える有名モデルと扱えない有名モデル)
  - [AI における「モデル」とは](#ai-におけるモデルとは)
  - [Hugging Face Hub にある有名モデル](#hugging-face-hub-にある有名モデル)
  - [Hugging Face とは?](#hugging-face-とは)
  - [用語](#用語)
    - [ベクトルはテンソルの一種ですか?](#ベクトルはテンソルの一種ですか)
    - [n 次元テンソル と n 階テンソル は同じものですか](#n-次元テンソル-と-n-階テンソル-は同じものですか)
    - [高次元ベクトルって何ですか?](#高次元ベクトルって何ですか)
    - [「低次元ベクトル」と「高次元ベクトル」は何がちがいますか?](#低次元ベクトルと高次元ベクトルは何がちがいますか)
    - [なぜベクトルに変換することを embedding というのですか? Word2Vec が起源ですか?](#なぜベクトルに変換することを-embedding-というのですか-word2vec-が起源ですか)
  - [モデルの cased と uncased](#モデルの-cased-と-uncased)
  - [モデルのファイルサイズ](#モデルのファイルサイズ)
  - [Transformers で特殊トークンのリストを得る](#transformers-で特殊トークンのリストを得る)
  - [パラメーター数](#パラメーター数)
  - [Unicode 正規化](#unicode-正規化)
  - [IOB2 記法 (IOB2 notation)](#iob2-記法-iob2-notation)
  - [pipeline()](#pipeline)
  - [torch の関数の dim=-1](#torch-の関数の-dim-1)
  - [BertJapaneseTokenizer](#bertjapanesetokenizer)
  - [Diffusers](#diffusers)
  - [「エンベッディング」とは](#エンベッディングとは)
  - [いきなり fine-tuning するな (GTP-3.5, 4)](#いきなり-fine-tuning-するな-gtp-35-4)

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

- "pt":PyTorch 形式
- "tf":TensorFlow 形式
- "jax":JAX 形式
- "np":NumPy 形式

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

- 文書分類 (document classification)
- 感情分析 (sentiment analysis)
- 自然言語推論 (naturallanguageinference;NLI)
- 意味的類似度計算 (semantictextualsimilarity;STS)
- 固有表現認識 (namedentityrecognition;NER)
- 要約生成 (summarizationgeneration)
- 質問応答 (questionanswering)
- 機械翻訳 (machine translation)
- 対話システム(dialogue system)
- 形態素解析(morphological analysis)
- 構文解析 (parsing)
- 共参照解析 (coreference resolution)

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

## LLM の代表的なタスク

| タスク                                             | 解説                                                                                                                                                                             |
| -------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 文書分類 (document classification)                 | テキストを、その内容に基づいてカテゴリに分類するタスクです。例えば、ニュース記事の種類や、商品のレビューの評価を分類することができます。                                         |
| 感情分析 (sentiment analysis)                      | テキストの感情を、ポジティブ、ネガティブ、ニュートラルのいずれかに分類するタスクです。例えば、ソーシャルメディアの投稿の感情を分析して、世間のトレンドを把握することができます。 |
| 自然言語推論 (natural language inference;NLI)      | テキストから、ある事実が真実であることを推論するタスクです。例えば、2 つの文章が矛盾するかどうかを判断することができます。                                                       |
| 意味的類似度計算 (semantic textual similarity;STS) | 2 つのテキストの意味の類似度を計算するタスクです。例えば、2 つの文章が同じ内容を言っているかどうかを判断することができます。                                                     |
| 固有表現認識 (named entity recognition;NER)        | テキストから、固有表現 (person, organization, place, etc.) を検出するタスクです。例えば、ニュース記事から、登場人物の名前や、企業の名前を抽出することができます。                |
| 要約生成 (summarization generation)                | テキストを、要点だけを残して短くまとめるタスクです。例えば、長いニュース記事を、短い記事にまとめることができます。                                                               |
| 質問応答 (question answering)                      | 質問に対して、テキストから回答を探し出すタスクです。例えば、ニュース記事の内容に関する質問に答えることができます。                                                               |
| 機械翻訳 (machine translation)                     | 言語間でテキストを翻訳するタスクです。例えば、英語のニュース記事を日本語に翻訳することができます。                                                                               |
| 対話システム(dialogue system)                      | 人間と自然な会話をするシステムです。例えば、顧客サービスや、旅行の予約などのタスクをサポートすることができます。                                                                 |
| 形態素解析(morphological analysis)                 | テキストを、単語と品詞に分解するタスクです。例えば、文法的な間違いを検出することができます。                                                                                     |
| 構文解析 (parsing)                                 | テキストの構造を解析するタスクです。例えば、文の主語や述語を特定することができます。                                                                                             |
| 共参照解析 (coreference resolution)                | テキストの中で、同じものを指す代名詞や指示詞を特定するタスクです。例えば、文章の意味を正しく理解するために必要です。                                                             |

### タスクもっと

未整理。重複アリ

- 文体変換 (style transfer)
- 創造的なコンテンツの作成 (creative content generation)
- チャットボット (chatbot)
- 音声認識 (speech recognition)
- 音声合成 (speech synthesis)
- **テキスト生成 (Text Generation)**: これは、与えられたプロンプトに基づいて新しいテキストを生成するタスクです。例えば、詩や物語、記事などを生成することができます。
- **テキスト補完 (Text Completion)**: これは、与えられたテキストの途中から続きを予測して生成するタスクです。
- **意図認識 (Intent Recognition)**: これは、ユーザーの発話からその意図を理解するタスクです。例えば、音声アシスタントやチャットボットがユーザーの要求を理解するために使用されます。
- **キーワード抽出 (Keyword Extraction)**: これは、テキストから重要な単語やフレーズ(キーワード)を抽出するタスクです。
- **トピックモデリング (Topic Modeling)**: これは、大量の文書からトピック(主題)を抽出するタスクです。

1. 意図解析 (intent recognition): ユーザーが与えたテキストや発話から、その意図や要求を理解するタスクです。対話ボットや仮想アシスタントがユーザーの意図を把握するのに役立ちます。
2. テキスト生成 (text generation): 与えられた指示やコンテキストに基づいて、自動的に文章やテキストを生成するタスクです。文章生成、文章の要約、クリエイティブな文章生成などが含まれます。
3. 意味フレーム検出 (semantic frame detection): テキスト内の言葉やフレーズを特定の意味フレームに関連付けるタスクです。例えば、レストランのレビューから食べ物やサービスに関する情報を抽出する場合があります。
4. テキストクラスタリング (text clustering): 似たような特性を持つテキスト文書をグループ化するタスクです。文書の類似性に基づいて文書をクラスタリングします。
5. 対話生成 (dialogue generation): 対話型のシステムを構築し、ユーザーとの自然な対話を生成するタスクです。応答の生成だけでなく、流暢な対話の維持も含まれます。
6. テキストのエンティティリンキング (entity linking): テキスト内のエンティティ(人物、場所、組織など)を外部の知識ベースと関連付けるタスクです。例えば、"Apple"が果物の名前か企業名かを判別します。
7. テキストのトピックモデリング (topic modeling): テキストコレクション内の文書から共通のトピックやテーマを特定し、文書のクラスタリングや要約に使用されます。
8. テキストの生成言語モデル (text generation language models): 大規模なテキストデータセットを用いて学習したモデルを使用して、文章やテキストの生成を行うタスクです。GPT-3 などが代表的な例です。

## Transformers のチュートリアル

[イントロダクション - Hugging Face NLP Course](https://huggingface.co/learn/nlp-course/ja/chapter0/1?fw=pt)

NLP は 自然言語処理 (Natural Language Processing)。

日本語版の経緯:
[Hugging Face Course の紹介と日本語翻訳について | hiromu NLP BLOG](https://hiromu-nlp.com/huggingface-course-intro/)

英語版:
[Introduction - Hugging Face NLP Course](https://huggingface.co/learn/nlp-course/en/chapter0/1?fw=pt)

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

**TODO: この節は嘘が多いので調査**

Hugging Face の Transformers ライブラリは、主に Transformer ベースのモデルをサポートしています。そのため、一部の非 Transformer ベースのモデルはサポートされていません。例えば、以下のようなモデルが該当します:

**CNN (Convolutional Neural Networks)**: 画像認識や音声認識などに広く使用されています。特に画像認識では、LeNet, AlexNet, VGGNet などが有名です。

**RNN (Recurrent Neural Networks)**: 時系列データや自然言語処理によく使用されます。LSTM (Long Short-Term Memory) や GRU (Gated Recurrent Unit) などが該当します。

**Autoencoders**: データの圧縮やノイズ除去、異常検出などに使用されます。

**GANs (Generative Adversarial Networks)**: 画像生成やテキスト生成に使用されます。DCGAN, Pix2Pix, CycleGAN などが有名です。

これらのモデルは、PyTorch や TensorFlow などの他の深層学習フレームワークで実装・使用することが可能です。

Hugging Face の Transformers ライブラリは、多くの有名な Transformer ベースのモデルをサポートしています。これらのモデルは、自然言語処理、コンピュータビジョン、音声認識など、さまざまなタスクに使用できます。

例えば、以下のようなモデルがあります:

**BERT (Bidirectional Encoder Representations from Transformers)**: Google によって開発された自然言語処理モデルです。文章分類、固有表現認識、質問応答などのタスクに使用されます。

**GPT-2 (Generative Pretrained Transformer 2)**: OpenAI によって開発された自然言語生成モデルです。文章生成、文章補完、文章要約などのタスクに使用されます。

**GPT-3 (Generative Pretrained Transformer 3)**: OpenAI によって開発された自然言語生成モデルです。GPT-2 よりも大規模で強力です。文章生成、文章補完、文章要約などのタスクに使用されます。

**T5 (Text-to-Text Transfer Transformer)**: Google によって開発された自然言語処理モデルです。文章分類、固有表現認識、質問応答、翻訳などのタスクに使用されます。

**RoBERTa (Robustly Optimized BERT Pretraining Approach)**: Facebook AI によって開発された自然言語処理モデルです。BERT を改良したもので、文章分類、固有表現認識、質問応答などのタスクに使用されます。

**Vision Transformer (ViT)**: Google によって開発されたコンピュータビジョンモデルです。画像分類や物体検出などのタスクに使用されます。

**Swin Transformer**: Microsoft Research Asia によって開発されたコンピュータビジョンモデルです。画像分類や物体検出などのタスクに使用されます。

これらはほんの一部です。Hugging Face の Transformers ライブラリには、さまざまなタスクに対応する多くのモデルが用意されています。

## AI における「モデル」とは

アルゴリズム、パラメータ、ハイパーパラメータ、データセットは、人工知能(AI)における「モデル」の主要構成要素です。

**アルゴリズム**は、モデルの学習に使用される手法を指します。例えば、線形回帰、決定木、ニューラルネットワークなどがあります。

**パラメータ**は、アルゴリズムがデータから学習する値です。これらはモデルの学習過程で最適化され、新たなデータに対する予測を行うために使用されます。

**ハイパーパラメータ**は、モデルの学習過程を制御するための設定値で、通常は手動で設定されます。例えば、学習率やエポック数(訓練データを何回繰り返して学習するか)などがあります。

**データセット**は、モデルの学習に使用されるデータの集合を指します。モデルは、データセットから特定のパターンを学習し、新たなデータに対する予測や分類を行うことができます。

これらの要素が組み合わさって、「モデル」と呼ばれるものが構成されます。

他に

- 学習データの分布
- モデルの解釈可能性

などの要素も、モデルの構成要素と考えられることもある。

## Hugging Face Hub にある有名モデル

<https://huggingface.co/docs/transformers/main/en/model_doc/bert>
このへんから左のペインのインデックスを見る。

## Hugging Face とは?

"🤗" (hugging face emoji) が由来。

[Hugging Face And Its Tryst With Success](https://analyticsindiamag.com/hugging-face-and-its-tryst-with-success/)

Hugging Face 社の社名の由来の絵文字 🤗、「笑いながら人を付き飛ばすサイコパス」に見えて怖い。
[hugging face emoji - Google Search](https://www.google.com/search?q=hugging+face+emoji&tbm=isch&source=lnms&hl=en)

[画像 AI を調べると必ず出てくる謎のサイト「Hugging Face」ってナニモノ? 正体は急成長中の“ユニコーン”(1/3 ページ) - ITmedia NEWS](https://www.itmedia.co.jp/news/articles/2302/23/news080.html)

## 用語

「テンソル」等

### ベクトルはテンソルの一種ですか?

ベクトルは、次元が 1 のテンソルです。

次元が 0 のテンソルはスカラーで
次元が 2 のテンソルは行列です。

### n 次元テンソル と n 階テンソル は同じものですか

同じものです。

### 高次元ベクトルって何ですか?

高次元ベクトルとは、単に次元数が高いベクトルのことを指します。

例えば、[1, 2] は 2 次元ベクトルであり、2 次元空間内の点を表します。[1, 2, 3] は 3 次元ベクトルであり、3 次元空間内の点を表します。[1, 2, 3, 4] は 4 次元ベクトルであり、4 次元空間内の点を表します。

### 「低次元ベクトル」と「高次元ベクトル」は何がちがいますか?

長さ。要素数ともいう。比較的長いのが「高次元ベクトル」(笑うところじゃないです)

### なぜベクトルに変換することを embedding というのですか? Word2Vec が起源ですか?

[Embedding(埋め込み表現)とは、単語や文章等の自然言語の構成要素をベクトル表現に変換する処理を指します](https://di-acc2.com/programming/python/26101/)。[この変換操作は、トークンをベクトル空間に埋め込む操作であることから埋め込み(embedding)ともいわれます(一般的に自然言語処理の分野でトークンは単語であるため、単語埋め込み(word embedding)と呼ぶことが多い)](https://developers.agirobots.com/jp/word2vec-and-embeddinglayer/)。

[Word2Vec は、Word を Vector に変換するという意味で分散表現そのものを指すと解釈できますが、より狭義で CBOW や Skip-gram の 2 つのモデルを指すのが一般的です](https://developers.agirobots.com/jp/word2vec-and-embeddinglayer/)。  
Word2Vec は、Embedding の起源ではありませんが、Embedding 技術の発展に大きく貢献した技術です。実際に、Word2Vec は、自然言語処理における Embedding 技術の中でも広く使用されています。

- [Word2Vec とは | 分散表現・Skip-gram 法と CBOW の仕組み・ツールや活用事例まで徹底解説 | Ledge.ai](https://ledge.ai/articles/word2vec)
- [【自然言語処理】word2vec とは何か?CBOW と skip-gram も解説 - omathin blog](https://omathin.com/word2vec-overview/)

## モデルの cased と uncased

BERT-base-cased は、BERT のベースモデルの一種で、テキストの文字の大文字と小文字の区別を学習しています。つまり、"I" と "i" は、異なる単語として扱われます。

一方、BERT-base-uncased は、BERT のベースモデルの一種で、テキストの文字の大文字と小文字の区別を学習していません。つまり、"I" と "i" は、同じ単語として扱われます。

BERT のベースモデルは、大量のテキストデータで学習されています。このとき、テキストの大文字と小文字の区別は、自然言語処理の多くのタスクにおいて重要です。そのため、BERT のベースモデルは、大文字と小文字の区別を学習するように設計されています。

ただし、BERT のベースモデルは、非常に大きなモデルであり、計算コストも高くなります。
そのため、大文字と小文字の区別が重要でないタスクでは、BERT-base-uncased を使用すると、計算コストを削減することができます。

たとえば、テキスト分類のタスクでは、単語の意味を理解することが重要です。この場合、BERT-base-cased を使用すると、より高い精度を達成することができます。
一方、テキスト要約のタスクでは、単語の意味よりも、文章の構造を理解することが重要です。この場合、BERT-base-uncased を使用すると、計算コストを削減することができます。

## モデルのファイルサイズ

Hugging Face Hub でモデルのファイルサイズを事前に知る。

例えば tsmatz/xlm-roberta-ner-japanese だったら
[tsmatz/xlm-roberta-ner-japanese at main](https://huggingface.co/tsmatz/xlm-roberta-ner-japanese/tree/main)
の `pytorch_model.bin` のサイズがおおむねの答え。

キャッシュ後だったら
[huggingface\-hub · PyPI](https://pypi.org/project/huggingface-hub/)
を

```bash
pip install huggingface-hub[cli]
```

して

```console
$ huggingface-cli scan-cache | grep -Fi roberta-ner
tsmatz/xlm-roberta-ner-japanese                        model             1.1G        (以下略)
```

みたいにする。

## Transformers で特殊トークンのリストを得る

`.tokenizer.special_tokens_map`

```python
generator = pipeline(
    "text-generation", model="abeja/gpt2-large-japanese"
)
print(generator.tokenizer.special_tokens_map)
```

```output
{'bos_token': '<s>',
 'eos_token': '</s>',
 'unk_token': '<unk>',
 'sep_token': '[SEP]',
 'pad_token': '[PAD]',
 'cls_token': '[CLS]',
 'mask_token': '[MASK]'}
```

```python
generator = pipeline(
    "text2text-generation", model="retrieva-jp/t5-large-long"
)
print(generator.tokenizer.special_tokens_map)
```

```output
{'eos_token': '</s>',
 'unk_token': '<unk>',
 'pad_token': '<pad>',
 'additional_special_tokens': [
  '<extra_id_0>',
  '<extra_id_1>',
  '<extra_id_2>',
  '<extra_id_3>',
  (略)
  '<extra_id_99>']}
```

[Hugging Face のライブラリを使って Tokenize - Qiita](https://qiita.com/ishikawa-takumi/items/5fc45ddd121b23db5de9)

ドキュメントはどうしても見つけられなかったので Transformers の GitHub から探す。

[transformers/src/transformers/tokenization_utils_base.py at eb8489971ac1415f67b0abdd1584fde8b659ced9 · huggingface/transformers · GitHub](https://github.com/huggingface/transformers/blob/eb8489971ac1415f67b0abdd1584fde8b659ced9/src/transformers/tokenization_utils_base.py#L1306)

Pydoc ちゃんと書いてあるようなので、どこかに変換されてると思うんだけど。

[Utilities for Tokenizers](https://huggingface.co/docs/transformers/v4.33.2/en/internal/tokenization_utils#transformers.SpecialTokensMixin)
ここにあるはずなんだが...
メソッドは書いてあるんだけどプロパティが全部抜けてる感じ。まあプロパティいっぱいあるから...

## パラメーター数

「ニューラルネットワーク内の 1 つの重み (バイアス)」のこと。

シンプルなニューラルネットワークの場合
入力ニューロン × 出力ニューロン が パラメーター数

Transformers で特定モデルのパラメーター数を出すには

```python
from transformers import AutoModel
model_name = "retrieva-jp/t5-large-long"
model = AutoModel.from_pretrained(model_name)
print(sum(p.numel() for p in model.parameters()))
```

```output
750251008  # 七億五千二十五万千八. 0.75Bぐらい
```

これ合ってる?

- [retrieva-jp/t5-large-long · Hugging Face](https://huggingface.co/retrieva-jp/t5-large-long)
- [日本語 T5 モデルの公開|株式会社レトリバ](https://note.com/retrieva/n/n7b4186dc5ada)

TODO: これみたいにパラメータの数が出てるやつで試す。
[ku-nlp/deberta-v2-base-japanese · Hugging Face](https://huggingface.co/ku-nlp/deberta-v2-base-japanese)

## Unicode 正規化

[Unicode 正規化 - Qiita](https://qiita.com/fury00812/items/b98a7f9428d1395fc230)

```python
from unicodedata import normalize
normalized_text = normalize("NFKC", text)
```

[unicodedata --- Unicode データベース — Python 3.11.5 ドキュメント](https://docs.python.org/ja/3/library/unicodedata.html#unicodedata.normalize)

JavaScript だと
[String\.prototype\.normalize\(\) \- JavaScript \| MDN](https://developer.mozilla.org/ja/docs/Web/JavaScript/Reference/Global_Objects/String/normalize)
Node.js ではバージョン 14.17.0 以降、すべてのプラットフォームでサポート。

VSCode の拡張にもあった。
[Unicode Normalizer - Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=espresso3389.unicode-normalizer)

## IOB2 記法 (IOB2 notation)

[Inside–outside–beginning (tagging) - Wikipedia](https://en.wikipedia.org/wiki/Inside%E2%80%93outside%E2%80%93beginning_%28tagging%29)

固有表現抽出の際に用いられるタグ付け記法のひとつ。

固有表現の先頭トークンに B タグ、それ以降のトークンに I タグ。
固有表現以外のトークンに O タグを付与します。

`東京の銀座にあるデパートで買い物をする。`
を IOB2 記法でタグ付けすると:

- 東京 B-LOCATION
- の I-LOCATION
- 銀座 I-LOCATION
- にある I-LOCATION
- デパート I-LOCATION
- で O
- 買い物 O
- する O
- 。 O

※「東京の銀座にあるデパート」を固有表現と見なす立場で。

## pipeline()

Hugging Face の Transformers の pipeline() についてのメモ。

[pipeline の裏側 - Hugging Face NLP Course](https://huggingface.co/learn/nlp-course/ja/chapter2/2) の Colab(PyTorch 版)を動かしながら。

```python
print(classifier.__class__.__name__)   # -> TextClassificationPipeline
#
print(tokenizer.__class__.__name__) # -> DistilBertTokenizerFast
```

トークナイザーの戻り値は IDs (ボキャブラリ&スペシャルトークンの ID の tensor)

[AutoModelForSequenceClassification - Auto Classes](https://huggingface.co/docs/transformers/model_doc/auto#transformers.AutoModelForSequenceClassification)

logits を softmax 関数で確率分布に変換する。

## torch の関数の dim=-1

が便利。

> dim=-1 と指定すると、最後の次元(最内側の次元)に対して適用されます

## BertJapaneseTokenizer

たとえば

```python
model_name="llm-book/bert-base-japanese-v3-ner-wikipedia-dataset"
slow_t = AutoTokenizer.from_pretrained(model_name)
inputs_s = slow_t(text, padding=True, truncation=True, return_tensors="pt")
```

で、`padding` の意味は? という場合どこを見たらいいか。

[BertJapaneseTokenizer](https://huggingface.co/docs/transformers/v4.33.2/en/model_doc/bert-japanese#transformers.BertJapaneseTokenizer)
の 1 個親の
[PreTrainedTokenizer](https://huggingface.co/docs/transformers/v4.33.2/en/main_classes/tokenizer#transformers.PreTrainedTokenizer)
の
[\_\_call\_\_](https://huggingface.co/docs/transformers/v4.33.2/en/main_classes/tokenizer#transformers.PreTrainedTokenizer.__call__)
に載ってる。(
[padding](https://huggingface.co/docs/transformers/v4.33.2/en/main_classes/tokenizer#transformers.PreTrainedTokenizer.__call__.padding)
はここ)

TODO: 例がつまんない。
text が 1 個の文字列だったら padding 意味ない。
truncation も BERT のトークンの最大数しらないと。

[return_offsets_mapping](https://huggingface.co/docs/transformers/v4.33.2/en/main_classes/tokenizer#transformers.PreTrainedTokenizer.__call__.return_offsets_mapping) によると return_offsets_mapping は fast tokenizer にしか実装されてないそうです。

## Diffusers

LLM じゃない?

Bing に聞いてみました:

Hugging Face Diffusers は、画像や音声の生成において最先端の拡散モデルを提供するライブラリです。拡散モデルとは、ノイズの多い画像や音声から徐々にノイズを除去していくことで、高品質な画像や音声を生成する確率的なモデルです。Hugging Face Diffusers は、PyTorch と Flax の両方で動作し、様々な拡散モデルのパイプラインをサポートしています。また、Hugging Face Hub には 4000 以上の事前学習済みの拡散モデルが公開されており、簡単に利用することができます。Hugging Face Diffusers は、自分自身の拡散モデルをゼロから学習したり、既存の拡散モデルを新しいデータセットにファインチューニングしたりすることも可能です。さらに、条件付き生成やガイダンスといった高度な機能も提供しています。Hugging Face Diffusers の詳細については、[公式ドキュメント](^1^)や[GitHub リポジトリ](^2^)をご覧ください。また、[Hugging Face Diffusion Models Course](^3^)という無料のコースもありますので、興味があればぜひ参加してみてください。

ソース: Bing との会話 2023/9/28
(1) Diffusers - Hugging Face. https://huggingface.co/docs/diffusers/index.
(2) GitHub - huggingface/diffusers: Diffusers: State-of-the-art .... https://github.com/huggingface/diffusers.
(3) Hugging Face Diffusion Models Course - GitHub. https://github.com/huggingface/diffusion-models-class.
(4) undefined. https://huggingface.co/docs/diffusers/v0.20.0/en/_app/pages/index.mdx-hf-doc-builder.js.

## 「エンベッディング」とは

"in-context", "context", "embedding" or "grounding" と呼び方はいろいろあるけれど同じ。

モデルに与えるコンテキストのこと。
モデルのパラメータを変更しない(「モデルそのものを変更しない」と言うこと。そこが fine-tuning とは違う)

[qa-japanese1.ipynb - Colaboratory の ここ](https://colab.research.google.com/gist/ohtam1/f50477059958dd3af27a902c6aaf019a/qa-japanese1.ipynb#scrollTo=xlIFtJZdljh0&line=4&uniqifier=1) のことだ

## いきなり fine-tuning するな (GTP-3.5, 4)

[Start with zero\-shot, then few\-shot \(example\), neither of them worked, then fine\-tune](https://help.openai.com/en/articles/6654000-best-practices-for-prompt-engineering-with-openai-api#h_eae065300d)

ゼロショットで始めて
次はフューショット、
それでだめならファインチューニング。
