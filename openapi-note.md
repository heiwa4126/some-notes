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


# Embeddings: 文書の特徴量抽出

[Embeddings - OpenAI API](https://platform.openai.com/docs/guides/embeddings/what-are-embeddings)

エンベッディングは、浮動小数点数のベクトル（リスト）である。
2つのベクトル間の距離は、それらの関連性を計測する。
距離が小さいと関連性が高く、距離が大きいと関連性が低いことを示唆する。

画像の特徴量はなんとなくわかるけど
文書の特徴量はピンとこない。

ましてやOpenAIでは日本語は単語じゃなくて文字単位で特徴量抽出してるわけで、
ますます不思議である。
