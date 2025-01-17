# 大規模言語モデル (Large Language Models;LLM) メモ

というかほぼ NLP で ほぼ Hugging Face Transformers で PyTorch

- [概要](#概要)
- [有名な大規模言語モデル](#有名な大規模言語モデル)
- [transformers でよく出てくる "pt" とは](#transformers-でよく出てくる-pt-とは)
- [LLM のタスク](#llm-のタスク)
- [LLM の代表的なタスク](#llm-の代表的なタスク)
  - [タスクもっと](#タスクもっと)
- [Transformers のチュートリアル](#transformers-のチュートリアル)
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
- [よくわからんこと](#よくわからんこと)
- [LLM 評価 (LLM Evaluation)](#llm-評価-llm-evaluation)
  - [評価用語](#評価用語)
  - [有名リーダーボード](#有名リーダーボード)
- [汎用的言語性能測定用ベンチマーク](#汎用的言語性能測定用ベンチマーク)
  - [基礎的言語能力](#基礎的言語能力)
    - [意味解析 (Semantic Analysis)](#意味解析-semantic-analysis)
    - [構文解析 (Syntactic Analysis)](#構文解析-syntactic-analysis)
  - [応用能力](#応用能力)
    - [表現 (Expression)](#表現-expression)
    - [翻訳 (Translation)](#翻訳-translation)
    - [要約 (Summarization)](#要約-summarization)
    - [情報検索 (Information Retrieval)](#情報検索-information-retrieval)
    - [論理的推論 (Logical Reasoning)](#論理的推論-logical-reasoning)
    - [数学的推論 (Mathematical Reasoning)](#数学的推論-mathematical-reasoning)
    - [抽出 (Extraction)](#抽出-extraction)
    - [知識・質問応答 (Knowledge \& Question Answering)](#知識質問応答-knowledge--question-answering)
- [アライン率(Alignment Rate)](#アライン率alignment-rate)
  - [アライン率の具体的な意味](#アライン率の具体的な意味)
  - [アライン率の具体例](#アライン率の具体例)
  - [アラインメント測定用ベンチマーク](#アラインメント測定用ベンチマーク)
    - [制御性 (Control)](#制御性-control)
  - [倫理・道徳 (Ethics/Morality)](#倫理道徳-ethicsmorality)
  - [毒性 (Toxicity)](#毒性-toxicity)
  - [バイアス (Bias)](#バイアス-bias)
  - [真実性 (Truthfulness)](#真実性-truthfulness)
  - [堅牢性 (Robustness)](#堅牢性-robustness)
- [Intuition(直観) の発音](#intuition直観-の発音)
- [llm-jp-eval ベンチマークで使われるデータセット](#llm-jp-eval-ベンチマークで使われるデータセット)
  - [自然言語推論](#自然言語推論)
    - [Jamp - 時間推論データセット](#jamp---時間推論データセット)
    - [JaNLI - 敵対的推論データセット](#janli---敵対的推論データセット)
    - [JNLI データセット](#jnli-データセット)
    - [JSeM - 日本語含意関係データセット](#jsem---日本語含意関係データセット)
    - [JSICK - 英語含意関係データセットの日本語訳](#jsick---英語含意関係データセットの日本語訳)
  - [質疑応答](#質疑応答)
    - [JEMHopQA](#jemhopqa)
    - [NIILC](#niilc)
  - [機械読解](#機械読解)
    - [JSQuAD](#jsquad)
  - [多岐選択式質問応答](#多岐選択式質問応答)
    - [JCommonsenseQA](#jcommonsenseqa)
  - [エンティティ極性分析](#エンティティ極性分析)
    - [chABSA](#chabsa)
  - [基礎解析](#基礎解析)
    - [読み推定 Wikipedia Anotated Corpus](#読み推定-wikipedia-anotated-corpus)
    - [固有表現認識 Wikipedia Anotated Corpus](#固有表現認識-wikipedia-anotated-corpus)
    - [述語構造解析](#述語構造解析)
    - [共参照解析](#共参照解析)
  - [数学的推論](#数学的推論)
    - [MAWPS](#mawps)
  - [意味的類似度計算](#意味的類似度計算)
    - [JSTS](#jsts)
- [llm-jp-eval ベンチマークで使われる評価指標](#llm-jp-eval-ベンチマークで使われる評価指標)
  - [完全一致率 (exact match ratio)](#完全一致率-exact-match-ratio)
  - [文字ベース F 値 (Character-based F-score)](#文字ベース-f-値-character-based-f-score)
  - [集合ベース F 値(Set-based F-score)](#集合ベース-f-値set-based-f-score)
  - [おまけ: 「F 値」解説](#おまけ-f-値解説)
    - [基本概念](#基本概念)
    - [なぜ F 値を使うのか?](#なぜ-f-値を使うのか)
    - [F 値の種類](#f-値の種類)
    - [F 値の実用例](#f-値の実用例)
  - [相関係数](#相関係数)
  - [ピアソンの積率相関係数(Pearson's Correlation Coefficient)](#ピアソンの積率相関係数pearsons-correlation-coefficient)
    - [ピアソンの計算式](#ピアソンの計算式)
    - [ピアソンの特徴](#ピアソンの特徴)
  - [スピアマンの順位相関係数(Spearman's Rank Correlation Coefficient)](#スピアマンの順位相関係数spearmans-rank-correlation-coefficient)
    - [スピアマンの計算式](#スピアマンの計算式)
    - [スピアマンの特徴](#スピアマンの特徴)
- [Japanese Vicuna QA](#japanese-vicuna-qa)
- [ベンチマークを共通で扱うツール](#ベンチマークを共通で扱うツール)
- [Instruct モデル](#instruct-モデル)
  - [Instruct モデル の作り方](#instruct-モデル-の作り方)
  - [日本語の指示付きデータセットで Hugging Face Hub にあるやつ](#日本語の指示付きデータセットで-hugging-face-hub-にあるやつ)
  - [汎用言語モデルと Instruct モデルの指示への応答性能を比較するためのベンチマーク](#汎用言語モデルと-instruct-モデルの指示への応答性能を比較するためのベンチマーク)

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

[Word2Vec は、Word を Vector に変換するという意味で分散表現そのものを指すと解釈できますが、より狭義で CBOW や Skip-gram の 2 つのモデルを指すのが一般的です](https://developers.agirobots.com/jp/word2vec-and-embeddinglayer/)。\
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

## よくわからんこと

- 活性化関数はなぜ必要 (リニアにすると学習しないので、必要なのはわかる。ただ「なぜ必要」はわからない)
- fill-mask タスク用のモデルを sequence classification タスク用 として fine-tuning できるのは何故? レベルの数だってまるで違うのに。
- 入力シーケンス数が 2 以上の入力はどうやって?
- 入力シーケンス数が 2 以上の入力の場合、出力側はどう評価する?
- Transformer のエンコーダとデコーダ。よくわからん。CNN -> RNN -> annotation と学んでいかないとダメかな。

## LLM 評価 (LLM Evaluation)

[大規模言語モデル入門 II 〜生成型 LLM の実装と評価 : 書籍案内 | 技術評論社](https://gihyo.jp/book/2024/978-4-297-14393-0)
を読みながら書いてるメモ。

### 評価用語

- **ベンチマーク (benchmark)** -
  データセットや評価方法などを定めたもの。**LLM 間の比較に使う**。複数の「データセットと評価指数」の組から出来ている。
- **リーダーボード (leaderboard)** -
  べンチマークなどでのモデルの性能を見やすくウエプページなどの形でまとめたもの。
  評価基準はべンチマーク以外もある(ChatbotArena など)
- **アラインメント (Alignment)** -
  汎用的言語性能以外に LLM の安全性能を評価する基準の一つで、主に AI が人間の価値観や意図に沿った動作をするかどうかを測る指標。下の [アライン率(Alignment Rate)](#アライン率alignment-rate) も参照

### 有名リーダーボード

- [Open LLM Leaderboard 2 - a Hugging Face Space by open-llm-leaderboard](https://huggingface.co/spaces/open-llm-leaderboard/open_llm_leaderboard)

Open LLM Leaderboard 1 は 1 年で終わった。理由は:

1. ベンチマークがの問題が簡単すきる。 一部モデルが人間と同程度の性能に達した。
2. 一部のモデルがベンチマークのデータあるいはそれに類するデータで学習されたことが確認された。
3. べンチマークにエラーが含まれていた。

- [Large Model Systems Organization (LMSYS Org) の "Chatbot Arena"](https://lmsys.org/blog/2023-05-03-arena/)

> ChatbotArena とは、自由記述形式のタスクで、 LLM がどれだけ人の好みに合った回答をするかを評価するために作られたものです。一般ユーザが無作為に選ばれたニつの匿名モデルに対してプロンプトを入力し、そのニつのモデルの回答のどちらがいいか、あるいは「引き分け」「どちらも悪い」のいすれかを投票し、その投票結果に基づいてモデルのランキングを決定します。
>
> 2024 年 7 月時点で、比較対象のモデルは 1 を超え、投票数も 100 万票以上集まっています。

アリーナはここ。
[Chatbot Arena (formerly LMSYS): Free AI Chat to Compare & Test Best AI Chatbots](https://lmarena.ai/)
chat のところに文章入れて、
ランダムに選ばれたモデル 2 つが返してくる
出力結果を、A か B か、引き分けか、どっちもダメかを評価する。

- [Nejumi LLM リーダーボード 3](https://wandb.ai/wandb-japan/llm-leaderboard3/reports/Nejumi-LLM-3--Vmlldzo3OTg2NjM2)

LLM の日本語能力を比較するためのリーダーボード

## 汎用的言語性能測定用ベンチマーク

汎用的言語性能(General Language Processing, GLP) は、
モデルが多岐にわたる言語処理タスクにどれだけ対応できるか、すなわちモデルが実世界の問題にどれだけ汎用的に適用できるかを測定する指標である。
これには表現能力から知識に基づく質問応答能力まで、さまざまな言語処理タスクが含まれている。

### 基礎的言語能力

#### 意味解析 (Semantic Analysis)

- **jaster** の
  - **JNLI** (日本語自然言語推論)
  - **JaNLI** (日本語自然言語推論)
  - **JSeM** (セマンティック役割ラベリング)
  - **JSICK** (意味的文脈理解)
  - **Jamp** (意味的解釈)

など。
これらはモデルがテキストの意味を理解し、文脈に応じた適切な解釈ができるかを測るタスクである。

#### 構文解析 (Syntactic Analysis)

- **jaster** の
  - **JCoLA-in-domain** (ドメイン内の構文解析)
  - **JCoLA-out-of-domain** (ドメイン外の構文解析)
  - **JBLiMP** (日本語構文解析)
  - **wiki_reading** (ウィキペディア文書の読解)
  - **wiki_pas** (ウィキペディアの依存関係解析)
  - **wiki_dependency** (依存関係解析)

など。
これによりモデルが文の構造を理解し、正しい文法や依存関係を解析できるかが評価される。

### 応用能力

#### 表現 (Expression)

**MT-bench** (roleplay, humanities, writing)。

これには AI が役割を演じる能力(roleplay)、人文学的なテーマに関する理解、または創造的な文章作成能力(writing)が含まれる。

この評価では、AI が与えられたコンテキストに基づいて自然で一貫性のある文章を作成できるかを測定する。

#### 翻訳 (Translation)

- **jaster** の
  - **ALT e-to-j** (英語から日本語への翻訳)
  - **ALT j-to-e** (日本語から英語への翻訳)
  - **wikicorpus-e-to-j**、**wikicorpus-j-to-e** (ウィキペディアの英語と日本語のコーパス間の翻訳)

など。
モデルが異なる言語間で適切に意味を伝達できる能力を測定する。

#### 要約 (Summarization)

要約タスクは長文を要約して短くわかりやすい情報に変換する能力を測定する。

※ 要約の評価データセットは探索中であり、実施されていません (Nejumi leaderboard 3)。

#### 情報検索 (Information Retrieval)

**JSQuaD** (JGLUE)。

情報検索タスクでは、与えられた質問に対して最も関連性の高い情報を適切に抽出する能力が評価される。

※ JGLUE は、情報検索や文書検索の精度を測るためのベンチマークです。

#### 論理的推論 (Logical Reasoning)

**MT-bench** の reasoning タスク。

モデルが論理的に思考し、与えられた情報から合理的な結論を導けるかを評価する。

#### 数学的推論 (Mathematical Reasoning)

- **jaster** の **MAWPS**(数学的問題解決)、**MGSM**(数学の推論)
- **MT-bench**の math タスク

モデルが数学的な問題を解決できる能力を測る。

#### 抽出 (Extraction)

- **jaster** の
  - **wiki_ner** (名前付き実体認識)
  - **wiki_coreference** (照応関係解析)
  - **chABSA** (感情分析)
- **MT-bench** の extraction タスク

テキストから情報を抽出する能力を評価する。

たとえば名前付き実体認識では、人名や場所名などの重要な情報を正確に識別できるかどうかが評価される。

#### 知識・質問応答 (Knowledge & Question Answering)

- **jaster** の
  - **JCommonsenseQA** (常識的な QA)
  - **JEMHopQA** (多段階推論型 QA)
  - **JMMLU** (マルチリンガルな質問応答)
  - **NIILC** (日本語インターネット文書)
  - **aio** (多目的 QA)
- **MT-bench** の **stem**(STEM 分野の QA)

など。これにより、モデルが日常的な知識や専門的な質問に答える能力が評価される。

## アライン率(Alignment Rate)

主に AI や大規模言語モデル(LLM)が出力する結果が、事前に定義された基準や人間の意図とどれだけ一致しているかを示す指標。
アライン率が高いほど、AI の出力が望ましい方向性に沿っていることを意味し、逆に低い場合は AI が意図した方向から逸脱している可能性が高いとされる。

### アライン率の具体的な意味

- **選択肢問題の場合** -
  例えば、AI が与えられた質問に対して複数の選択肢を提供する場合、アライン率は、その選択肢の中で「正解」または「最も適切な選択肢」がどれだけ高い確率で選ばれるかを測るもの。もし AI が人間の意図や判断にぴったり合った選択肢を提供できていれば、アライン率は高くなる。
- **評価基準の一致度** -
  アライン率はまた、AI の出力が事前に設定された倫理基準や道徳基準、または社会的に適切な基準にどれだけ一致するかを測る。この場合、アライン率が高いということは、AI が望ましい、または受け入れられる基準に従って動作しているということになる。

### アライン率の具体例

- **倫理的アラインメント** -
  AI が人種差別や性差別を含まない発言をするかどうかという点で、AI の出力が倫理的に正しいかどうかをチェックすること。これが高いアライン率であれば、AI は不偏見的で倫理的に正しい回答を多く生成しているといえる。
- **ユーザーの意図との一致** -
  ユーザーが求める情報や答えに AI がどれだけ近い答えを出せるか。たとえば、AI が質問に対して正確かつ関連性の高い回答をする場合、そのアライン率は高いとされる。

### アラインメント測定用ベンチマーク

日本語用のもの

#### 制御性 (Control)

**LCTG Bench** や **jaster** などの選択肢問題におけるアライン率。

制御性とは、AI が出力する結果を人間が適切に制御できる能力に関するもので、予測や応答がユーザーの意図と一致しているかを見ます。選択肢問題のアライン率は、AI が選択肢を提供する際に人間の意図に適した選択肢を提示する能力を測るものです。

### 倫理・道徳 (Ethics/Morality)

**jaster**の**JcommonsenseMorality** や **AnswerCarefully** など。

AI が出力する内容が倫理的かつ道徳的に妥当であるか、悪意のある内容(暴力的、差別的、偏見を助長するなど)を含まないかを評価する。この評価基準は、AI が倫理的に問題のない応答をするかどうかを重視する。

### 毒性 (Toxicity)

**LINE ヤフー 信頼性評価データセット**。

- 毒性とは、AI が人を傷つける、侮辱する、不快にさせるような発言をしないか、またそのリスクをどれだけ低減できるかを評価。具体的には、誹謗中傷や有害な言葉を避ける能力が求められる。

### バイアス (Bias)

**JBBQ**。

バイアスとは、AI が出力する内容が特定の人種、性別、宗教、文化などに偏っているかどうかを測る指標。AI が公平であること、偏見を助長しないことが重要。

### 真実性 (Truthfulness)

**JTruthfulQA**。

AI の回答がどれほど真実に基づいているかを測定する。AI は虚偽の情報を提供しないことが求められ、特にファクトチェックや事実に基づく正確な情報の提供が重要とされる。

### 堅牢性 (Robustness)

**jaster** の **JMMLU の拡張版**。

AI が様々な状況下で安定したパフォーマンスを発揮するか、特に予期しない入力や挑戦的な状況においても一貫性を保つことが評価される。

## Intuition(直観) の発音

in·tyoo·**i**·shn

i にアクセント。

## llm-jp-eval ベンチマークで使われるデータセット

[大規模言語モデル入門 II 〜生成型 LLM の実装と評価 : 書籍案内 | 技術評論社](https://gihyo.jp/book/2024/978-4-297-14393-0)
の 10.2 節を読みながら書いてるメモ。

他参考:

- [日本語 LLM 評価データセットの huggingface/datasets 登録状況](https://zenn.dev/hellorusk/articles/45c2f6fac964fc)
- [llm-book/llm-jp-eval at main](https://huggingface.co/datasets/llm-book/llm-jp-eval/tree/main) ここの Python のコード中にデータセットの源 URL が入ってる
- [JGLUE/datasets at main · yahoojapan/JGLUE](https://github.com/yahoojapan/JGLUE/tree/main/datasets)

| カテゴリ             | データセット               | ライセンス   | 評価指標        |
| -------------------- | -------------------------- | ------------ | --------------- |
| 自然言語推論         | Jamp                       | CC BY-SA 4.0 | 完全一致率      |
|                      | JaNLI                      | CC BY-SA 4.0 | 完全一致率      |
|                      | JNLI                       | CC BY-SA 4.0 | 完全一致率      |
|                      | JSeM                       | BSD 3-Clause | 完全一致率      |
|                      | JSICK                      | CC BY-SA 4.0 | 完全一致率      |
| 質問応答             | JEMHopQA                   | CC BY-SA 4.0 | 文字ベース F 値 |
|                      | NIILC                      | CC BY-SA 4.0 | 文字ベース F 値 |
| 機械読解             | JSQuAD                     | CC BY-SA 4.0 | 文字ベース F 値 |
| 多肢選択式質問応答   | JCommonsenseQA             | CC BY-SA 4.0 | 完全一致率      |
| エンティティ極性分析 | chABSA                     | CC BY 4.0    | 集合ベース F 値 |
| 基礎解析             | Wikipedia Annotated Corpus | CC BY-SA 4.0 | 集合ベース F 値 |
| 数学的推論           | MAWPS                      | Apache-2.0   | 完全一致率      |
| 意味の類似度計算     | JSTS                       | CC BY-SA 4.0 | 相関係数        |

### 自然言語推論

前提文と仮定文を用意して、
その文ペアの論理的な関係を予測するタスク。

#### Jamp - 時間推論データセット

- [tomo-vv/temporalNLI_dataset](https://github.com/tomo-vv/temporalNLI_dataset)
  - dataset/train_all.tsv
  - dataset/test_2.tsv

[完全一致率](#完全一致率-exact-match-ratio)で比較。

#### JaNLI - 敵対的推論データセット

- [JaNLI: 日本語の言語現象に基づく敵対的推論データセット JED2022_yanaka](https://jedworkshop.github.io/jed2022/materials/jed2022_d-2_%E8%B0%B7%E4%B8%AD.pdf)
- [verypluming/JaNLI](https://github.com/verypluming/JaNLI)
- [hpprc/janli · Datasets at Hugging Face](https://huggingface.co/datasets/hpprc/janli)

[完全一致率](#完全一致率-exact-match-ratio)で比較。

#### JNLI データセット

画像キャプションをもとに作成されたデータセット。

- [JGLUE/datasets/jnli-v1.1 at main · yahoojapan/JGLUE](https://github.com/yahoojapan/JGLUE/tree/main/datasets/jnli-v1.1)

[完全一致率](#完全一致率-exact-match-ratio)で比較。

#### JSeM - 日本語含意関係データセット

- [DaisukeBekki/JSeM: Japanese semantic test suite (FraCaS counterpart and extensions)](https://github.com/DaisukeBekki/JSeM)
- [JSeM: Japanese semantic test suite (Japanese FraCaS and extensions) | JSeM](https://daisukebekki.github.io/JSeM/)

[完全一致率](#完全一致率-exact-match-ratio)で比較。

#### JSICK - 英語含意関係データセットの日本語訳

- [verypluming/JSICK: Repository for JSICK](https://github.com/verypluming/JSICK)
- [hpprc/jsick · Datasets at Hugging Face](https://huggingface.co/datasets/hpprc/jsick)

[完全一致率](#完全一致率-exact-match-ratio)で比較。

### 質疑応答

#### JEMHopQA

#### NIILC

### 機械読解

#### JSQuAD

### 多岐選択式質問応答

#### JCommonsenseQA

### エンティティ極性分析

#### chABSA

### 基礎解析

#### 読み推定 Wikipedia Anotated Corpus

#### 固有表現認識 Wikipedia Anotated Corpus

#### 述語構造解析

#### 共参照解析

### 数学的推論

#### MAWPS

### 意味的類似度計算

テキストのペアが与えられ、その意味的な近さを評価する。

#### JSTS

日本語の STS。

- [JGLUE/datasets/jsts-v1.1 at main · yahoojapan/JGLUE](https://github.com/yahoojapan/JGLUE/tree/main/datasets/jsts-v1.1)
- [日本語テキスト埋め込みベンチマーク JMTEB の構築 - SB Intuitions TECH BLOG](https://www.sbintuitions.co.jp/blog/entry/2024/05/16/130848)

1 つの画像に付けられたキャプションを 2 つ用意して、
そのキャプションの近似度を 5 人の人間が 0 から 5 までのスコアで評価し、
その平均値を正解ラベルとしたデータセット。

0 は「全く異なる意味」、5 は「完全に同じ意味」。

相関係数で比較。

[JSTS](https://github.com/yahoojapan/JGLUE?tab=readme-ov-file#jsts) 参照。

画像の元は [COCO - Common Objects in Context](https://cocodataset.org/#home)
むかしは "MS COCO" と呼ばれていたが、オープン化されて "COCO Dataset" になったらしい。

MS COCO → [YJCaptions](https://github.com/yahoojapan/YJCaptions) → JSTS という流れ。

JSTS は [flexeval](https://github.com/sbintuitions/flexeval) には入ってないけど、
おなじ SB Intuitions の[JMTEB](https://github.com/sbintuitions/JMTEB)で出来るらしい。

## llm-jp-eval ベンチマークで使われる評価指標

[大規模言語モデル入門 II 〜生成型 LLM の実装と評価 : 書籍案内 | 技術評論社](https://gihyo.jp/book/2024/978-4-297-14393-0)
の 10.2.3 節を読みながら書いてるメモ。

### 完全一致率 (exact match ratio)

$$
\text{完全一致率} = \frac{\text{正解事例と予測事例の一致数}}{\text{事例数}}
$$

### 文字ベース F 値 (Character-based F-score)

文字単位での正解と予測の一致を評価する指標です。
自然言語処理や情報抽出の分野で、特に名前の一致や OCR(光学文字認識)など、
正確な文字レベルの一致が重要なタスクで使われます。

具体例:

- 正解: 猫はかわいい
- 予測: 猫はかっこいい

この場合

- 一致する文字 (True Positive, TP): 猫は
- 過剰な文字 (False Positive, FP): っこ
- 不足している文字 (False Negative, FN): かわ

評価式:

- Precision (適合率): TP / (TP + FP)
- Recall (再現率): TP / (TP + FN)
- F-score: 2 × (Precision × Recall) / (Precision + Recall)

### 集合ベース F 値(Set-based F-score)

集合ベース F 値は、単語やフレーズ、文といった集合単位で正解と予測を評価する指標です。
たとえば、構造化情報の抽出やトピック分類など、
単位が文字ではなく「意味のある単位」に焦点を当てる場合に使われます。

具体例:

- 正解: {猫, かわいい}
- 予測: {猫, かっこいい}

この場合

- 一致する要素 (True Positive, TP): {猫}
- 過剰な要素 (False Positive, FP): {かっこいい}
- 不足している要素 (False Negative, FN): {かわいい}

評価式:

文字ベースと同じ。

- Precision (適合率): TP / (TP + FP)
- Recall (再現率): TP / (TP + FN)
- F-score: 2 × (Precision × Recall) / (Precision + Recall)

### おまけ: 「F 値」解説

F 値は、**Precision(適合率)** と **Recall(再現率)** という 2 つの評価指標を 1 つにまとめた指標です。
主に分類タスクや検索タスクで、モデルの予測性能をバランスよく評価するために用いられます。
F 値は **Precision** と **Recall** の
[調和平均](https://ja.wikipedia.org/wiki/%E8%AA%BF%E5%92%8C%E5%B9%B3%E5%9D%87)
として計算されます。

参考: [Precision と Recall の違いと覚え方](https://www.chowagiken.co.jp/blog/Precision_Recall)

#### 基本概念

1. **Precision(適合率)**  
   モデルが「正しい」と予測した結果のうち、本当に正しかった割合を表します。

   $$
   \text{Precision} = \frac{\text{True Positive (TP)}}{\text{True Positive (TP)} + \text{False Positive (FP)}}
   $$

   **例**:\
   モデルが猫の画像を 10 枚予測し、そのうち 7 枚が正解だった場合、適合率は 7/10 = 0.7。

2. **Recall(再現率)**  
   実際に正しいもののうち、モデルが正しく予測できた割合を表します。

   $$
   \text{Recall} = \frac{\text{True Positive (TP)}}{\text{True Positive (TP)} + \text{False Negative (FN)}}
   $$

   **例**:\
   実際に猫の画像が 15 枚あり、そのうち 7 枚をモデルが正しく予測した場合、再現率は 7/15 = 0.47。

3. **F 値 (F-score)**  
   Precision と Recall を統一的に評価するための指標です。

   $$
   F_1 = 2 \cdot \frac{\text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}
   $$

   - **F 値の範囲**: 0(最低)〜1(最高)
   - **解釈**: F 値が 1 に近いほど、Precision と Recall の両方を高い水準で満たしています。

#### なぜ F 値を使うのか?

1. **Precision と Recall のバランスを取る**

   - Precision が高い場合、予測が正確だが一部を見逃す可能性がある。
   - Recall が高い場合、多くを見つけるが誤った予測が増える可能性がある。
   - F 値はこれらのトレードオフを 1 つの指標で表現します。

2. **モデル比較に便利**
   - Precision と Recall のどちらか一方に偏らず、全体的な性能を評価できるため、異なるモデル間での比較がしやすい。

#### F 値の種類

F 値には調和平均の重みを変えたバリエーションがあります。

1. **F1 値** (デフォルト)\
   Precision と Recall を等しく重要とする場合に使います。

2. **Fβ 値** - 重み付き F 値 (Weighted F-measure)\
   Recall を重視する場合は β > 1、Precision を重視する場合は β < 1。

   $$
   F\beta = (1 + \beta^2) \cdot \frac{\text{Precision} \cdot \text{Recall}}{\beta^2 \cdot \text{Precision} + \text{Recall}}
   $$

   **例**: F2 値は Recall をより重視し、F0.5 値は Precision を重視します。

#### F 値の実用例

- **検索エンジン**: ユーザーが求める結果を正確に(Precision)、そして漏れなく(Recall)返すことが重要。
- **自然言語処理**: 情報抽出や文書分類でモデルの性能を評価。
- **医療診断**: 正しい診断(Precision)と病気の見逃しを減らす(Recall)バランスが重要。

F 値は評価対象やタスクの目的に応じて最適なモデル選択をサポートします。

### 相関係数

「ピアソンの積率相関係数」と
「スピアマンの順位相関係数」が
使われる。

| 特徴                 | ピアソンの積率相関係数 | スピアマンの順位相関係数 |
| -------------------- | ---------------------- | ------------------------ |
| **関係の種類**       | 線形関係               | 単調関係                 |
| **データの特性**     | 連続変数               | 順位データまたは連続変数 |
| **外れ値の影響**     | 大きい                 | 小さい                   |
| **非線形関係の検出** | 不可能                 | 可能                     |

使い分け:

1. **ピアソンを使う場面**:

   - データが線形関係にあると仮定できる場合。
   - 外れ値が少ないデータ。

2. **スピアマンを使う場面**:
   - 非線形の単調関係を評価したい場合。
   - 外れ値が多い場合。
   - データが順位またはカテゴリの場合。

実用例:

1. **ピアソン**:

   - 身長と体重の関係
   - 売上と広告費の関係(線形性が期待できる場合)

2. **スピアマン**:
   - テストの順位と学習時間の関係
   - 商品の評価ランキングと売上の関係

モデル評価で使う場合:

相関係数は数値データ同士の関係性を測る指標なので、数値データでなければ計算できない。
普通モデルの出力は文字列なので、そのままでは使えない。
[dottxt-ai/outlines: Structured Text Generation](https://github.com/dottxt-ai/outlines)
を使うらしいのだが詳細不明。LangChain みたいなもの?(主義主張思想がかなり違うけど)

### ピアソンの積率相関係数(Pearson's Correlation Coefficient)

ピアソンの積率相関係数は、**2 つの連続変数の線形関係の強さ**を測定する指標です。
その値は **-1 から 1 の範囲** をとり、
値が 0 に近いほど関係が弱く、
1 または-1 に近いほど強い関係があることを示します。

- +1 : 完全な正の相関(片方が増えるともう片方も増える)
- -1 : 完全な負の相関(片方が増えるともう片方は減る)
- 0 : 無相関(関係がない)

#### ピアソンの計算式

$$
r = \frac{\sum*{i=1}^n (x_i - \bar{x})(y_i - \bar{y})}{\sqrt{\sum*{i=1}^n (x*i - \bar{x})^2 \sum*{i=1}^n (y_i - \bar{y})^2}}
$$

- $x_i,y_i$ : 各データ点
- $\bar{x},\bar{y}$: $x_i,y_i$ の平均
- $n$: データ点の数

#### ピアソンの特徴

- **線形性が前提**: 線形関係でない場合、結果が正確に解釈できません。
- 外れ値に敏感: 極端な値があると、相関係数が大きく変わることがあります。

### スピアマンの順位相関係数(Spearman's Rank Correlation Coefficient)

スピアマンの順位相関係数は、**2 つの変数の単調関係の強さ** を測定する指標です。
データを **順位(rank)に基づいて評価** するため、
非線形の関係でも利用できます。

- 値の範囲はピアソンと同じく **-1 から 1**。
- 単調関係: 片方が増加(または減少)すれば、もう片方も増加(または減少)する。

#### スピアマンの計算式

スピアマンの相関係数 $\rho$ は、順位データを用いたピアソン相関係数として計算されます。

簡易計算式(順位データが重複しない場合):

$$
\rho = 1 - \frac{6 \sum d_i^2}{n(n^2 - 1)}
$$

- $d_i$ : 各データペアの順位差 ( $d_i = \text{rank}(x_i) - \text{rank}(y_i)$)
- $n$ : データペアの数

#### スピアマンの特徴

- 非線形の単調関係も検出可能。
- 外れ値に強い(順位を用いるため影響を受けにくい)。
- 順位データやカテゴリデータにも対応可能。

## Japanese Vicuna QA

ビクーニャ、またはビクーナ。
ラクダ科に分類される偶蹄類。
[ビクーニャ - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%93%E3%82%AF%E3%83%BC%E3%83%8B%E3%83%A3)

Vicuna QA を手作業で日本語に翻訳したもの。

- LLM vs 他の LLM の出力を、さらにほかの LLM がランク付けして評価する
  - 自動評価で迅速評価
  - ただし評価するモデルのバイアスが課題
- 公開データセットで構成され、再現性が高い
- 正確性、詳細性、創造性などを多面的に評価すると言われる
- プロンプト工学の検証にも有効

参考:

- [日本語 VicunaQA ベンチマーク:リーダーボード | ja-vicuna-qa-benchmark – Weights & Biases](https://wandb.ai/llm-jp-eval/ja-vicuna-qa-benchmark/reports/-VicunaQA---Vmlldzo2Mjk2OTI3?accessToken=zmfqg0olpjj7yarp6gpofxi8jl0v1no32hh38fi8s3suko9hm9hk2irj2b5c17xh)
- [ku-nlp/ja-vicuna-qa-benchmark](https://github.com/ku-nlp/ja-vicuna-qa-benchmark)
- 実例: [llm-book/ja-vicuna-qa-benchmark · Datasets at Hugging Face](https://huggingface.co/datasets/llm-book/ja-vicuna-qa-benchmark/viewer)

## ベンチマークを共通で扱うツール

プロンプト(zero-shot だったり few-shot だったり)のちがいで性能変わったりもあるので、
統一基準で動かせるものがあれば便利ではある。

- [sbintuitions/flexeval: Flexible evaluation tool for language models](https://github.com/sbintuitions/flexeval)
- [sbintuitions/JMTEB: The evaluation scripts of JMTEB (Japanese Massive Text Embedding Benchmark)](https://github.com/sbintuitions/JMTEB?tab=readme-ov-file)

## Instruct モデル

- Instruct モデル - 明確で具体的な指示に適する
- 汎用言語モデル - 幅広いタスクや抽象的な指示に対応可能

汎用言語モデルに対してインストラクションチューニングを施したものが Instruct モデル。\
Instruct モデル = 汎用言語モデル + 指示適応学習と捉えることができる。

### Instruct モデル の作り方

1. 基礎となる汎用言語モデル
   - 大規模なデータセットで事前学習され、多様な知識や言語能力を備えています。この段階では特定の指示への最適化はされていません。
2. インストラクションチューニング(Instruction Fine-Tuning)
   - 指示付きデータセットを使い、モデルが指示や命令文を正確に解釈し、適切な応答を生成するよう訓練します。
   - このデータセットには、人間のフィードバック(例: Reinforcement Learning from Human Feedback, RLHF)による調整が加わることがあります。
   - 例: 「このテキストを要約してください」「〇〇についてのリストを作ってください」などの具体的な指示を含む。
3. 結果: Instruct モデル
   - このプロセスの結果として、ユーザー意図をより適切に理解し、応答を出力する能力が向上します。
   - 例えば、OpenAI の InstructGPT シリーズは、GPT-3 をベースにインストラクションチューニングを施したものです。

### 日本語の指示付きデータセットで Hugging Face Hub にあるやつ

- [dolly-15k-ja](https://huggingface.co/datasets?modality=modality:text&sort=trending&search=dolly-15k-ja) - Databricks 社が公開した英語の指示データセット dolly-15k を自動翻訳して日本語化したもの。ただし自動翻訳による品質のばらつきが。
- [jimba-instuction-1k-beta](https://huggingface.co/datasets/Kendamarron/jimba-instuction-1k-beta) - Calm2-7b-chat モデルを用いて生成し、人手でチェック・修正した日本語のインストラクションデータセット。商用利用も可能。
- 他、[Hugging Face – The AI community building the future.](https://huggingface.co/datasets?modality=modality:text&sort=trending&search=Japanese+instruction)

### 汎用言語モデルと Instruct モデルの指示への応答性能を比較するためのベンチマーク

(以下正しいかは微妙)

- HELM (Holistic Evaluation of Language Models) - https://crfm.stanford.edu/helm/
- BIG-bench (Beyond the Imitation Game Benchmark) - https://github.com/google/BIG-bench
- Super-NaturalInstructions
- OpenAI の独自ベンチマーク
- Chatbot Arena (蒸留モデル対話評価)
