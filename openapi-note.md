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
