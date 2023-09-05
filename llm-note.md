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

とかそういうやつだ。修正していく。

事前学習済み言語モデル (pre-trained language model; PLM)
