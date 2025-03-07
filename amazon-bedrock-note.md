# Amazon Bedrock メモ

> Amazon Bedrock は、基礎モデル(foundation models; FMs)でジェネレーティブ AI アプリケーションを構築し、拡張する最も簡単な方法です。Amazon Bedrock を使用して、ユースケースのビジネスソリューションを作成する方法を学びましょう。

[Amazon Bedrock Demo](https://aistylist.awsplayer.com/) の冒頭から引用

## bedrock の意味・使い方・読み方

[bedrock の意味・使い方・読み方|英辞郎 on the WEB](https://eow.alc.co.jp/search?q=bedrock)

名詞

1. 《地学》岩盤、基盤岩 ◆【同】substratum
2. 基盤、根底、根幹、根本(原理)、基礎的事実
3. 〔困難や不幸の〕どん底

## 学習のとっかかり

- [AI Stylist - Amazon Bedrock Demo](https://aistylist.awsplayer.com/) - デモ。おすすめ
- [examples (AWS ポータル上の例)](https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/examples) - いい感じ。金はすごくかかりそう...
- [Hands-on lab](https://github.com/aws-samples/amazon-bedrock-aistylist-lab) - 上記 AI Stylist のソースを使ったハンズオン。 Jupyter Notebook 使用
- [AWS Skill Builder - Amazon Bedrock Getting Started (Japanese) (Sub) 日本語字幕版](https://explore.skillbuilder.aws/learn/course/internal/view/elearning/18290/amazon-bedrock-getting-started-japanese-sub-ri-ben-yu-zi-mu-ban) - 簡単なコース。無料で 30 分以下で終わる。
- [Amazon Bedrock の料金表](https://aws.amazon.com/jp/bedrock/pricing/)
- [Amazon Bedrock の使えるリージョン](https://docs.aws.amazon.com/bedrock/latest/userguide/bedrock-regions.html)
- [Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/latest/userguide/what-is-bedrock.html)
- [Amazon Bedrock をすぐに触れる Playground を試してみる:Chat 編 #AdventCalendar2023 - Qiita](https://qiita.com/akiraokusawa/items/9e586ee8990017f6040c)

### playground

まずモデルを使えるようにする。Bedrock ポータルの変なところにリンクがある。
[Amazon Bedrock - Model access | us-east-1](https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess)

## AI Stylist の冒頭部分翻訳

[AI Stylist - Amazon Bedrock Demo](https://aistylist.awsplayer.com/)

こんにちは、このデモにようこそ!

AI Stylist は、お客様のための新しいショッピング体験です。Amazon Bedrock の機能がどのように組み合わされて AI Stylist を機能させているのかを探ってみましょう。このデモでは、Amazon Bedrock が舞台裏で何をしているのかをお見せするために、お客様からのプロンプトをいくつか確認し、ツールチップを指摘します。また、以下の機能についても深く掘り下げていきます:

Customer prompts

カスタマー・プロンプトとは、Amazon Bedrock のファウンデーション・モデル(FM)が与えられたタスクや指示に対して適切なレスポンスやアウトプットを生成するように導く、顧客によって提供される特定の入力のセットです。

Knowledge bases

ナレッジ・ベースは、組織のプライベート・データ・ソースを基盤モデル(FM)に接続し、生成 AI アプリケーションで検索拡張生成を可能にすることで、より適切で文脈に沿った応答を提供します。

Agents

エージェントは、簡単な自然言語の指示を使用して、協調的な問題解決アシスタントを構築することができます。エージェントは、ユーザーの要求を満たすために、会社のシステムやデータソースに動的に API コールを行うことで、タスクを計画し実行することができます。

AI スタイリスト: こんにちは、あなたのパーソナル・スタイリストです。あなたが心地よく、自信を持てる服を見つけましょう!何をお探しですか?

カスタマー: 来週ニューヨークに出張するコンサルタントです。初日はどんな服装で行けばいいでしょうか?

ルックスを生成する

AI スタイリストは、エージェントを使って顧客と対話します。顧客からのプロンプト、ファッショントレンドと商品カタログの知識ベースをミックスして、商品カタログエージェントは、服装を生成するための基礎モデルのプロンプトを作成します。商品カタログエージェントは、ファッショントレンド知識ベースから情報を抽出し、この情報を画像生成エージェントに送信して、関連する衣装の画像を生成します。

この次と次の図がいいかんじ

## 「統一のインターフェス」とはいうけれど

API のパラメータがモデルごとにまるで違う。

例:

- [Amazon Titan text models - Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-titan-text.html#inference-titan-code)
- [AI21 Labs Jurassic-2 models - Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/model-parameters-jurassic2.html#api-inference-examples-a2i-jurassic)

## クロスリージョン推論プロファイル(cross-region inference profiles)とは

- [クロスリージョン推論によるスループットの向上 - Amazon Bedrock](https://docs.aws.amazon.com/ja_jp/bedrock/latest/userguide/cross-region-inference.html?utm_source=chatgpt.com)
- [推論プロファイルでサポートされているリージョンとモデル - Amazon Bedrock](https://docs.aws.amazon.com/ja_jp/bedrock/latest/userguide/inference-profiles-support.html)

複数の AWS リージョンにまたがってモデル推論リクエストをルーティングするための事前定義されたプロファイルです。
これにより、異なるリージョンのコンピューティングリソースを活用して、予期しないトラフィックの急増をシームレスに管理し、スループットとパフォーマンスを向上させることが可能となります。

各クロスリージョン推論プロファイルは、サポートするモデルとリージョンに基づいて命名されています。例えば、「US Anthropic Claude 3 Sonnet」というプロファイルは、米国東部(バージニア北部)リージョン(us-east-1)および米国西部(オレゴン)リージョン(us-west-2)で Anthropic Claude 3 Sonnet モデルをサポートしています。

ID は `us.anthropic.claude-3-sonnet-20240229-v1:0`。

これらのプロファイルを使用することで、トラフィックを複数のリージョンに分散し、スループットを向上させることができます。

## Amazon Nova Lite

Nova Lite
安いので使ってみようと思ったんだけど、東京リージョンでアクセス有効にすると

> botocore.errorfactory.ValidationException: An error occurred (ValidationException) when calling the Converse operation: Invocation of model ID amazon.nova-lite-v1:0 with on-demand throughput isn’t supported. Retry your request with the ID or ARN of an inference profile that contains this model.

とか言われて動きもはん。

- リージョンは us-east-1(か us-east-2 か us-west-2)
- アクセス有効も us-east-1(か us-east-2 か us-west-2) で。 URL: <https://us-east-1.console.aws.amazon.com/bedrock/home?region=us-east-1#/modelaccess>
- ID は "amazon.nova-lite-v1:0" よりは "us.amazon.nova-lite-v1:0" (クロスリージョン) のほうが早いはず。

で動作しました。

真のクロスリージョンにするためには us-east-2 と us-west-2 全部でアクセス有効にする必要があるかもしれない(不明)。

### その後

[Supported Regions and models for inference profiles - Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/inference-profiles-support.html) で "APAC Nova Lite" が更新されて

東京リージョンなら

> ID: "apac.amazon.nova-lite-v1:0"

のように地域プレフィックスつきで行けました。

Amazon Nova はクロスリージョンでしか動作しない、ってこと?
それは変だなあ。

いいかえると
「東京リージョンでオンデマンドスループットを利用する際は、クロスリージョンの inference profile（apac プレフィックス）を使用する必要がある」
かもしれないらしいかも。

なんとなく AWS の誰かが設定間違ってるだけのような気がする...

間違っていませんでした。
[Model support by AWS Region in Amazon Bedrock - Amazon Bedrock](https://docs.aws.amazon.com/bedrock/latest/userguide/models-regions.html)

上記によると特定のリージョン(オレンジの △ の中に!マーク Yes\*)ではクロスリージョンでしか動作しない。

## Amazon Nova Lite vs GPT-4o mini (2025-03)

### モデル仕様と価格

| 項目                 | Amazon Nova Lite                  | GPT-4o-mini                       |
| -------------------- | --------------------------------- | --------------------------------- |
| **入力コンテキスト** | 300K トークン                     | 128K トークン                     |
| **最大出力トークン** | 5K トークン                       | 16.4K トークン                    |
| **リリース日**       | 2024 年 12 月 2 日（約 3 ヶ月前） | 2024 年 7 月 18 日（約 7 ヶ月前） |
| **知識更新日**       | 非公開                            | 2023 年 10 月                     |
| **価格 (入力)**      | $0.06/百万トークン                | $0.15/百万トークン                |
| **価格 (出力)**      | $0.24/百万トークン                | $0.60/百万トークン                |
| **マルチモーダル**   | マルチモーダル対応                | テキスト専用                      |

### ベンチマーク比較

| ベンチマーク  | Amazon Nova Lite         | GPT-4o-mini    |
| ------------- | ------------------------ | -------------- |
| **MMLU**      | 80.5% (Chain-of-Thought) | 82% (5-shot)   |
| **HumanEval** | 85.4% (0-shot, pass@1)   | 87.2% (0-shot) |
| **MATH**      | 73.3% (Chain-of-Thought) | 70.2% (0-shot) |

- [GPT-4o mini vs Nova Lite](https://llm-stats.com/models/compare/gpt-4o-mini-2024-07-18-vs-nova-lite)
- [Amazon Nova Lite vs GPT-4o Mini - Detailed Performance & Feature Comparison](https://docsbot.ai/models/compare/amazon-nova-lite/gpt-4o-mini)

LangChain とかで容易に llm 差し替えられるなら、
Amazon Nova Lite の方がいいかもしんない。
最大出力トークンが 5K なのはちょい少ないか。
[What is Amazon Nova? - Amazon Nova](https://docs.aws.amazon.com/nova/latest/userguide/what-is-nova.html)

### Amazon Nova Pro vs GPT-4o

| 項目                   | Amazon Nova Pro          | GPT-4o                       |
| ---------------------- | ------------------------ | ---------------------------- |
| **性能**               |                          |                              |
| 言語理解 (MMLU)        | 85.9%                    | 88.7%                        |
| 数学 (GSM8K)           | 94.8%                    | 92.6%                        |
| 数学 (MATH)            | 76.6%                    | 同等                         |
| コード生成             | 89.0%                    | 不明                         |
| コンテキストウィンドウ | 300K トークン            | 128K トークン                |
| 最大出力トークン数     | 5K トークン              | 16.4K トークン               |
| **価格**               |                          |                              |
| 入力トークン単価       | 0.80 ドル/100 万トークン | 2.50 ドル/100 万トークン     |
| 出力トークン単価       | 3.20 ドル/100 万トークン | 10.00 ドル/100 万トークン    |
| API 提供               | Amazon Bedrock           | OpenAI, Azure OpenAI Service |

あくまで参考値(Gemini 2.0 作成)
