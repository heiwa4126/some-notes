# vLLM メモ

[Welcome to vLLM! — vLLM](https://docs.vllm.ai/en/latest/index.html)

## vLLM とは何?

よくわからないので GPT に Huggin Face と procon してもらったのを、とりあえずコピペしておく。

> vLLM(Virtual Large Language Model)は、大規模言語モデル (LLM) の高速推論を効率的に実現するためのオープンソースフレームワークです。
> 具体的には、**高速かつ大規模並列推論**を目指した設計が特徴です。この点をベースに、Hugging Face との比較を以下にまとめます。

自分で感じたのは

- 同じモデルを使っても Hugging Face (HF. TGI でない元々の)よりスループットが極端に良い。10 倍以上?
- 同じモデルを使っても GPU メモリ効率が良いらしい。
- 連続バッチ処理など動的バッチが凄いらしい(実感はない)。
- HF のモデルハブから読める。GGUF も読める。
- OpenAI API 互換インターフェースがある (これ便利)
- AWQ や GPTQ の量子化を指定してモデルが読めるので(HF でもできるけど)、巨大モデルがとりあえず動かせる。

など。

### 参考リンク

- [vLLM の仕組みをざっくりと理解する | データアナリティクスラボ](https://dalab.jp/archives/journal/vllm/)

### vLLM の特徴

1. **システム設計の強み: 高速推論**

   - 高速なトークン生成のために、ユニークなメモリ管理アルゴリズムである **PagedAttention** を採用。
   - メモリ効率が高く、VRAM (GPU メモリ) のオーバーヘッドを最小限に抑えながらパフォーマンスを向上。
   - 推論時のバッチ効率を向上させ、モデルの「サムスループット(全体的な処理能力)」を最大化。

2. **リアルタイムとオンデマンド生成**

   - **低レイテンシー**を重視し、Web アプリケーションやチャットボットの応答性を向上。

3. **大規模バッチ推論に適している**

   - 同時に多数のリクエストを処理できる点で、複数ユーザーへのスケーラビリティが高い。
   - 長文生成を得意とする。

4. **GPU を効率的に使用**
   - 推論のプロセスを最適化し、高性能モデルを少ないリソースで運用可能。

### Hugging Face の特徴

1. **豊富なモデルエコシステム**

   - 事前トレーニングされた幅広いモデル(GPT、T5、BERT など)を自由に使用可能。
   - [Transformers ライブラリ](https://huggingface.co/transformers/) によりモデルのロードが容易。

2. **柔軟な使用シナリオ**

   - 推論だけでなく、**トレーニング**や**ファインチューニング**にも対応。
   - Hugging Face Hub を通じて、モデルの共有とコミュニティの強力なサポート。

3. **シンプルな API**

   - プログラミング初心者から研究者まで幅広く使いやすい設計。
   - PyTorch や TensorFlow との強力な統合。

4. **推論速度はやや課題**
   - 高性能ですが、特別な最適化を行わないとリアルタイム性が低い場合もある。

### プロコン比較

| 特徴                   | **vLLM**                                                | **Hugging Face**                                 |
| ---------------------- | ------------------------------------------------------- | ------------------------------------------------ |
| **速度と効率性**       | 特化型。PagedAttention による高速推論でバッチ推論に強い | 高速だが、推論最適化には追加ツールや設定が必要   |
| **エコシステムの広さ** | 推論に特化しているためモデル選択は限られる              | 豊富なモデル選択とユースケースに対応             |
| **使いやすさ**         | 専門的。サーバーや大規模デプロイメント用途向け          | 高い。誰でも直感的に扱えるツール                 |
| **拡張性**             | リアルタイムスケーラビリティが高い                      | トレーニング・ファインチューニングにも柔軟に対応 |
| **GPU 効率**           | 高効率。単一 GPU で複数モデルを効率的に動かす           | 実装によるが、デフォルトでは非効率な場合がある   |

### どちらを選ぶべきか?

- **推論速度・スケーラビリティを重視**: 大規模アプリケーション向けであれば、vLLM。
- **柔軟性・モデルの選択肢を重視**: ファインチューニングや多様なモデルを試したい場合は Hugging Face。

用途に応じて、どちらを採用するか選ぶのがよいでしょう。また、Hugging Face のエコシステムをベースにしつつ、特定シナリオで vLLM を導入するという併用も有効です。

### まとめると

(Hugging Face と比較して)
vLLM は生成だけ、
そのかわり高速かつ低レイテンシで、
その上 GPU メモリ使用量が少ない。

## Docker で vllm serve

けっこう `pip install vllm` 時間かかるので
`vllm serve` でやるなら Docker のほうがいいかもしれない。

- [Deploying with Docker — vLLM](https://docs.vllm.ai/en/latest/serving/deploying_with_docker.html)
- [vllm/vllm-openai Tags | Docker Hub](https://hub.docker.com/r/vllm/vllm-openai/tags)
- [OpenAI Compatible Server — vLLM](https://docs.vllm.ai/en/latest/serving/openai_compatible_server.html?ref=blog.mozilla.ai)

欠点

- コンテナでかい。6GB ぐらい? この他にモデルも要る。
- NVIDIA Container Toolkit は要る。[Installing the NVIDIA Container Toolkit — NVIDIA Container Toolkit 1.17.0 documentation](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## `vllm serve --help` (vllm.entrypoints.openai.api_server)

でかいので別ファイルにしました。
[vllm serve --help](vllm-serve-help.txt)

公式は

- [Engine Arguments — vLLM](https://docs.vllm.ai/en/stable/usage/engine_args.html#engine-arguments)
- [Engine Arguments — vLLM](https://docs.vllm.ai/en/v0.5.0/models/engine_args.html) - 古い。vllm.entrypoints.openai.api_server のころのやつ
- [OpenAI Compatible Server — vLLM](https://docs.vllm.ai/en/stable/serving/openai_compatible_server.html)

## quantization に指定できるパラメータ

```text
--quantization/-q (choose from aqlm, awq, deepspeedfp, tpu_int8, fp8, fbgemm_fp8, modelopt, marlin, gguf, gptq_marlin_24, gptq_marlin, awq_marlin, gptq, compressed-tensors, bitsandbytes, qqq, hqq, experts_int8, neuron_quant, ipex, None)
```

あと `--quantization-param-path QUANTIZATION_PARAM_PATH` が必要。

## LLM サーバーフレームワーク (LLM serving frameworks)

vLLM や SGLang のようなソフトウェアは、一般的に
「LLM サーバーフレームワーク」または「LLM 推論フレームワーク」と呼ばれています。
他にも「LLM 推論サービング」、単に「LLM サーバー」「LLM フレームワーク」とも。
これらのフレームワークは、大規模言語モデル(LLM)の効率的な推論と展開を可能にするために設計されています。

モデルと推論エンジン(バックエンド)の組み合わせを簡単に切り替えられる。

### 主な特徴

- **高速推論**: これらのフレームワークは、LLM の推論速度を大幅に向上させることを目的としています。
- **メモリ効率**: 限られた GPU メモリでより大きなモデルを実行できるよう最適化されています。
- **スケーラビリティ**: 複数の GPU や分散システムでの効率的な実行をサポートしています。
- **柔軟性**: さまざまな LLM アーキテクチャやモデルサイズに対応できるよう設計されています。

## vLLM や SGLang 以外の代表的な LLM サーバーフレームワーク

- **LangChain**: LLM を組み込んだアプリケーション開発のための人気のあるフレームワークです。
- **LlamaIndex**: LangChain と同様に、LLM アプリケーション開発のための初期からあるフレームワークの一つです。
- **Haystack**: Retrieval-augmented generation (RAG) を利用した LLM アプリケーション開発に特化したフレームワークです。
- **AutoGen**: Microsoft が開発した、LLM に計画に基づいて必要なツールを実行させる"Agent"システムを開発するためのフレームワークです。
- **LangGraph**: LangChain の一部として、AutoGen と同様に Agent システムの開発に焦点を当てたフレームワークです。

これらのフレームワークは、それぞれ異なる特徴や用途に焦点を当てており、開発者は自身のプロジェクトの要件に応じて適切なフレームワークを選択することができます。

## もうすこし LLM サーバーフレームワーク (LLM Server Framework) の定義

LLM サーバーフレームワークは、
大規模言語モデル (Large Language Models; LLMs) を

- 効率的かつスケーラブルにデプロイ、
- サービング(提供)、
- および管理

するためのソフトウェアプラットフォームまたはライブラリを指します。

### **主な機能**

1. **モデルサービング**:

   - LLM をエンドポイントとして公開し、リクエストに応じて推論結果を返す。
   - REST API、gRPC、WebSocket などのインターフェースをサポート。

2. **スケーラビリティ**:

   - 複数のリクエストを同時に処理するためのバッチング機能。
   - 分散処理やマルチ GPU 環境に対応。

3. **効率化**:

   - 推論速度を向上させる技術(Lazy Loading、キャッシュ、量子化)。
   - GPU や CPU のリソースを最適に使用。

4. **簡易デプロイ**:

   - モデルの準備からサービングまでのプロセスを簡略化。
   - コンテナ化(Docker)やクラウドデプロイのサポート。

5. **モニタリングと管理**:

   - 使用状況のトラッキング、ログ管理、エラー検出。
   - サービングモデルのバージョン管理。

6. **拡張性**:
   - カスタム推論ロジックや、特定のユースケースに対応するための拡張機能をサポート。

### **代表的な LLM サーバーフレームワーク**

以下は「LLM サーバーフレームワーク」として注目されているツールの例です:

1. **vLLM**:

   - 高速な推論とリクエスト管理の最適化。
   - 複数リクエストを効率的に処理可能。

2. **Hugging Face Text Generation Inference**:

   - Hugging Face Transformers との深い統合。
   - 簡易なデプロイと管理機能を提供。

3. **DeepSpeed Inference**:

   - Microsoft が開発。大規模モデル向けの高速推論と最適化。推論だけでなく、学習(トレーニング)にも強力な機能を提供する。

4. **Ray Serve**:

   - 分散コンピューティングフレームワーク「Ray」の一部で、LLM サービングをサポート。

5. **SGLang**:

   - 軽量でリアルタイム推論に特化。

6. **FasterTransformer**:
   - NVIDIA が開発。GPU 最適化に特化した推論ライブラリ。

それぞれの範囲が微妙。もういちど。

まずモデル(LLM)。これはわかる。

有名推論エンジン(バックエンド)

- ONNX Runtime - ONNX フォーマットのモデルを推論する汎用エンジン。CPU、GPU、TPU など幅広いハードウェアをサポート。
- NVIDIA TensorRT - NVIDIA GPU 向けに最適化された高性能推論エンジン。モデルのコンパイルと最適化による高速化。
- FasterTransformer - NVIDIA が開発した、Transformer モデルに特化した推論ライブラリ。
- DeepSpeed Inference - Microsoft が開発した大規模言語モデル向け推論エンジン。DeepSpeed ライブラリの一部。
- PyTorch - PyTorch フレームワークの標準推論エンジン
- TensorFlow Serving - TensorFlow モデルをデプロイするための推論エンジン。
- OpenVINO - Intel が提供するエッジ向け推論エンジン。Intel CPU や iGPU での最適化。モデルの低レイテンシ推論。エッジデバイスや低リソース環境むけ
- JAX/XLA - Google が開発した数値計算ライブラリ「JAX」に基づいた推論エンジン。TPU での高速推論をサポート。TPU むけ
- Hugging Face Text Generation Inference - Hugging Face が開発した、特にテキスト生成に特化した推論エンジン。Transformers モデルの最適化。高速なテキスト生成。
- TVM (Apache TVM) - 深層学習コンパイラ。異なるハードウェア(CPU、GPU、FPGA)向けにコンパイル。
- Triton Inference Server - NVIDIA が開発した汎用的なモデルサービングエンジン。ONNX Runtime、TensorRT、PyTorch、TensorFlow などの複数エンジンを統合。
- Habana SynapseAI - Habana Labs(Intel の子会社)が提供する推論エンジン。Habana Gaudi アクセラレータ向け最適化。
- AWS Inferentia - AWS が提供する専用推論チップ(Inferentia)向けエンジン。Neuron SDK を利用したモデル最適化。

推論エンジンや LLM サーバーフレームワークからちょっとズレてるもの

Hugging Face Transformers (通称 HF)

モデルのライブラリおよびフレームワーク。
推論エンジンの上に抽象化されたフレームワーク、とも言える。

- 機能
  - モデル管理
  - API インターフェース
  - トレーニングと微調整
  - バックエンド連携
- バックエンドとして使えるもの
  - PyTorch:
  - TensorFlow:
  - ONNX Runtime:
  - TensorRT:
  - DeepSpeed Inference:
  - Accelerate:

llama.cpp

Meta の LLaMA(Large Language Model for AI)モデルを **CPU ベース で** 効率的に動作させるためのライブラリ。
モデルを実行するための効率的なコードを含むため、推論エンジンの一種と考えることができます。

Ollama

LLaMA モデルを含むさまざまな LLM をローカル環境で簡単に利用できるプラットフォーム。
内部で llama.cpp を使っているらしい。

- [How ollama uses llama.cpp : r/LocalLLaMA](https://www.reddit.com/r/LocalLLaMA/comments/1cjaybn/how_ollama_uses_llamacpp/)
- [Ollama がローカル LLM をどうやって呼び出しているのか](https://zenn.dev/laiso/articles/c1bc554b38228b)

NVIDIA TensorRT-LLM

TensorRT を LLM 用に強化したもの。
モデルコンパイラとエンジンとバックエンドのセット。
使うのが難しい...

## vLLM の量子化オプション

`-q`または `--quantization` でつかえるオプションは以下の通り

- aqlm
- awq
- deepspeedfp
- tpu_int8
- fp8
- fbgemm_fp8
- modelopt
- marlin
- gguf
- gptq_marlin_24
- gptq_marlin
- awq_marlin
- gptq
- compressed-tensors
- bitsandbytes
- qqq
- hqq
- experts_int8
- neuron_quant
- ipex
- None (量子化なし)

それぞれの簡単な説明:

1. AWQ (Activation-aware Weight Quantization)
   - 活性化値を考慮した重み量子化手法
   - 4-bit までの量子化を実現しながら、精度の低下を最小限に抑える
2. GPTQ (GPT Quantization)
   - 後量子化手法の 1 つで、訓練済みモデルを量子化
   - 4-bit 量子化でも高い精度を維持できる
3. GGUF (GPT-Generated Unified Format)
   - Llama や Mistral モデル用に最適化された形式
   - 様々なビット精度での量子化をサポート
4. BitsAndBytes
   - Hugging Face が提供する量子化ライブラリ
   - 4-bit、8-bit 量子化をサポート
   - QLoRA などの手法との相性が良い
5. FP8 / FBGEMM_FP8
   - 8-bit 浮動小数点形式での量子化
   - FBGEMM は Meta が開発した量子化ライブラリ
6. TPU_INT8
   - TPU 向けの 8-bit 整数量子化
   - Google Cloud TPU での実行に最適化
7. Marlin / GPTQ_Marlin / AWQ_Marlin
   - Marlin アクセラレータ向けに最適化された量子化手法
   - GPTQ や AWQ の手法をベースにしている
8. AQLM (Accurate Quantized Language Model)
   - より正確な量子化を目指した新しい手法
   - モデルの振る舞いを保持しながら効率的な量子化を実現
9. Neuron_Quant
   - AWS Neuron プロセッサ向けの量子化手法
   - AWS のインフラストラクチャに最適化
10. IPEX (Intel Extension for PyTorch)
    - Intel 製プロセッサ向けの最適化された量子化手法
11. Compressed-Tensors
    - テンソル圧縮による量子化手法
    - モデルサイズの削減を重視
12. DeepSpeedFP
    - DeepSpeed フレームワークによる浮動小数点量子化
13. ModelOpt
    - モデル最適化のための汎用的な量子化フレームワーク
14. QQQ / HQQ
    - 新しい世代の量子化手法
    - より高度な圧縮と精度のバランスを目指す
15. Experts_INT8
    - 専門家システムを用いた 8-bit 整数量子化
    - 特定のタスクに特化した最適化が可能

### Llama3 の 70B モデルを A10G(24GB)\*4 で

Llama 70B の場合、おおよそ以下のメモリが必要

- BF16/FP16: 約 140GB
- 8-bit: 約 70GB
- 4-bit: 約 35GB

4bit しかなさそう...

awq か gptq を試してみる。
