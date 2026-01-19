AWS Lambda で Java は遅い、と聞いてたので試したことなかった。
けど Java のライブラリ使いたい、って要件があるので
試してみる。

方針は

1. hello world から始めてローカルテスト
1. 依存のあるコード書いてローカルテスト
1. デプロイしてテスト

SAM のバージョンは

```
$ sam --version
SAM CLI, version 1.63.0
```

プロジェクト作る

```bash
sam init --name java-hello1 --runtime java11 --package-type Zip --dependency-manager gradle --app-template hello-world
cd java-hello1
```

.gitignore が無い。

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

Gradle のテストもできる

```
cd HelloWorldFunction
gradle test
```

HelloWorldFunction/src/main/java/helloworld/App.java から
`getPageContents()`を取り除いて単にメッセージを返すだけにする。

JSON が文字列組み立て式なので Jackson か何かでちゃんとやってみる。ごそごそコード書く。

まあ普通に Java で開発できるよなこれ。

サーバーレスアプリケーションをローカルで実行

```bash
sam build
sam local start-api
curl http://127.0.0.1:3000/hello
```

そこそこ出来たので `sam deploy -g` してみる。普通に動く。それほど遅いようには思えん。

テスト終わったら `sam delete --no-prompts` で AWS 上から消す。
