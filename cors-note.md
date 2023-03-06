## CORSでプリフライトが呼ばれる条件

「単純リクエスト」でない場合にプリフライトが呼ばれる。

- [単純リクエスト](https://developer.mozilla.org/ja/docs/Web/HTTP/CORS#%E5%8D%98%E7%B4%94%E3%83%AA%E3%82%AF%E3%82%A8%E3%82%B9%E3%83%88)
- [Preflight request (プリフライトリクエスト)](https://developer.mozilla.org/ja/docs/Glossary/
Preflight_request)

許可されてるヘッダがどうも理解しがたくて
- 「ユーザーエージェントによって自動的に設定されたヘッダー」は、あっても「単純リクエスト」
- [Fetch 仕様書で禁止ヘッダー名として定義されているヘッダー](https://fetch.spec.whatwg.org/#forbidden-header-name)は、あっても「単純リクエスト」

「ユーザーエージェントによって自動的に設定されたヘッダー」が微妙。
「Fetch 仕様書で禁止ヘッダー名として定義されているヘッダー」がけっこうややこしい。

あとそもそもOrigin:はどうなの。
