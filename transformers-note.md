# Transformers のメモ

Hugging Face 🤗 の。
LLM のノートに書いてたのがだんだん大きくなりすぎたので分ける。

- [Hugging Face のモデルのキャッシュを消す方法 (とリストする方法)](#hugging-face-のモデルのキャッシュを消す方法-とリストする方法)
  - [キャッシュに関する古い情報](#キャッシュに関する古い情報)
- [accelerate](#accelerate)
- [モデル、 アーキテクチャ、チェックポイント](#モデル-アーキテクチャチェックポイント)
- [pipeline() の task にかけるもの](#pipeline-の-task-にかけるもの)
- [PEFT](#peft)
- [Trainer の compute_metrics](#trainer-の-compute_metrics)
- [accuracy](#accuracy)
- [F1 スコア (F 値, F-measure)](#f1-スコア-f-値-f-measure)
- [Trainer の 損失関数(loss function)](#trainer-の-損失関数loss-function)
- [fine-tuning がうまくいかないときメモ](#fine-tuning-がうまくいかないときメモ)
- [TensorBoard の薄いグラフ](#tensorboard-の薄いグラフ)
- [Terraformres で使う TensorBoard メモ](#terraformres-で使う-tensorboard-メモ)
- [タスク](#タスク)
- [認証が必要なモデル](#認証が必要なモデル)
- [chat template](#chat-template)
  - [モデルの Hugging Face ページを確認する](#モデルの-hugging-face-ページを確認する)
  - [トークナイザーのデフォルトテンプレートを確認](#トークナイザーのデフォルトテンプレートを確認)
  - [モデルファミリーのドキュメントを確認](#モデルファミリーのドキュメントを確認)
  - [モデル開発者の GitHub リポジトリを確認](#モデル開発者の-github-リポジトリを確認)
  - [モデルの開発者やコミュニティに問い合わせる](#モデルの開発者やコミュニティに問い合わせる)
- [chat template によって chat の input として生成される token のイメージ](#chat-template-によって-chat-の-input-として生成される-token-のイメージ)
- [chat template の例](#chat-template-の例)
- [vLLM OpenAI Compatible Server の chat template](#vllm-openai-compatible-server-の-chat-template)

## Hugging Face のモデルのキャッシュを消す方法 (とリストする方法)

```bash
pip install huggingface_hub[cli]
huggingface-cli scan-cache  # キャッシュ済みのモデルを列挙する
```

のようにマネージメントするのが正しいっぽい。

キャッシュの削除は `huggingface-cli delete-cache` で TUI で出来る。( `--disable-tui` オプションあり)

例:

```console
$ huggingface-cli delete-cache

? Select revisions to delete: 0 revisions selected counting for 0.0.
  ○ None of the following (if selected, nothing will be deleted).

Model microsoft/Phi-3-mini-4k-instruct (15.3G, used 2 days ago)
❯ ○ 5fa34190: (detached) # modified 7 months ago
  ○ d269012b: (detached) # modified 7 months ago
  ○ ff07dc01: (detached) # modified 6 months ago
  ○ 0a67737c: main # modified 2 days ago
```

こんな感じになるので、上下キーと、スペースで選んで、リターンキーで決定。
`(detached)` のはプロジェクトで明示的に使ってなければ消してもいい。

参考リンク:

- [Clean your cache](https://huggingface.co/docs/huggingface_hub/guides/manage-cache#clean-your-cache)
- [Using TUI - Manage \`huggingface_hub\` cache-system](https://huggingface.co/docs/huggingface_hub/guides/manage-cache#using-the-tui)
- [huggingface-hub · PyPI](https://pypi.org/project/huggingface-hub/)

### キャッシュに関する古い情報

検索すると
キャッシュディレクトリは

- macOS または Linux の場合: ~/.cache/huggingface
- Windows の場合: %APPDATA%/huggingface

で、変更は TRANSFORMERS_CACHE 環境変数で、

ぐらいのことはすぐ出てくるのですが、正式なドキュメントが見つからない。

- [Manage \`huggingface_hub\` cache-system](https://huggingface.co/docs/huggingface_hub/main/guides/manage-cache)
- [Cache management](https://huggingface.co/docs/datasets/cache) - データセット(datasets)の方

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

## pipeline() の task にかけるもの

```python
['audio-classification', 'automatic-speech-recognition', 'conversational', 'depth-estimation', 'document-question-answering', 'feature-extraction', 'fill-mask', 'image-classification', 'image-segmentation', 'image-to-image', 'image-to-text', 'mask-generation', 'ner', 'object-detection', 'question-answering', 'sentiment-analysis', 'summarization', 'table-question-answering', 'text-classification', 'text-generation', 'text-to-audio', 'text-to-speech', 'text2text-generation', 'token-classification', 'translation', 'video-classification', 'visual-question-answering', 'vqa', 'zero-shot-audio-classification', 'zero-shot-classification', 'zero-shot-image-classification', 'zero-shot-object-detection', 'translation_XX_to_YY']"
```

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

## Trainer の compute_metrics

[Trainer](https://huggingface.co/docs/transformers/main_classes/trainer)

compute_metrics()関数は、Trainer の 1 エポック終了後に呼び出されます
(ストラテジによって変わる。後述)。

具体的には以下のタイミングで呼ばれます:

- 訓練時の各エポック終了後に、訓練データで evaluate()が呼ばれ、そこで compute_metrics()が呼び出される
- 評価用データで evaluate()が呼ばれたときに、compute_metrics()が呼び出される

訓練途中で評価したい場合は、Trainer の args に evaluation_strategy='steps'などを指定することで、
所定のステップごとに evaluate()し、compute_metrics()を呼び出すこともできます。

**compute_metrics()の戻り値はあくまで中間評価のためで、fine-tuning 自体には影響しない。**

- [compute_metrics](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.Trainer.compute_metrics)
- [huggingface/transformers の Trainer の使い方と挙動 #bert - Qiita](https://qiita.com/nipo/items/44ce3aaf6acd4e2649d1#compute_metrics)

## accuracy

`accuracy = (予測が正解だったサンプル数) / (全サンプル数)`

例えば、100 個のサンプルに対してモデルが 80 個正解で 20 個不正解だった場合、accuracy は 80/100=0.8=80%となります。

accuracy は 0 から 1 の間の値をとり、1 に近いほどモデルの性能が高いことを示します。

分類タスクでは、accuracy がもっとも基本的で重要な評価指標の 1 つとして、広く使用されています。

[Accuracy - a Hugging Face Space by evaluate-metric](https://huggingface.co/spaces/evaluate-metric/accuracy)

## F1 スコア (F 値, F-measure)

accuracy はクラス不均衡データに対して脆弱なため、F1 スコア等の指標と合わせて使用することが多いです。

クラス不均衡データとは:
あるクラスのデータ数が他のクラスに比べて極端に少ないデータセットのことです。
例えば、100 個のデータの内、90 個が「クラス A」、10 個が「クラス B」であるようなデータセットは、クラス不均衡が発生しています。

この場合、単純に accuracy を計算すると、
全てのサンプルを「クラス A」と予測するモデルでも 90%の高い accuracy が出てしまいます。

F1 スコアは、
適合率(Precision, Positive predict value,PPV) と
再現率(Recall)(=感度(Sensitivity)) の
調和平均です。

- [F 値 (評価指標) - Wikipedia](<https://ja.wikipedia.org/wiki/F%E5%80%A4_(%E8%A9%95%E4%BE%A1%E6%8C%87%E6%A8%99)>)
- [感度とか特異度とか | Tech Blog | CRESCO Tech Blog](https://www.cresco.co.jp/blog/entry/5987.html)
- [F1 - a Hugging Face Space by evaluate-metric](https://huggingface.co/spaces/evaluate-metric/f1)

## Trainer の 損失関数(loss function)

compute_loss で指定するんだけど、デフォルトは None.

None だと、モデルの設定に基づいて自動的に設定されます。
分類タスクの場合、BertForSequenceClassification を使用すると、
クロスエントロピー損失(交差エントロピー)がデフォルトで設定されます。

[損失関数とは?ニューラルネットワークの学習理論【機械学習】 – 株式会社ライトコード](https://rightcode.co.jp/blog/information-technology/loss-function-neural-network-learning-theory)

## fine-tuning がうまくいかないときメモ

trainer.train()のログで、loss がどんどん増えて 1 より大きくなる現象。
当然まともなモデルにならない。

```log
{'loss': 0.7373, 'learning_rate': 0.00010506666666666667, 'epoch': 0.16}
{'loss': 0.7517, 'learning_rate': 0.00015840000000000003, 'epoch': 0.24}
{'loss': 0.8197, 'learning_rate': 0.0001986962962962963, 'epoch': 0.32}
{'loss': 0.8381, 'learning_rate': 0.00019277037037037037, 'epoch': 0.4}
{'loss': 0.8572, 'learning_rate': 0.00018684444444444444, 'epoch': 0.48}
{'loss': 1.1329, 'learning_rate': 0.00018097777777777778, 'epoch': 0.56}
{'loss': 1.1242, 'learning_rate': 0.00017505185185185188, 'epoch': 0.64}
{'loss': 1.1402, 'learning_rate': 0.00016912592592592594, 'epoch': 0.72}
{'loss': 1.1246, 'learning_rate': 0.0001632, 'epoch': 0.8}
```

ChatGTP に聞いたらわりと親切な答えが来たのでメモしておく。

> Hugging Face の trainer.train()が
> {'loss': 1.1118, 'learning_rate': 5.6533333333333336e-05, 'epoch': 2.24}
> のようなログを表示します。これの意味を説明してください。

1. **'loss'**: この値はトレーニング中の損失(loss)を示しています。損失は、モデルが予測した出力と実際の正解との差を示す指標で、最小化されるべき目標です。トレーニングが進むにつれて、この損失が減少することが期待されます。
2. **'learning_rate'**: トレーニング中の学習率(learning rate)を示しています。学習率は、モデルのパラメータを更新する際に使用されるステップの大きさを制御する重要なハイパーパラメータです。トレーニングが進むにつれて、学習率が変化することが一般的です。
3. **'epoch'**: これは現在のエポック数を示しています。エポックは、トレーニングデータセット全体を一度完了する過程です。例えば、'epoch': 2.24 は、2 エポックのトレーニングがほぼ完了し、現在のエポックが 2.24 であることを示しています。

これらのログはトレーニング中の進捗をモニタリングするために使用され、特にモデルの性能向上や学習率の調整などの際に役立ちます。

> Hugging Face の trainer.train()がデフォルトで使う損失関数は?

デフォルトで cross entropy loss を損失関数として使用します。

> cross entropy loss 関数の結果が 1 を超えることがありますか?

交差エントロピー損失(cross entropy loss)の結果が 1 を超えることは原理的にありません。

...だよねえ。

> train 中に loss がどんどん増えて 1 を超えてしまいました。これは何が原因でしょう?

学習中に損失関数の値が増加し、1 を超えてしまう原因としては以下のような可能性が考えられます。

- オーバーフィッティング : モデルが学習データに過剰にフィットし始め、汎化性能が低下している。
- データの問題 : 学習データにノイズが多い、アンバランスなデータ分布などでモデルがうまく学習できていない。
- ハイパーパラメータの問題 : 学習率が大きすぎる、エポック数が多すぎるなどのパラメータ設定の誤り。
- バッチサイズの問題 : バッチサイズが小さすぎると損失の変動が大きくなる。
- 勾配爆発 : 勾配が発散し数値的に大きな値を取ってしまう問題。
- バグ : 損失計算にバグがある可能性。

対処としては、学習曲線から原因を特定し、ハイパーパラメータチューニング、正則化、データ前処理などを試してみる必要があるでしょう。1 を大きく超えるようであればバグの可能性も考えられます。

`learning_rate=2e-5` を `2e-4` にしてみた。

```log
{'loss': 0.8198, 'learning_rate': 1.0613333333333334e-05, 'epoch': 0.16}
{'loss': 0.6289, 'learning_rate': 1.5893333333333333e-05, 'epoch': 0.24}
{'loss': 0.5952, 'learning_rate': 1.9863703703703706e-05, 'epoch': 0.32}
{'loss': 0.5745, 'learning_rate': 1.9277037037037037e-05, 'epoch': 0.4}
{'loss': 0.5417, 'learning_rate': 1.8684444444444446e-05, 'epoch': 0.48}
{'loss': 0.5498, 'learning_rate': 1.8097777777777777e-05, 'epoch': 0.56}
{'loss': 0.5138, 'learning_rate': 1.7505185185185186e-05, 'epoch': 0.64}
{'loss': 0.5461, 'learning_rate': 1.6912592592592594e-05, 'epoch': 0.72}
{'loss': 0.533, 'learning_rate': 1.632e-05, 'epoch': 0.8}
```

順調に学習しはじめた。よかったよかった。

## TensorBoard の薄いグラフ

train のグラフなどで

- 薄い線: 実際の値
- 濃い線: TensorBoard がスムージングかけた値

だそうです。

## Terraformres で使う TensorBoard メモ

- `pip install tensorboard` してある
- かつ TrainingArguments で `logging_dir=` が指定されてる

と、`logging_dir=` で指定したディレクトリにログが保存される。

VSCode だと学習中に自動で上がる。
またはコマンドパレットで `Launch TensorBorad`

手動では

```sh
tensorboard --logdir ./logs
```

どっちも VSCode からだとポート転送してくれるので、リモートホストでも手元で見れる。

複数のグラフが同時に表示できるのだけれど、
logdir で指定したディレクトリ以下のディレクトリ単位で、
そのディレクトリで一番新しいログが表示される仕掛けになっている
(うまく説明できない)。

自動では更新されないみたい。右上の reload アイコンをクリック。
30 秒ごとに自動更新される、という話もあるけど、更新されなかった(何か条件がある?)

## タスク

Huggung Face Hub の model の Natural Language Processing(NLP) のタスクをざっくり解説

- Text Classification: テキストをカテゴリに分類するタスク。例えば、感情分析やスパム検出など。
- Token Classification: 文中のトークン(単語)にラベルを付けるタスク。例えば、固有表現抽出や構文解析など。
- Table Question Answering: テーブル形式のデータから質問に答えるタスク。
- Question Answering: 自然言語の質問に対して適切に回答するタスク。
- Zero-Shot Classification: 学習データがない新しいカテゴリの分類。転移学習が用いられる。
- Translation: 一言語から別の言語への翻訳タスク。
- Summarization: 長文のテキストを要約するタスク。
- Conversational: 会話的なやり取りができる対話システムの構築。
- Text Generation: 条件に基づき文章を自動生成するタスク。
- Text2Text Generation: テキスト入力からテキスト出力を生成するタスク。
- Fill-Mask: マスクされた単語を予測して埋めるタスク。BERT のプリトレーニングなどに用いられる。
- Sentence Similarity: 2 つの文の意味的な類似度を計算するタスク。

意味がよくわからんものが...

## 認証が必要なモデル

[stabilityai/japanese-stablelm-2-base-1_6b · Hugging Face](https://huggingface.co/stabilityai/japanese-stablelm-2-base-1_6b)
が

"You need to agree to share your contact information to access this model."
というやつだったので、

1. ログインする
2. 上記に従ってコンタクト情報入れる
3. [Hugging Face – The AI community building the future.](https://huggingface.co/settings/tokens) で token 1 つ作る。権限は Read で十分。
4. トークンをコードに渡すにはいろんな方法があるけど、JSON に書くことにした。

`huggingface_token.json`

```json
{
  "HUGGINGFACE_TOKEN": "your_huggingface_api_token"
}
```

で、こんな感じに使う。

```python
import json

import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

# JSONファイルからトークンを読み込む
with open("huggingface_token.json") as f:
    token_data = json.load(f)

token = token_data["HUGGINGFACE_TOKEN"]

# アクセストークンを使ってモデルを読み込む
model_name = "stabilityai/japanese-stablelm-2-base-1_6b"
tokenizer = AutoTokenizer.from_pretrained(
    model_name, token=token, trust_remote_code=True
)
model = AutoModelForCausalLM.from_pretrained(
    model_name,
    torch_dtype=torch.float16,
    low_cpu_mem_usage=True,
    device_map="auto",
    trust_remote_code=True,
    token=token,
)
## あとは https://huggingface.co/stabilityai/japanese-stablelm-2-base-1_6b を参照
```

`trust_remote_code`については以下参照

- [AutoTokenizer で chiTra トークナイザを読み込む #transformers - Qiita](https://qiita.com/mh-northlander/items/0b543edfec2e341bd4a0)
- [Using a model with custom code](https://huggingface.co/docs/transformers/main/en/custom_models#using-a-model-with-custom-code)

## chat template

モデルごとに違うんだけど... どうやって知ったらいい?

参考:

- [Chat Templates](https://huggingface.co/docs/transformers/main/en/chat_templating)
- [Chat Templates(日本語)](https://huggingface.co/docs/transformers/ja/chat_templating)
- [HuggingFace Transformers の チャットモデルテンプレート を試す｜ npaka](https://note.com/npaka/n/nf5d78c00b3df)
- [LLM のチャットテンプレート | LLM Japan](https://www.llmjapan.com/blog/chat_template/)

### モデルの Hugging Face ページを確認する

- モデルの Hugging Face ページで「Files and versions」タブを確認
- `tokenizer_config.json`や`config.json`内に`chat_template`の定義があることがあります
- また、モデルの README にも記載されていることがあります

### トークナイザーのデフォルトテンプレートを確認

直接トークナイザーから確認できることがあります。

```python
from transformers import AutoTokenizer

tokenizer = AutoTokenizer.from_pretrained("モデル名")
if hasattr(tokenizer, "chat_template"):
    print(tokenizer.chat_template)
```

### モデルファミリーのドキュメントを確認

- Llama 系: `<s>[INST] {prompt} [/INST]`
- Mistral 系: `<s>[INST] {prompt} [/INST]`
- Falcon 系: `User: {prompt}\nAssistant:`

など、モデルファミリーごとに標準的なテンプレートがあります

### モデル開発者の GitHub リポジトリを確認

- トレーニングスクリプトや例示コードにテンプレートが記載されていることがあります。
- issues や discussions でも議論されていることがあります。

### モデルの開発者やコミュニティに問い合わせる

例:
[tokyotech-llm/Swallow-7b-instruct-hf · tokenizer.chat_template](https://huggingface.co/tokyotech-llm/Swallow-7b-instruct-hf/discussions/2)

例 2:
[llama2:7b-chat/template](https://ollama.com/library/llama2:7b-chat/blobs/2e0493f67d0c)

Ollama のテンプレートは Jinja2 でなく独自形式。
<https://github.com/ollama/ollama/blob/main/docs/modelfile.md#template>

## chat template によって chat の input として生成される token のイメージ

Llama の場合こんなノリになるらしい。

```text
<s>[SYSTEM] You are a helpful assistant who provides clear and concise answers. Be polite and informative. [/SYSTEM]
<s>[INST] What is the capital of France? [/INST] Paris
<s>[INST] Who wrote '1984'? [/INST] George Orwell
```

改行が必要かはよくわからない。

[Chat Templates](https://huggingface.co/docs/transformers/main/en/chat_templating)
の
`tokenizer.apply_chat_template()`
のコード参照。

## chat template の例

[microsoft/Phi-3-mini-4k-instruct](https://huggingface.co/microsoft/Phi-3-mini-4k-instruct)

テンプレートは以下の通り (Jinja2):

```jinja
{% for message in messages %}{% if message['role'] == 'system' %}{{'<|system|>
' + message['content'] + '<|end|>
'}}{% elif message['role'] == 'user' %}{{'<|user|>
' + message['content'] + '<|end|>
'}}{% elif message['role'] == 'assistant' %}{{'<|assistant|>
' + message['content'] + '<|end|>
'}}{% endif %}{% endfor %}{% if add_generation_prompt %}{{ '<|assistant|>
' }}{% else %}{{ eos_token }}{% endif %}
```

で、サンプルは

```text
<|system|>
You are a helpful assistant who provides clear and concise answers. Be polite and informative.<|end|>
<|user|>
Hello, how are you?<|end|>
<|assistant|>
I'm doing great. How can I help you today?<|end|>
<|user|>
I'd like to show off how chat templating works!<|end|>
<|endoftext|>
```

## vLLM OpenAI Compatible Server の chat template

[OpenAI Compatible Server の Chat Template のところ — vLLM](https://docs.vllm.ai/en/v0.4.1/serving/openai_compatible_server.html#chat-template)

`vllm serve --chat-template` や
`python -m vllm.entrypoints.openai.api_server --chat-template` や
`from vllm.entrypoints.openai.api_server import run_server` の引数 `from vllm.engine.arg_utils import AsyncEngineArgs` の `chat_template` で分類の場合は
Jinja2 形式で chat テンプレートを与えられるようになってるらしい。

`--chat-template` オプションではファイルも可。`./foo.jinja` や `/foo/bar.jinja` で。

有名モデルの chat テンプレートは以下にサンプルがある
<https://github.com/vllm-project/vllm/tree/main/examples/>
んだけど、なんか異常にややこしくない?
