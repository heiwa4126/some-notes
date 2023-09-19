AWS LambdaでJavaは遅い、と聞いてたので試したことなかった。
けどJavaのライブラリ使いたい、って要件があるので
試してみる。

方針は

1. hello worldから始めてローカルテスト
1. 依存のあるコード書いてローカルテスト
1. デプロイしてテスト

SAMのバージョンは

```
$ sam --version
SAM CLI, version 1.63.0
```

プロジェクト作る

```bash
sam init --name java-hello1 --runtime java11 --package-type Zip --dependency-manager gradle --app-template hello-world
cd java-hello1
```

.gitignoreが無い。

```bash
curl -L https://www.toptal.com/developers/gitignore/api/gradle,java,visualstudiocode,emacs,vim -o .gitignore
```

に

```
**/.aws-sam
*.tmp
**/tmp
```

を追加して使う。

とりあえずローカルテスト

```bash
sam build
sam local invoke HelloWorldFunction  # 要Docker
```

いちおう動くようだ。ここで最初のコミット。

Gradleのテストもできる

```
cd HelloWorldFunction
gradle test
```

HelloWorldFunction/src/main/java/helloworld/App.java から
`getPageContents()`を取り除いて単にメッセージを返すだけにする。

JSONが文字列組み立て式なのでJacksonか何かでちゃんとやってみる。ごそごそコード書く。

まあ普通にJavaで開発できるよなこれ。

サーバーレスアプリケーションをローカルで実行

```bash
sam build
sam local start-api
curl http://127.0.0.1:3000/hello
```

そこそこ出来たので `sam deploy -g` してみる。普通に動く。それほど遅いようには思えん。

テスト終わったら `sam delete --no-prompts` でAWS上から消す。
