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
