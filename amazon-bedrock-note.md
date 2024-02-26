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
