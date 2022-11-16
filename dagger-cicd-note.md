
# install

Ubuntu LTS

[Install Dagger \| Dagger](https://docs.dagger.io/install/)

```bash
cd /usr/local
curl -L https://dl.dagger.io/dagger/install.sh | sh
```

bashの補完
ubuntuは `/usr/share/bash-completion/completions/*` なので

```bash
dagger completion bash > /tmp/dagger
sudo mv /tmp/dagger /usr/share/bash-completion/completions/
```

```
$ dagger version
dagger 0.2.36 (ea275a3ba) linux/amd64
```


# hello world

まずcuelangのhello world.
[dagger/helloworld.cue at v0.2.7 · dagger/dagger](https://github.com/dagger/dagger/blob/v0.2.7/pkg/universe.dagger.io/examples/helloworld/helloworld.cue)

Dockerは要るので
[Install Docker Engine on Ubuntu \| Docker Documentation](https://docs.docker.com/engine/install/ubuntu/)

```bash
mkdir -p ~/works/dagger/hello 
cd !$
dagger project init
dagger project update
curl "https://raw.githubusercontent.com/dagger/dagger/v0.2.7/pkg/universe.dagger.io/examples/helloworld/helloworld.cue" -O
```

で、
```bash
dagger do hello --log-format=plain
```

出力
```
$ dagger do hello --log-format=plain
3:32PM INFO  actions._alpine | computing
3:32PM INFO  actions._alpine | completed    duration=1.4s
3:32PM INFO  actions.hello | computing
3:32PM INFO  actions.hello | completed    duration=100ms
3:32PM INFO  actions.hello | #3 0.067 hello, world!
```

# tutorials

[Build, run and test locally | Dagger](https://docs.dagger.io/1200/local-dev)

nodejsでyarnで。build/の下にできる。LinuxだとXないとダメか。

`xdg-open build/index.html` のかわりに
[http-server - npm](https://www.npmjs.com/package/http-server)をここで立ち上げて
sshトンネリングでlocalhost:8080 につないでみる。

```bash
npm install -g http-server
http-server ./build/
```
-oオプションが使えない。

で `http://127.0.0.1:8080/index.html`
おお見えた。

では
> In the todoapp directory, edit line 25 of src/components/Form.js and save the file.

をやってみる。

`What needs to be done?` を `What must be done today?`にしてみた。

でもいちど
```
dagger do build
```
して、wwwブラウザをリロード。
おお変わった。

ローカルでできると楽だなあ。


# CUEメモ

JSONの上位互換で (YAMLと互換ではない)、制約とか重複排除とかあってすごい面白い。

インストール
```bash
go install cuelang.org/go/cmd/cue@latest
```

YAMLに変換
```bash
cue export ex1.cue --out yaml
```

cueもbash completeionあった
```bash
cue completion bash > /tmp/cue
sudo mv /tmp/cue /usr/share/bash-completion/completions/
```

CLIの解説: [CUE's cli commands | Overview | Cuetorials](https://cuetorials.com/overview/cli-commands/)


`daggaer.cue` を `cue export` すると、だいたいエラーになるのは何で?

いや同じところで出るな。dagger.#Plan &で client: platform: にデフォルト値がないのか。
```json
    client: {
        platform: {
            os: "linux"
            arch: "x86"
            }
    }
```
とかを付け加えると、とりあえず通ります。値があってるかどうかは微妙。

`cue eval`で。


CUEのチュートリアル
- [Cuetorials](https://cuetorials.com/)
- [CUE Playground](https://cuelang.org/play/)

CUE Playgroundがwasmのサンプルみたいになってるのがまたすごい。
