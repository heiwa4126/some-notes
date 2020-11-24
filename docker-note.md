# Dockerメモ

- [Dockerメモ](#dockerメモ)
- [インストール](#インストール)
  - [メモ](#メモ)
- [便利なコマンド](#便利なコマンド)
- [dockerの「ボリューム」](#dockerのボリューム)
- [JDKなしでJavaをコンパイル](#jdkなしでjavaをコンパイル)
- [hello-worldのDockfile](#hello-worldのdockfile)
- [GoLangでサーバを書いてimageにしてみる](#golangでサーバを書いてimageにしてみる)
- [Red Hat Universal Base Image](#red-hat-universal-base-image)
- [Dockerでsyslog](#dockerでsyslog)
- [Credentials store (証明書ストア)](#credentials-store-証明書ストア)
- [AWSでDocker](#awsでdocker)
- [AzureでDocker](#azureでdocker)
- [チュートリアルズ](#チュートリアルズ)
- [snapでdocker](#snapでdocker)
- [コンテナのログ](#コンテナのログ)
- [イメージを全部消す](#イメージを全部消す)
- [docker-compose](#docker-compose)


# インストール

Docker CE (コミュニティエディション)をインストールしてみる。

公式サイトの文書に従うだけ。簡単。

[Get Docker CE for Ubuntu | Docker Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

```
$ sudo docker run hello-world
```
まで実行して、動作確認できたら

[Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/install/linux/linux-postinstall/)

で、「sudoなしでdocker実行」ができるようになる。
```
$ docker run hello-world
```

ここまで終わったら、
終了したコンテナは消しておく。
```
$ docker rm $(docker ps -aq)
```

## メモ

`docker ps -aq` は終了したコンテナのIDのみ出力するコマンド、ではない。


# 便利なコマンド

[一発ですべてのDockerコンテナを停止・削除、イメージの削除をする - Qiita](https://qiita.com/shisama/items/48e2eaf1dc356568b0d7)


終了したコンテナを削除する
```
docker ps -f "status=exited" -q | xargs -r docker rm -v
```

[Dockerイメージとコンテナの削除方法 - Qiita](https://qiita.com/tifa2chan/items/e9aa408244687a63a0ae)

ディスクの使用量
```
docker system df
```

# dockerの「ボリューム」

[Docker、ボリューム(Volume)について真面目に調べた - Qiita](https://qiita.com/gounx2/items/23b0dc8b8b95cc629f32)

> ボリューム(=データを永続化できる場所) は２種類ある




# JDKなしでJavaをコンパイル

あちこちから出ている
OpenJDKを試してみたかったので
`HelloWorld.java`をコンパイル&実行してみる。

Dockerで配布されてるのは、「Javaの実行環境」という位置づけであって「Javaの開発環境」ではないのだけど。


参考:
- [Dockerで色んなJDKを試す - Qiita](https://qiita.com/kikutaro/items/d140f519253f276b94e0)
- [adoptopenjdk's Profile - Docker Hub](https://hub.docker.com/u/adoptopenjdk)
- [docker run | Docker Documentation](https://docs.docker.com/engine/reference/commandline/run/)

作業ディレクトリ作成
``` bash
mkdir -p ~/works/java/HelloWorld
cd !$
emacs HelloWorld.java
```

`HelloWorld.java`
``` java
public class HelloWorld{
    public static void main(String[] args){
        System.out.printf
            (
             "Hello World!!\n" +
             "version: %s\n" +
             "vender: %s\n" +
             "vm: %s\n",
             System.getProperty("java.version"),
             System.getProperty("java.vendor"),
             System.getProperty("java.vm.name")
             );
    }
}
```

以下は
AdoptOpenJDK 11
を使った例

コンパイル
``` bash
docker run --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest \
 java HelloWorld
```

実行
``` bash
docker run --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest \
 java HelloWorld
```

実行例
```
Hello World!!
version: 11.0.3
vender: AdoptOpenJDK
vm: OpenJDK 64-Bit Server VM
```

何回も実行するなら、
たとえばaliasにして
.profileに書いておく。

``` bash
alias dj='docker run --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest'
```

これで

``` bash
dj javac HelloWorld.java
dj java HelloWorld
```
でOK。 効率は悪そう。

たとえば
``` bash
$ ID=$(docker run -dt --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest)
$ docker exec $id javac HelloWorld.java
$ docker exec $id java HelloWorld
$ docker stop $id
```
のようにしたほうが少しはいいのかもしれない。 (dockerの起動が重い)




# hello-worldのDockfile

- [hello-world | Docker Documentation](https://docs.docker.com/samples/library/hello-world/)
- [hello-world/Dockerfile at b715c35271f1d18832480bde75fe17b93db26414 · docker-library/hello-world](https://github.com/docker-library/hello-world/blob/b715c35271f1d18832480bde75fe17b93db26414/amd64/hello-world/Dockerfile)
- [docker-library/hello-world](https://github.com/docker-library/hello-world)

`hello`のソースは
- [hello-world/hello.c at a9a7163cb59f2ae60dc678d042055a56693fba7e · docker-library/hello-world](https://github.com/docker-library/hello-world/blob/a9a7163cb59f2ae60dc678d042055a56693fba7e/hello.c)
- [docker-library/hello-world at a9a7163cb59f2ae60dc678d042055a56693fba7e](https://github.com/docker-library/hello-world/tree/a9a7163cb59f2ae60dc678d042055a56693fba7e)

システムコールを直接呼んでいて、ライブラリ使っていない。
helloのバイナリサイズはとてもちいさい。


# GoLangでサーバを書いてimageにしてみる

```
$ go version
go version go1.12 linux/amd64
```

参考:
- [FROM scratchから始める軽量Docker image for Go - Qiita](https://qiita.com/Saint1991/items/dcd6a92e5074bd10f75a)
- [Building Minimal Docker Containers for Go Applications | Codeship | via @codeship](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)

clock.go ([参考リンク](https://qiita.com/Saint1991/items/dcd6a92e5074bd10f75a)そのまま)
``` go
package main

import (
    "net/http"
    "time"
)

const layout = "2006-01-02 15:04:05"

func main() {
    http.HandleFunc("/time",
        func(writer http.ResponseWriter, request *http.Request) {
            l := request.URL.Query().Get("tz")
            location, err := time.LoadLocation(l)
            if err != nil {
                panic(err)
            }
            writer.Write([]byte(time.Now().In(location).Format(layout)))
        }
    )

    http.ListenAndServe(":8080", nil)
}
```

clock.goのビルド
``` bash
$ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o clock -ldflags="-w -s" clock.go
```
upxも使えるので`upx --best clock`も試して

メモ:
go 1.6までは[goupx](https://github.com/pwaller/goupx)が必要。

メモ:
cgoとは何か? なぜ無効にするか? については
[GoとDockerでscratchを使うときに気をつけること - Qiita](https://qiita.com/Tsuzu/items/774073bccaff32e9ee8d)
を参照。

Dockerfile
```
FROM scratch

ADD https://github.com/golang/go/raw/master/lib/time/zoneinfo.zip /zoneinfo.zip
ENV ZONEINFO /zoneinfo.zip

COPY clock /clock

ENTRYPOINT ["/clock"]
```
- 順番に意味がある。↑だと最初のADDでimageがキャッシュされる。
- 上の例でADDの第2引数は「展開する場所」だが、zipは展開対象にならない。COPYにしたほうがいいかも

参考: [ADD | Docker Documentation](https://docs.docker.com/engine/reference/builder/#add)

docker imageの作成
``` bash
$ docker build ./ -t go-clock
$ docker image ls go-clock
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
go-clock            latest              cf53a2432eee        1 seconds ago      6.12MB
```
(upxを使うと2.8MB)


実行
``` bash
$ GOCLOCKID=$(docker run --rm -d -p 8080:8080 go-clock)
$ curl http://localhost:8080/time?tz=Local
2019-05-16 07:42:00
$ curl http://localhost:8080/time
2019-05-16 07:42:08
$ curl http://localhost:8080/time?tz=Asia/Tokyo
2019-05-16 07:42:39
$ docker stop $GOCLOCKID
(略)
```

LocalがUTCだ。

動作を確認したら、タグをつけてbuildしておく。

``` bash
$ docker build ./ -t go-clock:1
```

timezoneのファイルとにたようなやつで
SSLのCAのルート証明書は
[src/crypto/x509/root_linux.go - The Go Programming Language](https://golang.org/src/crypto/x509/root_linux.go)
からコピーして、同じパスに置く。
(OSごとに異なるDockerfileを作らないとダメ? 調べる。)

GitHubでは[go/root_linux.go at f2e51f00158c2dcdff37c573c24f798d1e63db31 · golang/go · GitHub](https://github.com/golang/go/blob/f2e51f00158c2dcdff37c573c24f798d1e63db31/src/crypto/x509/root_linux.go)

# Red Hat Universal Base Image

Red Hat Universal Base Imageを試す。

- [自由に再配布可能なRed Hat Enterprise Linux 8ベースのコンテナ用OSイメージ「Red Hat Universal Base Image」が公開 － Publickey](https://www.publickey1.jp/blog/19/red_hat_enterprise_linux_8osred_hat_universal_base_image.html)
-

```
$ docker search registry.redhat.io/ubi
...
$ docker pull registry.redhat.io/ubi7/ubi
Using default tag: latest
Error response from daemon: Get https://registry.redhat.io/v2/ubi7/ubi-init/manifests/latest: unauthorized: Please login to the Red Hat Registr$ using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/articles/3399531
```

RHNのアカウントが必要らしい。
[Red Hat Container Registry Authentication - Red Hat Customer Portal](https://access.redhat.com/RegistryAuthentication)

redhat developerのアカウントで行けるか試す。

```
$ docker login https://registry.redhat.io
Username: XXXXXXXXX
Password:
WARNING! Your password will be stored unencrypted in /home/heiwa/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded

$ docker run --rm -it registry.redhat.io/ubi7/ubi bash
[root@fd2064a8c239 /]# cat /etc/redhat-release
Red Hat Enterprise Linux Server release 7.6 (Maipo)
[root@fd2064a8c239 /]# subscription-manager status
+-------------------------------------------+
   System Status Details
+-------------------------------------------+
Overall Status: Unknown
```

やっぱコンテナもyumするには最初に登録がいるみたい。
Dockerfileの頭でやらないとダメだな。


# Dockerでsyslog

[ロギング・ドライバの設定 — Docker-docs-ja 17.06.Beta ドキュメント](http://docs.docker.jp/engine/admin/logging/overview.html#syslog)

`--log-driver=syslog`で、ローカルのsyslogにとれるはず。
(`--log-opt syslog-address=`のデフォルト値がunixソケットだから)

# Credentials store (証明書ストア)

```
docker login
```
で
```
WARNING! Your password will be stored unencrypted in /home/heiwa/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
```
と言われるのの対応。

- [docker login | Docker Documentation](https://docs.docker.com/engine/reference/commandline/login/#credentials-store)
- [login — Docker-docs-ja 17.06.Beta ドキュメント](http://docs.docker.jp/engine/reference/commandline/login.html#creadentials-store)

(cont.)


# AWSでDocker

Amazon ECS (Elastic Container Service)を使うわけだけど、なんだか大げさな感じ...
Docker Hubに置いたやつをちょっと動かしたいだけなんだが...

チュートリアルなど:

- [Docker for AWS setup & prerequisites | Docker Documentation](https://docs.docker.com/docker-for-aws/)
- [開始方法 - Amazon ECS | AWS](https://aws.amazon.com/jp/ecs/getting-started/)
- [Docker コンテナのデプロイ方法 – AWS](https://aws.amazon.com/jp/getting-started/tutorials/deploy-docker-containers/)
- [Amazon ECR の使用開始 - Amazon ECR](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/ECR_GetStarted.html)
- [Amazon Elastic Container Service、Docker、および Amazon EC2 を使用してモノリシックアプリケーションをマイクロサービスに分割する方法 | AWS](https://aws.amazon.com/jp/getting-started/projects/break-monolith-app-microservices-ecs-docker-ec2/)
- [Set Up a Continuous Delivery Pipeline for Containers Using AWS CodePipeline and Amazon ECS | AWS Compute Blog](https://aws.amazon.com/jp/blogs/compute/set-up-a-continuous-delivery-pipeline-for-containers-using-aws-codepipeline-and-amazon-ecs/)

# AzureでDocker

[Docker for AWS setup & prerequisites | Docker Documentation](https://docs.docker.com/docker-for-aws/)



# チュートリアルズ

- [Docker入門（第三回）～各種dockerコマンドとDockerイメージ作成について～ | さくらのナレッジ](https://knowledge.sakura.ad.jp/14427/)
- [Docker入門（第四回）～Dockerfileについて～ | さくらのナレッジ](https://knowledge.sakura.ad.jp/15253/)


# snapでdocker

dockeはsnapが楽。
事前にdockerグループは作っておくと非rootユーザで作業が楽。

```sh
sudo groupadd -r docker
sudo usermod -aG docker $USER
```
で、一旦ログアウト。`id`コマンドでdockerグループがあることを確認。

```sh
sudo snap install docker
```

あとは
```sh
docker run --name test00 hello-world
docker rm test00
```
などで動作テスト。

2020-11現在
```
$ docker -v
Docker version 19.03.11, build dd360c7

$ docker-compose -v
docker-compose version 1.25.5, build unknown
```

サービス名がけっこう変
```sh
systemctl --type=service | grep dock
systemctl status snap.docker.dockerd.service
```

あとイメージファイルは
`/var/snap/docker/common/var-lib-docker/image`
の下。

参考:
- [Install Docker for Linux using the Snap Store | Snapcraft](https://snapcraft.io/docker)
- [Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/engine/install/linux-postinstall/)

# コンテナのログ

コンテナではlogをstdoutに出す設定になってるものが多いみたい。

ログを永続化する必要がなければ
dockerとdocker-composeでは logsサブコマンドが使える。

- [logs — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/engine/reference/commandline/logs.html)
- [logs — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/reference/logs.html)

```sh
docker logs コンテナID
docker-compose logs
```

`-tf`オプションが便利。
`--tail=100`とかも便利。

ほか参考:
- [JSON ファイル・ロギング・ドライバ — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/config/container/logging/json-file.html)


# イメージを全部消す

参考: [使用していない Docker オブジェクトの削除（prune） — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/config/pruning.html)

本当に全部消える。Y/n聞いてくるので答える。
```sh
docker image prune -a
```

普通は「dangling imageのみ削除」
```sh
docker image prune
# or
docker system prune # たぶん一番よく使う
```

何もかも消す
```sh
docker system prune -a --volumes --force
```
もあり。


# docker-compose

ここから
[Overview of Docker Compose | Docker Documentation](https://docs.docker.com/compose/)


このチュートリアルがわかりやすかった。
[Docker入門（第六回）〜Docker Compose〜 | さくらのナレッジ](https://knowledge.sakura.ad.jp/16862/)

これを第1回からやるとdocker,docker-composeがだいたいわかる。
これに加えて`docker-compose logs`を。

- [docker-composeでNginxコンテナ内のログを見る | I am a software engineer](https://imanengineer.net/docker-compose-nginx-log/)
- [logs — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/reference/logs.html)


続けて以下などを。
- [クィックスタート: Compose と Django — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/django.html)


ほか参考:
- [docker-compose コマンドまとめ - Qiita](https://qiita.com/wasanx25/items/d47caf37b79e855af95f) - ちょっと古いけど
- [Compose における環境変数 — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/environment-variables.html) - yamlの中で環境変数を参照する方法や.envについて。
