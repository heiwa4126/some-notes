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
