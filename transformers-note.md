# Transformers のメモ

Hugging Face 🤗 の。
LLM のノートに書いてたのがだんだん大きくなりすぎたので分ける。

## accelerate

便利。PyTorch 専用?

- [accelerate · PyPI](https://pypi.org/project/accelerate/) - このサンプルが
- [Using pipeline on large models with 🤗 accelerate:](https://huggingface.co/docs/transformers/pipeline_tutorial#using-pipeline-on-large-models-with-accelerate) - こっちのサンプルも

## モデル、 アーキテクチャ、チェックポイント

[Load pretrained instances with an AutoClass](https://huggingface.co/docs/transformers/autoclass_tutorial)

アーキテクチャとはモデルの骨格のことであり、
チェックポイントとは与えられたアーキテクチャに対する重みのことである。

例えば、BERT はアーキテクチャであり、
bert-base-uncased はチェックポイントである。

モデルは、アーキテクチャまたはチェックポイントのどちらかを意味する一般的な用語である。
