# JSONをOpenAPIの定義にするやつ

絶対だれか作ってるだろ、と思ったらあった。

- [Swagger toolbox](https://swagger-toolbox.firebaseapp.com/)
- via [JSON から OpenAPI（Swagger） Spec のモデルを生成するのに「Swagger toolbox」が便利 - Morning Girl](https://kageura.hatenadiary.jp/entry/swaggertoolbox)

# 参考書

- [OpenAPI 3を完全に理解できる本 - ota42y - BOOTH](https://booth.pm/ja/items/1571902)
- [REST API のためのコード生成入門 (OpenAPI Generator)](https://wing328.gumroad.com/l/openapi_generator_ebook_jp)


# AWS API Gatewayから エクスポート

- [API Gateway から REST API をエクスポートする - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-export-api.html)
- [get-export — AWS CLI 2.7.12 Command Reference](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/apigateway/get-export.html)

これはなかなか便利。swaggerかOpenAPI3で出せる。


# コンソールからAWS API Gatewayでバリデータなどをいじった後

再デプロイしないと反映されない。exportしても変化がない。

[REST API をステージに再デプロイする](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/how-to-deploy-api-with-console.html#apigateway-how-to-redeploy-api-console)

CLIもあると思うが調べてない。あとstackのドリフトは再デプロイしても検出できない。

ほか一覧: [再デプロイが必要な REST API の更新 - Amazon API Gateway](https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/updating-api.html)


# generateできるクライアントとサーバーのリスト

```bash
docker run --rm openapitools/openapi-generator-cli list
```


[python 3.x - ImportError: cannot import name 'escape' from 'jinja2' - Stack Overflow](https://stackoverflow.com/questions/71718167/importerror-cannot-import-name-escape-from-jinja2)


# クライアントを作る話

[OpenAPITools/openapi-generator: OpenAPI Generator allows generation of API client libraries (SDK generation), server stubs, documentation and configuration automatically given an OpenAPI Spec (v2, v3)](https://github.com/OpenAPITools/openapi-generator#16---docker)

```bash
docker run --rm -v "${PWD}:/local" openapitools/openapi-generator-cli generate \
    -i  /local/openapi.yaml \
    -g python \
    -o /local/out/python
```

でコードが生成されるので
```bash
sudo chown -R ${UID} out
cd out/python
python3 setup.py install --user
```

で準備完了。`README.md` にサンプルコードがあるので、それをコピペして実行。
更に改造するには `docs/DefaultApi.md` を見る。

# Fine-tuning

[Fine\-tuning \- OpenAI API](https://platform.openai.com/docs/guides/fine-tuning)

Q&Aやコール&レスポンスをprompt&completionの組にしてJSONLにする。
(csvなんかから作ると楽らしい。[OpenAI CLI データ準備ツール](https://learn.microsoft.com/ja-jp/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio#openai-cli-data-preparation-tool)参照)

JSONLは末尾の`,`なしのdictの配列。改行が`,`がわりで、
最初と最後の`[...]`がないやつだ。

おそらくprompt&completionにトークン数の制限がある。

環境変数 `OPENAI_API_KEY`

ベースになるモデルを選んで流し込む。

AzureだとOpenAIスタジオにUIがある。
[\[Create customized model\]\(カスタマイズしたモデルの作成\) ウィザードを使用する](https://learn.microsoft.com/ja-jp/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-studio#use-the-create-customized-model-wizard)

参考: [OpenAI APIのFine-tuningを試してみる | DevelopersIO](https://dev.classmethod.jp/articles/888c355f2c88e117d172ec1bd3d28a435ee438766630638e3e9f7887aef8f5ee/)

カスタムモデルができる。

AzureのOpenAIには「カスタマイズしたモデルをデプロイ」というステップがある。
> カスタマイズしたモデルに対して許可されるデプロイは 1 つだけです。 既にデプロイされているカスタマイズしたモデルを選択すると、エラーが発生します。

なんだよそれ。[カスタマイズしたモデルをデプロイする](https://learn.microsoft.com/ja-jp/azure/cognitive-services/openai/how-to/fine-tuning?pivots=programming-language-python#deploy-a-customized-model)

prompt&completion、どんなものを用意したらいいの?

[【完全保存版】GPT を特定の目的に特化させて扱う (Fine-tuning, Prompt, Index, etc.) - Qiita](https://qiita.com/tmgauss/items/22c4e5e00282a23e569d)

にいくつかサンプルが。

* [ミルクボーイのネタでGPT-3をファインチューニングしてみた (1) \~入門編\~ - Qiita](https://qiita.com/wt1113/items/41196237d234dba7660f)
* [ミルクボーイのネタでGPT-3をファインチューニングしてみた (2) \~リベンジ編\~ - Qiita](https://qiita.com/wt1113/items/ee7d558cdc5c4b7da721)
* で、[カスタム モデル トレーニングのためにデータセットを準備する方法 - Azure OpenAI Service | Microsoft Learn](https://learn.microsoft.com/ja-jp/azure/cognitive-services/openai/how-to/prepare-dataset)


https://platform.openai.com/docs/guides/fine-tuning/data-formatting

**データフォーマット**

モデルを微調整するには、1つの入力("prompt" 以下「プロンプト」)と
それに関連する出力("completion" 以下「補完」)で構成される学習例セットが必要です。
これは、1つのプロンプトに詳細な指示や複数の例を入力するようなベースモデルの使用とは大きく異なります。

- 各プロンプトは、プロンプトの終了と完了の開始をモデルに知らせるため、固定したセパレータで終了する必要があります。一般的にうまく機能する簡単なセパレータは、`\n\n###\n\n` のようなものである。このセパレータは、プロンプトの他の場所に表示されないようにする。
- ほとんどの単語がトークナイザーによって先行する空白でトークン化されるため、各補完は空白で始まるはずです。(日本語はどうなの)
- 各補完は、補完の終了をモデルに知らせるために、決まった停止シーケンスで終了する必要があります。例えば `\n`や`###` など。
- 推論する時には、トレーニングデータセットを作成したときと同じように、**同じセパレータを含むプロンプトでフォーマットする必要があります**。また、補完を適切に切り捨てるために、**同じ停止シーケンスを指定します**。




# Embeddings: 文書の特徴量抽出

[Embeddings - OpenAI API](https://platform.openai.com/docs/guides/embeddings/what-are-embeddings)

エンベッディング(embedding)は、浮動小数点数のベクトル(リスト)である。
2つのベクトル間の距離は、それらの関連性を計測する。
距離が小さいと関連性が高く、距離が大きいと関連性が低いことを示唆する。

画像の特徴量はなんとなくわかるけど(わかってない)
文書の特徴量はピンとこない。

ましてやOpenAIでは日本語は単語じゃなくて文字単位で特徴量抽出してるわけで、
ますます不思議である。

リストから元の文書って取り出せるのかな?
