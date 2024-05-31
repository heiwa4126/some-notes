# Azure 上の AI サービスのメモ

## 2 つあるみたい

生のモデルを叩く系は 2 つあるみたい。

- Azure OpenAI Service - 学習済みのモデルを利用する
- Azure Machine Learning - カスタムモデルを作成するために使用

以下 Bing Copilot に説明してもらったのを編集。

1. **Azure OpenAI Service**

   - Azure OpenAI Service は、Microsoft Azure の一部で提供される AI サービスの一つです。
   - このサービスは、OpenAI 社の大規模言語モデル(例:GPT)を利用できるもので、文章生成やコード生成などのタスクに活用できます。
   - Azure OpenAI Service API を使用することで、開発者はモデル構築のための機械学習の知識を持たなくても、AI を利用したサービスを開発できます。
   - API を介して Azure OpenAI Service にリクエストを送信し、モデルから返答を受け取ることができます。

2. **Azure Machine Learning API**
   - Azure Machine Learning は、機械学習モデルを構築・トレーニング・デプロイするためのプラットフォームです。
   - Azure Machine Learning API は、カスタムモデルを作成するために使用されます。
   - 開発者は自分でモデルを構築し、Azure Machine Learning API を通じてそれを利用できます。
   - カスタムモデルのトレーニングやデプロイには機械学習の知識が必要です。

他、タスク特化サービス:

1. **Azure Cognitive Services**:

   - Azure Cognitive Services は、機械学習や AI を活用したさまざまなタスクをサポートする API のセットです。
   - 例えば、自然言語処理、音声認識、画像認識、感情分析、翻訳などの機能を提供しています。

2. **Azure Bot Services**:

   - Azure Bot Services は、チャットボットや仮想アシスタントを構築するためのプラットフォームです。
   - ユーザーとの対話インターフェースを作成するために使用されます。

3. **Azure Computer Vision**:

   - Azure Computer Vision は、画像認識と解析のためのサービスです。
   - 画像内のオブジェクトの検出、テキストの読み取り、顔認識などを行います。

4. **Azure Speech Services**:
   - Azure Speech Services は、音声認識と音声合成のためのサービスです。
   - 音声からテキストへの変換や、テキストから音声への変換を行います。

### Azure Machine Learning サービスで作ったカスタムモデルを Azure OpenAI Service API で使用できますか?

**Azure Machine Learning サービス**で作成したカスタムモデルを**Azure OpenAI Service API**で使用することはできますが、いくつかの制約があります。

1. **モデルの形式**:

   - Azure Machine Learning サービスでトレーニングしたモデルは、一般的には機械学習フレームワーク(例:TensorFlow、PyTorch)でエクスポートされます。
   - 一方、Azure OpenAI Service API は、特定の形式(例:ONNX、TensorFlow SavedModel)でモデルを受け入れます。
   - カスタムモデルを Azure OpenAI Service API で使用する場合、モデルを適切な形式に変換する必要があります。

2. **互換性**:

   - Azure OpenAI Service API は、特定のモデルアーキテクチャと互換性があります。例えば、GPT-3 や GPT-4 などの大規模言語モデルはサポートされています。
   - カスタムモデルがこれらのアーキテクチャに適合していることを確認する必要があります。

3. **API のリクエストとレスポンス**:
   - Azure OpenAI Service API は、HTTP リクエストを介してモデルに対してテキストを送信し、テキストの生成結果を受け取ります。
   - カスタムモデルを Azure OpenAI Service API で使用する場合、リクエストとレスポンスのフォーマットを適切に設定する必要があります。

総括すると、Azure Machine Learning サービスで作成したカスタムモデルを Azure OpenAI Service API で使用することは可能ですが、モデルの形式と互換性に注意する必要があります。

(注:具体的な手順やコードの詳細については、Azure の公式ドキュメントやサンプルコードを参照してください)
