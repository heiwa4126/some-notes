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

| タスク                                           | 解説                                                                                                                                                                             |
| ------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 文書分類 (document classification)               | テキストを、その内容に基づいてカテゴリに分類するタスクです。例えば、ニュース記事の種類や、商品のレビューの評価を分類することができます。                                         |
| 感情分析 (sentiment analysis)                    | テキストの感情を、ポジティブ、ネガティブ、ニュートラルのいずれかに分類するタスクです。例えば、ソーシャルメディアの投稿の感情を分析して、世間のトレンドを把握することができます。 |
| 自然言語推論 (natural language inference;NLI)    | テキストから、ある事実が真実であることを推論するタスクです。例えば、2 つの文章が矛盾するかどうかを判断することができます。                                                       |
| 意味的類似度計算 (semantictextualsimilarity;STS) | 2 つのテキストの意味の類似度を計算するタスクです。例えば、2 つの文章が同じ内容を言っているかどうかを判断することができます。                                                     |
| 固有表現認識 (namedentityrecognition;NER)        | テキストから、固有表現 (person, organization, place, etc.) を検出するタスクです。例えば、ニュース記事から、登場人物の名前や、企業の名前を抽出することができます。                |
| 要約生成 (summarizationgeneration)               | テキストを、要点だけを残して短くまとめるタスクです。例えば、長いニュース記事を、短い記事にまとめることができます。                                                               |
| 質問応答 (questionanswering)                     | 質問に対して、テキストから回答を探し出すタスクです。例えば、ニュース記事の内容に関する質問に答えることができます。                                                               |
| 機械翻訳 (machine translation)                   | 言語間でテキストを翻訳するタスクです。例えば、英語のニュース記事を日本語に翻訳することができます。                                                                               |
| 対話システム(dialogue system)                    | 人間と自然な会話をするシステムです。例えば、顧客サービスや、旅行の予約などのタスクをサポートすることができます。                                                                 |
| 形態素解析(morphological analysis)               | テキストを、単語と品詞に分解するタスクです。例えば、文法的な間違いを検出することができます。                                                                                     |
| 構文解析 (parsing)                               | テキストの構造を解析するタスクです。例えば、文の主語や述語を特定することができます。                                                                                             |
| 共参照解析 (coreference resolution)              | テキストの中で、同じものを指す代名詞や指示詞を特定するタスクです。例えば、文章の意味を正しく理解するために必要です。                                                             |

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
- **キーワード抽出 (Keyword Extraction)**: これは、テキストから重要な単語やフレーズ（キーワード）を抽出するタスクです。
- **トピックモデリング (Topic Modeling)**: これは、大量の文書からトピック（主題）を抽出するタスクです。

1. 意図解析 (intent recognition): ユーザーが与えたテキストや発話から、その意図や要求を理解するタスクです。対話ボットや仮想アシスタントがユーザーの意図を把握するのに役立ちます。
2. テキスト生成 (text generation): 与えられた指示やコンテキストに基づいて、自動的に文章やテキストを生成するタスクです。文章生成、文章の要約、クリエイティブな文章生成などが含まれます。
3. 意味フレーム検出 (semantic frame detection): テキスト内の言葉やフレーズを特定の意味フレームに関連付けるタスクです。例えば、レストランのレビューから食べ物やサービスに関する情報を抽出する場合があります。
4. テキストクラスタリング (text clustering): 似たような特性を持つテキスト文書をグループ化するタスクです。文書の類似性に基づいて文書をクラスタリングします。
5. 対話生成 (dialogue generation): 対話型のシステムを構築し、ユーザーとの自然な対話を生成するタスクです。応答の生成だけでなく、流暢な対話の維持も含まれます。
6. テキストのエンティティリンキング (entity linking): テキスト内のエンティティ（人物、場所、組織など）を外部の知識ベースと関連付けるタスクです。例えば、"Apple"が果物の名前か企業名かを判別します。
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

## Hugging Face とは?

"🤗" (hugging face emoji) が由来。

[Hugging Face And Its Tryst With Success](https://analyticsindiamag.com/hugging-face-and-its-tryst-with-success/)

Hugging Face 社の社名の由来の絵文字 🤗、「笑いながら人を付き飛ばすサイコパス」に見えて怖い。
[hugging face emoji - Google Search](https://www.google.com/search?q=hugging+face+emoji&tbm=isch&source=lnms&hl=en)
