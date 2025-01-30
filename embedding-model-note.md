# 埋め込みモデルメモ

## 埋め込みの基本

- 与えられた情報を高次元空間の 1 点に変換する
- 互いに似た情報は距離が近い点になる

「高次元空間の 1 点」というのは
要するに [1.1, 2.2, ...] みたいなやつで、float の配列

## テキスト埋め込みモデル

文字列を高次元空間の 1 点に変換してくれる LLM

長いテキストでも短いテキストでも
同じ空間に埋め込まれるのだから、
配列の長さは同じになる。

## 有名テキスト埋め込みモデル

### text-embedding-ada-002 (OpenAI)

- **最大トークン数**: 8192 トークン
- **次元数**: 1536 次元

### embedding-gecko-001 (Google)

- **最大トークン数**: 2048 トークン(ただし、特定の条件下で異なる場合もあり)
- **次元数**: 768 次元

## Dense, Sparse, Multi-Vector

よくわからん

| **特徴**         | **Dense**              | **Sparse**             | **Multi-Vector**                         |
| ---------------- | ---------------------- | ---------------------- | ---------------------------------------- |
| **次元数**       | 中程度 (例: 128, 768)  | 高い (数千~数百万次元) | 中程度 (1 つあたり 128 ~ 768 次元を複数) |
| **スパース性**   | なし                   | 高い                   | 中~低                                    |
| **メモリ使用量** | 小さい                 | 最適化が必要           | 中程度                                   |
| **用途**         | 意味ベースの検索や分類 | 古典的な TF-IDF 検索   | 高度な検索・多様なファセット             |

- **Dense**:
  - 意味の類似性を基準とした検索や分類。
  - ディープラーニングの埋め込みモデルで一般的。
- **Sparse**:
  - 高速なフルテキスト検索や TF-IDF ベースのクラシック検索。
  - ドメインに特化した単語頻度やルールベースモデルが有効な場合。
- **Multi-Vector**:
  - 検索時の多様な観点やクエリの複雑な表現が必要な場合。
  - 文書が多面的であり、単一の表現では不十分な場合。

## BAAI/bge-m3

- [BAAI/bge-m3 · Hugging Face](https://huggingface.co/BAAI/bge-m3)
- [FlagEmbedding/research/BGE_M3 at master · FlagOpen/FlagEmbedding](https://github.com/FlagOpen/FlagEmbedding/tree/master/research/BGE_M3)

Beijing Academy of Artificial Intelligence (BAAI) - 北京智源人工智能研究院

よくわからんがいろいろすごいらしい。
[複数の関連度から検索可能な BGE M3-Embedding の紹介 - Algomatic Tech Blog](https://tech.algomatic.jp/entry/papers/retrieval/chen-24-bgem3)
の論文紹介のところ。

サンプルコード
<https://github.com/FlagOpen/FlagEmbedding/tree/master/research/BGE_M3#usage>

いろいろあるけど vLLM でも動くらしい。
[[New Model]: BAAI/bge-m3 · Issue #9847 · vllm-project/vllm](https://github.com/vllm-project/vllm/issues/9847)

- **最大トークン数**: 8192 トークン
- **次元数**: 1024 次元 (Dense ベクトルの場合)

ディスク上では 4.6G (PyTorch と ONNX あわせて)。
GPU メモリもあんまり食わない。

## RAG 的には

まず
「クエリ(質問文)」
と
「参考情報の元テキストとメタデータ(とベクトル)の入ったベクトルストア」
があるとする。

1. ベクトルストアにはベクトルと元テキストとメタデータがストアされている
2. クエリに近似した元テキストをベクトルストアから取り出す
3. プロンプトとして近似テキストとクエリを LLM に与えて推論させる

1,2 は 普通の検索エンジンでもできるような気が...
ベクトル検索には「意味的な類似性検索が可能」という利点がある。
