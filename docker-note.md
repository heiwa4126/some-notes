# Docker メモ

- [インストール](#インストール)
  - [メモ](#メモ)
- [便利なコマンド](#便利なコマンド)
- [docker の「ボリューム」](#docker-のボリューム)
- [docker が実際にどれぐらいディスクを使っているか](#docker-が実際にどれぐらいディスクを使っているか)
- [JDK なしで Java をコンパイル](#jdk-なしで-java-をコンパイル)
- [hello-world の Dockfile](#hello-world-の-dockfile)
- [GoLang でサーバを書いて image にしてみる](#golang-でサーバを書いて-image-にしてみる)
- [Red Hat Universal Base Image](#red-hat-universal-base-image)
- [Docker で syslog](#docker-で-syslog)
- [Credentials store (証明書ストア)](#credentials-store-証明書ストア)
- [AWS で Docker](#aws-で-docker)
- [Azure で Docker](#azure-で-docker)
- [チュートリアルズ](#チュートリアルズ)
- [snap で docker](#snap-で-docker)
- [コンテナのログ](#コンテナのログ)
- [イメージを全部消す](#イメージを全部消す)
- [docker compose](#docker-compose)
  - [docker-compose はいつ docker compose になりましたか?](#docker-compose-はいつ-docker-compose-になりましたか)
- [docker-compose (古い)](#docker-compose-古い)
  - [install](#install)
- [CentOS7 で podman](#centos7-で-podman)
- [minikube](#minikube)
- [rootless mode](#rootless-mode)
- [BuildKit](#buildkit)
- [docker の tag](#docker-の-tag)
- [docker でコンテナが実行されているときに、元のイメージを書き換えるとどうなる?](#docker-でコンテナが実行されているときに元のイメージを書き換えるとどうなる)
- [いらんイメージを手早く消す](#いらんイメージを手早く消す)
- [docker で全てのイメージを削除する](#docker-で全てのイメージを削除する)
- [docker history](#docker-history)
- [AWS ECR のライフサイクルポリシー](#aws-ecr-のライフサイクルポリシー)
- [デタッチモード(-d)で docker run したプロセスの出力を見る](#デタッチモード-dで-docker-run-したプロセスの出力を見る)
- [ssh 経由で image をよそのホストにコピー](#ssh-経由で-image-をよそのホストにコピー)
- [Docker のイメージからそれを作った Dockerfile は見れる?](#docker-のイメージからそれを作った-dockerfile-は見れる)
- [配布されている Docker イメージのタグのリスト](#配布されている-docker-イメージのタグのリスト)
  - [Google の distroless のタグ一覧](#google-の-distroless-のタグ一覧)
- [Google の distroless に入っている Python や Node.js のバージョンはどうやって調べられますか?](#google-の-distroless-に入っている-python-や-nodejs-のバージョンはどうやって調べられますか)
- [distroless にはデバッグ用のイメージがある](#distroless-にはデバッグ用のイメージがある)
- [例えば gcr.io/distroless/nodejs22-debian12 のとき](#例えば-gcriodistrolessnodejs22-debian12-のとき)
- [Docker Content Trust (DCT)](#docker-content-trust-dct)
- [Alpine の musl は 2024 年でもまだ不安定だったり遅かったりしますか?](#alpine-の-musl-は-2024-年でもまだ不安定だったり遅かったりしますか)
- [すごい参考になる (`RUN --mount=type=`)](#すごい参考になる-run---mounttype)
- [docker pull でイメージが更新されないとき](#docker-pull-でイメージが更新されないとき)
- [IMAGE ID](#image-id)
- [ヘルスチェック](#ヘルスチェック)
- [最新のコンテナ](#最新のコンテナ)

## インストール

Docker CE (コミュニティエディション)をインストールしてみる。

公式サイトの文書に従うだけ。簡単。

[Get Docker CE for Ubuntu | Docker Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

```sh
sudo docker run hello-world
```

まで実行して、動作確認できたら

[Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/install/linux/linux-postinstall/)

で、「sudo なしで docker 実行」ができるようになる。(一旦 logout する必要があるかも)

```sh
docker run hello-world
## or
docker run --rm hello-world
```

ここまで終わったら、
終了したコンテナは消しておく。

```sh
docker rm $(docker ps -aq)
```

### メモ

`docker ps -aq` は終了したコンテナの ID のみ出力するコマンド、ではない。

## 便利なコマンド

[一発ですべての Docker コンテナを停止・削除、イメージの削除をする - Qiita](https://qiita.com/shisama/items/48e2eaf1dc356568b0d7)

終了したコンテナを削除する

```bash
docker ps -f "status=exited" -q | xargs -r docker rm -v
```

[Docker イメージとコンテナの削除方法 - Qiita](https://qiita.com/tifa2chan/items/e9aa408244687a63a0ae)

ディスクの使用量

```bash
docker system df
```

## docker の「ボリューム」

[Docker、ボリューム(Volume)について真面目に調べた - Qiita](https://qiita.com/gounx2/items/23b0dc8b8b95cc629f32)

> ボリューム(=データを永続化できる場所) は 2 種類ある

## docker が実際にどれぐらいディスクを使っているか

```bash
sudo du -hs /var/lib/docker/
```

## JDK なしで Java をコンパイル

あちこちから出ている
OpenJDK を試してみたかったので
`HelloWorld.java`をコンパイル&実行してみる。

Docker で配布されてるのは、「Java の実行環境」という位置づけであって「Java の開発環境」ではないのだけど。

参考:

- [Docker で色んな JDK を試す - Qiita](https://qiita.com/kikutaro/items/d140f519253f276b94e0)
- [adoptopenjdk's Profile - Docker Hub](https://hub.docker.com/u/adoptopenjdk)
- [docker run | Docker Documentation](https://docs.docker.com/engine/reference/commandline/run/)

作業ディレクトリ作成

```bash
mkdir -p ~/works/java/HelloWorld
cd !$
emacs HelloWorld.java
```

`HelloWorld.java`

```java
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

コンパイル

```bash
docker run --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest \
 java HelloWorld
```

実行

```bash
docker run --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest \
 java HelloWorld
```

実行例

```console
Hello World!!
version: 11.0.3
vender: AdoptOpenJDK
vm: OpenJDK 64-Bit Server VM
```

何回も実行するなら、
たとえば alias にして
.profile に書いておく。

```bash
alias dj='docker run --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest'
```

これで

```bash
dj javac HelloWorld.java
dj java HelloWorld
```

で OK。 効率は悪そう。

たとえば

```bash
ID=$(docker run -dt --rm -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest)
docker exec $id javac HelloWorld.java
docker exec $id java HelloWorld
docker stop $id
```

のようにしたほうが少しはいいのかもしれない。 (docker の起動が重い)

## hello-world の Dockfile

- [hello-world | Docker Documentation](https://docs.docker.com/samples/library/hello-world/)
- [hello-world/Dockerfile at b715c35271f1d18832480bde75fe17b93db26414 · docker-library/hello-world](https://github.com/docker-library/hello-world/blob/b715c35271f1d18832480bde75fe17b93db26414/amd64/hello-world/Dockerfile)
- [docker-library/hello-world](https://github.com/docker-library/hello-world)

`hello`のソースは

- [hello-world/hello.c at a9a7163cb59f2ae60dc678d042055a56693fba7e · docker-library/hello-world](https://github.com/docker-library/hello-world/blob/a9a7163cb59f2ae60dc678d042055a56693fba7e/hello.c)
- [docker-library/hello-world at a9a7163cb59f2ae60dc678d042055a56693fba7e](https://github.com/docker-library/hello-world/tree/a9a7163cb59f2ae60dc678d042055a56693fba7e)

システムコールを直接呼んでいて、ライブラリ使っていない。
hello のバイナリサイズはとてもちいさい。

## GoLang でサーバを書いて image にしてみる

```console
$ go version
go version go1.12 linux/amd64
```

参考:

- [FROM scratch から始める軽量 Docker image for Go - Qiita](https://qiita.com/Saint1991/items/dcd6a92e5074bd10f75a)
- [Building Minimal Docker Containers for Go Applications | Codeship | via @codeship](https://blog.codeship.com/building-minimal-docker-containers-for-go-applications/)

clock.go ([参考リンク](https://qiita.com/Saint1991/items/dcd6a92e5074bd10f75a)そのまま)

```go
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

clock.go のビルド

```bash
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o clock -trimpath -ldflags="-w -s" clock.go
```

upx も使えるので`upx --best clock`も試して

メモ:
go 1.6 までは[goupx](https://github.com/pwaller/goupx)が必要。

メモ:
cgo とは何か? なぜ無効にするか? については
[Go と Docker で scratch を使うときに気をつけること - Qiita](https://qiita.com/Tsuzu/items/774073bccaff32e9ee8d)
を参照。

Dockerfile

```
FROM scratch

ADD https://github.com/golang/go/raw/master/lib/time/zoneinfo.zip /zoneinfo.zip
ENV ZONEINFO /zoneinfo.zip

COPY clock /clock

ENTRYPOINT ["/clock"]
```

- 順番に意味がある。↑ だと最初の ADD で image がキャッシュされる。
- 上の例で ADD の第 2 引数は「展開する場所」だが、zip は展開対象にならない。COPY にしたほうがいいかも

参考: [ADD | Docker Documentation](https://docs.docker.com/engine/reference/builder/#add)

docker image の作成

```bash
$ docker build ./ -t go-clock
$ docker image ls go-clock
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
go-clock            latest              cf53a2432eee        1 seconds ago      6.12MB
```

(upx を使うと 2.8MB)

実行

```bash
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

Local が UTC だ。

動作を確認したら、タグをつけて build しておく。

```bash
docker build ./ -t go-clock:1
```

timezone のファイルとにたようなやつで
SSL の CA のルート証明書は
[src/crypto/x509/root_linux.go - The Go Programming Language](https://golang.org/src/crypto/x509/root_linux.go)
からコピーして、同じパスに置く。
(OS ごとに異なる Dockerfile を作らないとダメ? 調べる。)

GitHub では[go/root_linux.go at f2e51f00158c2dcdff37c573c24f798d1e63db31 · golang/go · GitHub](https://github.com/golang/go/blob/f2e51f00158c2dcdff37c573c24f798d1e63db31/src/crypto/x509/root_linux.go)

## Red Hat Universal Base Image

Red Hat Universal Base Image を試す。

- [自由に再配布可能な Red Hat Enterprise Linux 8 ベースのコンテナ用 OS イメージ「Red Hat Universal Base Image」が公開 - Publickey](https://www.publickey1.jp/blog/19/red_hat_enterprise_linux_8osred_hat_universal_base_image.html)
-

```
$ docker search registry.redhat.io/ubi
...
$ docker pull registry.redhat.io/ubi7/ubi
Using default tag: latest
Error response from daemon: Get https://registry.redhat.io/v2/ubi7/ubi-init/manifests/latest: unauthorized: Please login to the Red Hat Registr$ using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/articles/3399531
```

RHN のアカウントが必要らしい。
[Red Hat Container Registry Authentication - Red Hat Customer Portal](https://access.redhat.com/RegistryAuthentication)

redhat developer のアカウントで行けるか試す。

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

やっぱコンテナも yum するには最初に登録がいるみたい。
Dockerfile の頭でやらないとダメだな。

## Docker で syslog

[ロギング・ドライバの設定 — Docker-docs-ja 17.06.Beta ドキュメント](http://docs.docker.jp/engine/admin/logging/overview.html#syslog)

`--log-driver=syslog`で、ローカルの syslog にとれるはず。
(`--log-opt syslog-address=`のデフォルト値が unix ソケットだから)

## Credentials store (証明書ストア)

```
docker login
```

で

```
WARNING! Your password will be stored unencrypted in /home/heiwa/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store
```

と言われるのの対応。

- [docker login | Docker Documentation](https://docs.docker.com/engine/reference/commandline/login/#credentials-store)
- [login — Docker-docs-ja 17.06.Beta ドキュメント](http://docs.docker.jp/engine/reference/commandline/login.html#creadentials-store)

(cont.)

## AWS で Docker

Amazon ECS (Elastic Container Service)を使うわけだけど、なんだか大げさな感じ...
Docker Hub に置いたやつをちょっと動かしたいだけなんだが...

チュートリアルなど:

- [Docker for AWS setup & prerequisites | Docker Documentation](https://docs.docker.com/docker-for-aws/)
- [開始方法 - Amazon ECS | AWS](https://aws.amazon.com/jp/ecs/getting-started/)
- [Docker コンテナのデプロイ方法 – AWS](https://aws.amazon.com/jp/getting-started/tutorials/deploy-docker-containers/)
- [Amazon ECR の使用開始 - Amazon ECR](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/ECR_GetStarted.html)
- [Amazon Elastic Container Service、Docker、および Amazon EC2 を使用してモノリシックアプリケーションをマイクロサービスに分割する方法 | AWS](https://aws.amazon.com/jp/getting-started/projects/break-monolith-app-microservices-ecs-docker-ec2/)
- [Set Up a Continuous Delivery Pipeline for Containers Using AWS CodePipeline and Amazon ECS | AWS Compute Blog](https://aws.amazon.com/jp/blogs/compute/set-up-a-continuous-delivery-pipeline-for-containers-using-aws-codepipeline-and-amazon-ecs/)

## Azure で Docker

[Docker for AWS setup & prerequisites | Docker Documentation](https://docs.docker.com/docker-for-aws/)

## チュートリアルズ

- [Docker 入門(第三回)~~各種 docker コマンドと Docker イメージ作成について~~ | さくらのナレッジ](https://knowledge.sakura.ad.jp/14427/)
- [Docker 入門(第四回)~ Dockerfile について~ | さくらのナレッジ](https://knowledge.sakura.ad.jp/15253/)

## snap で docker

docke は snap が楽。
事前に docker グループは作っておくと非 root ユーザで作業が楽。

RHEL7 とかだと Docker 社が Red Hat と喧嘩して
snap しか Docker を使う方法がないみたい。

```sh
sudo groupadd -r docker
sudo usermod -aG docker $USER
```

で、一旦ログアウト。`id`コマンドで docker グループがあることを確認。

```sh
sudo snap install docker
```

あとは

```sh
docker run --name test00 hello-world
docker rm test00
```

などで動作テスト。

2020-11 現在

```
$ docker -v
Docker version 19.03.11, build dd360c7

$ docker-compose -v
docker-compose version 1.25.5, build unknown
```

サービス名がけっこう変

```sh
systemctl --type=service | grep dock
systemctl status snap.docker.dockerd.service
```

あとイメージファイルは
`/var/snap/docker/common/var-lib-docker/image`
の下。

参考:

- [Install Docker for Linux using the Snap Store | Snapcraft](https://snapcraft.io/docker)
- [Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/engine/install/linux-postinstall/)

## コンテナのログ

コンテナでは log を stdout に出す設定になってるものが多いみたい。

ログを永続化する必要がなければ
docker と docker-compose では logs サブコマンドが使える。

- [logs — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/engine/reference/commandline/logs.html)
- [logs — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/reference/logs.html)

```sh
docker logs コンテナID
docker-compose logs
```

`-tf`オプションが便利。
`--tail=100`とかも便利。

ほか参考:

- [JSON ファイル・ロギング・ドライバ — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/config/container/logging/json-file.html)

## イメージを全部消す

参考: [使用していない Docker オブジェクトの削除(prune) — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/config/pruning.html)

本当に全部消える。Y/n 聞いてくるので答える。

```sh
docker image prune -a
```

普通は「dangling image のみ削除」

```sh
docker image prune
## or
docker system prune # たぶん一番よく使う
```

何もかも消す

```sh
docker system prune -a --volumes --force
```

もあり。

## docker compose

### docker-compose はいつ docker compose になりましたか?

調べたけどよくわからなかった。

[docker/compose: Define and run multi-container applications with Docker](https://github.com/docker/compose)
の
[Release v2.0.0 · docker/compose](https://github.com/docker/compose/releases/tag/v2.0.0)
が
2021-09-28 なので、いちおうこの日。

## docker-compose (古い)

ここから
[Overview of Docker Compose | Docker Documentation](https://docs.docker.com/compose/)

このチュートリアルがわかりやすかった。
[Docker 入門(第六回)〜Docker Compose〜 | さくらのナレッジ](https://knowledge.sakura.ad.jp/16862/)

これを第 1 回からやると docker,docker-compose がだいたいわかる。
これに加えて`docker-compose logs`を。

- [docker-compose で Nginx コンテナ内のログを見る | I am a software engineer](https://imanengineer.net/docker-compose-nginx-log/)
- [logs — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/reference/logs.html)

続けて以下などを。

- [クィックスタート: Compose と Django — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/django.html)

ほか参考:

- [docker-compose コマンドまとめ - Qiita](https://qiita.com/wasanx25/items/d47caf37b79e855af95f) - ちょっと古いけど
- [How to run docker-compose up -d at system start up? - Stack Overflow](https://stackoverflow.com/questions/43671482/how-to-run-docker-compose-up-d-at-system-start-up) - ホスト起動時に docker-compose up する手法いろいろ。
- [Compose における環境変数 — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/environment-variables.html) - yaml の中で環境変数を参照する方法や.env について。

### install

ディストリの docker-compose を削除。

あとは以下に従う。
[Docker Compose のインストール — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/compose/install.html#linux)

要は

1. [github の release ページ](https://github.com/docker/compose/releases)からバイナリを落とす。
2. `/usr/local/bin/docker-compose`とかの名前で置いて、実行権限をつける。

## CentOS7 で podman

```
sudo yum install podman
```

podman-docker パッケージをインストールすれば docker コマンドのふりができる。
man も入ってるけどメンテされてないのかまともに動かない。

```
$ man docker
man: can't open /usr/share/man/man1/./docs/build/man/podman.1: No such file or directory
No manual entry for docker
```

で

```
$ podman run hello-world
Trying to pull registry.access.redhat.com/hello-world...
  name unknown: Repo not found
Trying to pull registry.redhat.io/hello-world...
  unable to retrieve auth token: invalid username/password: unauthorized: Please login to the Red Hat Registry using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/RegistryAuthentication
...
```

先に registry.redhat.io を探しに行くのをやめさせるには?
あるいは docker.io を先にするには?

man podman-pull に書いてあった。`/etc/containers/registries.conf`だ。

docker-compose に相当するものは
[containers/podman-compose: a script to run docker-compose.yml using podman](https://github.com/containers/podman-compose)。

python3 なので、pip でインストール。

```
sudo yum install python3
pip3 install --user -U pip
## 一旦logout
pip install --user -U podman-compose
hash -r
podman-compose --help
```

podman-compose には`--version`が無い。

podman-compose には ps サブコマンドがない。
podman-compose には logs サブコマンドがない。

podman 的には Kubernetes を使え、ということらしい。

参考: [Podman で Compose したかったらどうするの? - Qiita](https://qiita.com/thirdpenguin/items/c9e58c27e96f02b0a96d)

## minikube

AWS 上の Ubuntu 18.04LTS に minikube を作ってみる。

参考: [勉強用に minikube を EC2 上で実行する - Qiita](https://qiita.com/masahiko_katayose/items/34605e04b4a81610e668)

```sh
sudo apt-get install docker.io conntrack
## kubectl(kubernetesのCLI操作ツール) を導入
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
## minkubeを導入
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
## minikube開始
sudo -i
minikube start --vm-driver=none
```

実行例

```sh
$ minikube version
minikube version: v1.15.1
commit: 23f40a012abb52eff365ff99a709501a61ac5876

$ sudo -i

## minikube start --vm-driver=none

* Ubuntu 18.04 (xen/amd64) 上の minikube v1.15.1
* 設定を元に、 none ドライバを使用します
* コントロールプレーンのノード minikube を minikube 上で起動しています
* Running on localhost (CPUs=2, Memory=3933MB, Disk=29715MB) ...
* OS は Ubuntu 18.04.5 LTS です。
* Docker 19.03.14 で Kubernetes v1.19.4 を準備しています...
  - kubelet.resolv-conf=/run/systemd/resolve/resolv.conf
    > kubectl.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubelet.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubeadm.sha256: 64 B / 64 B [--------------------------] 100.00% ? p/s 0s
    > kubectl: 41.01 MiB / 41.01 MiB [---------------] 100.00% 89.13 MiB p/s 0s
    > kubeadm: 37.30 MiB / 37.30 MiB [---------------] 100.00% 54.47 MiB p/s 1s
    > kubelet: 104.92 MiB / 104.92 MiB [-------------] 100.00% 64.00 MiB p/s 2s
* Configuring local host environment ...
*
! The 'none' driver is designed for experts who need to integrate with an existing VM
* Most users should use the newer 'docker' driver instead, which does not require root!
* For more information, see: https://minikube.sigs.k8s.io/docs/reference/drivers/none/
*
! kubectl と minikube の構成は /root に保存されます
! kubectl か minikube コマンドを独自のユーザーとして使用するには、そのコマンドの再配置が必要な場合があります。たとえば、独自の設定を上書きするには、以下を実行します
*
  - sudo mv /root/.kube /root/.minikube $HOME
  - sudo chown -R $USER $HOME/.kube $HOME/.minikube
*
* これは環境変数 CHANGE_MINIKUBE_NONE_USER=true を設定して自動的に行うこともできます
* Kubernetes コンポーネントを検証しています...
* 有効なアドオン: storage-provisioner, default-storageclass
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

停止は`minikube stop`

なんか一般ユーザでも動かせそうだが
`the 'none' driver must be run as the root user`
と言われて動かない。

ステータスは

```sh
sudo -i minikube status
```

`-i`オプションがいる。

[Hello Minikube | Kubernetes](https://kubernetes.io/ja/docs/tutorials/hello-minikube/)

```sh
minikube dashboard --url=false
```

毎回違うポートになるな... 固定できないのか。

## rootless mode

v.19 で試験的導入。v.20 で正規機能。

- [Run the Docker daemon as a non-root user (Rootless mode) | Docker Documentation](https://docs.docker.com/engine/security/rootless/)
- [root ユーザー以外による Docker デーモン起動(rootless モード) | Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/engine/security/rootless/)

Docker そのもののインストール: [Install Docker Engine on Ubuntu | Docker Documentation](https://docs.docker.com/engine/install/ubuntu/)

```sh
sudo apt-get update
sudo apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
```

いるもの

```sh
sudo apt install uidmap
```

systemd の user モードで docker が上がる。ログインすると docker が起動する。
ここ `/home/YOURHOME/.config/systemd/user/docker.service`

```sh
systemctl --user status docker.service
```

で確認。

PATH を通すのと環境変数 1 個。.bashrc とかに入れる

```sh
export PATH=/home/heiwa/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
```

docker-compose は?

[Docker に Rootless モードが入ったぞ!という話 - Qiita](https://qiita.com/inductor/items/75db0c1c0d49646dd68a)

## BuildKit

最近の docker なら BuildKit はデフォルトで有効。Docker v20 あたりから?

(古い) 最近の docker なら

```sh
DOCKER_BUILDKIT=1 docker build .
```

で OK。

参考:

- [BuildKit でイメージ構築 — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/develop/develop-images/build_enhancements.html)
- [BuildKit によるイメージ構築 | Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/develop/develop-images/build_enhancements/) 同じ内容
- [BuildKit による高速でセキュアなイメージビルド](https://www.slideshare.net/AkihiroSuda/buildkit) - 「使えない」と書いてある機能は使えるようになってる模様
- [Docker 18.09 新機能 (イメージビルド&セキュリティ) | by Akihiro Suda | nttlabs | Medium](https://medium.com/nttlabs/docker-v18-09-%E6%96%B0%E6%A9%9F%E8%83%BD-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%83%93%E3%83%AB%E3%83%89-%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3-9534714c26e2) 同じ内容(同じ筆者?)ちょっと詳しい。よみやすい
- [Docker の BuildKit を使ってセキュアなビルドを試す - Qiita](https://qiita.com/takasp/items/56e1399a484ed5bfaade)

さらにつおい buildx
[Docker Buildx | Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/buildx/working-with-buildx/)

## docker の tag

1 つのイメージに複数のタグをつけることができる。
`docker images` (or `docker image ls`) で同じ ID のイメージが複数あるように見える。

## docker でコンテナが実行されているときに、元のイメージを書き換えるとどうなる?

予想では
「`Repository=<none>`になって残るので何も起きない」
「i-node を掴んでいるので何も起きない(Windows とかは知らない)」
だと思われる。

素の Alpine に tty でつないでいるところを scratch に書き換えてみる。

...予想通りだった。
おそらく repository:tag が image ID かハッシュに変換されて読み込んでるのであろう。

じゃいま動いてるイメージを rmi するとどうなる。

```console
$ docker rmi b11fdd96e58e
Error response from daemon: conflict: unable to delete b11fdd96e58e (cannot be forced) - image is being used by running container 726262b5a406

## いちおう
$ docker rmi b11fdd96e58e --force
Error response from daemon: conflict: unable to delete b11fdd96e58e (cannot be forced) - image is being used by running container 726262b5a406
```

rmi できないし、force オプションでもダメ。
ある意味当然か。

## いらんイメージを手早く消す

```sh
docker image prune -f
```

[使用していない Docker オブジェクトの削除(prune) — Docker-docs-ja 20.10 ドキュメント](https://docs.docker.jp/config/pruning.html)

`prune`には他いろんなものが消せるオプションがある。↑ 参考。

```sh
docker image prune -f
docker builder prune -f
# または
docker system prune
```

は時々やっとくといいと思う。

## docker で全てのイメージを削除する

```sh
docker rmi $(docker images -q)
# 強制的に削除するには `-f` オプションつきで
docker rmi $(docker images -q) -f
docker system prune -f
# これでまっさら
```

## docker history

Dockerfile の中身的なものが見れる。

```bash
docker history <image ID or REPOSITORY:TAG> --no-trunc | less
## or
docker history --format "{{.CreatedBy}}" test0 --no-trunc  | less
```

出力は逆順なので `|tac|less`とかする。

## AWS ECR のライフサイクルポリシー

- [ライフサイクルポリシー - Amazon ECR](https://docs.aws.amazon.com/ja_jp/AmazonECR/latest/userguide/LifecyclePolicies.html)
- [aws_ecr_lifecycle_policy | Resources | hashicorp/aws | Terraform Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy)

## デタッチモード(-d)で docker run したプロセスの出力を見る

`docker logs`

実行例

```console
$ docker run --rm -d -p 3000:3000 myapp1:test1
74e2562e6dbb0b2b59cc4f7f072e4654113bbedef478a59bad056352d8b1c904

$ docker logs 74e2562e6dbb0b2b59cc4f7f072e4654113bbedef478a59bad056352d8b1c904
```

## ssh 経由で image をよそのホストにコピー

```sh
docker save myapp1:test1 | ssh myhost1 'docker load'
```

- `ssh myhost1` で正常につながる前提
- myhost1 には docker が入ってる前提

## Docker のイメージからそれを作った Dockerfile は見れる?

完全に再現はできないけど

```sh
docker history <image_name>
docker inspect <image_name>
```

で、そこそこわかる。

## 配布されている Docker イメージのタグのリスト

配布されている Docker イメージのタグのリストを取得するには、以下の方法があります:

1. Docker Hub のウェブサイトを利用する:
   Docker Hub の該当イメージのページにアクセスし、「Tags」タブを確認します。ここで利用可能なタグの一覧を見ることができます。

2. Docker Hub API を使用する:
   curl コマンドなどを使って Docker Hub の API にアクセスし、タグ情報を取得できます。

   ```sh
   curl -L -s 'https://registry.hub.docker.com/v2/repositories/library/<イメージ名>/tags?page_size=1000' | jq '."results"[]["name"]'
   ```

   この方法では、jq コマンドを使って JSON 形式の応答からタグ名を抽出しています。

3. docker search コマンドを使用する:
   `docker search` コマンドでイメージを検索できますが、これはタグの一覧を提供しません。イメージの基本情報のみを表示します.

4. サードパーティのツールを使用する:
   `docker-tags` のようなサードパーティのシェルスクリプトを使用すると、指定したイメージのタグ一覧を取得できます.

   ```sh
   docker-tags <イメージ名>
   ```

   このスクリプトは Docker Hub の API を利用してタグ情報を取得し、表示します。

   [docker イメージのタグ一覧を表示するコマンドを作る #Docker - Qiita](https://qiita.com/UKIUKI_ENGINEER/items/9fa237cd937c9d329595)

5. docker pull コマンドを使用する:
   特定のタグを指定せずに `docker pull` コマンドを実行すると、利用可能なタグの一部が表示されることがあります。ただし、これは全てのタグを網羅するものではありません[1].

これらの方法を組み合わせることで、配布されている Docker イメージのタグのリストを効率的に取得できます。
特に Docker Hub の API を利用する方法(2 番目の方法)が最も包括的な情報を提供しますが、API の利用制限に注意が必要です。

### Google の distroless のタグ一覧

リストはここにある
<https://github.com/GoogleContainerTools/distroless?tab=readme-ov-file#what-images-are-available>

```sh
gcloud container images list-tags gcr.io/distroless/<イメージ名>
```

## Google の distroless に入っている Python や Node.js のバージョンはどうやって調べられますか?

マルチステートビルドで runner(production)イメージに Google の distroless を使おうと考えています。
開発イメージと distroless の Python や Node.js のマイナーバージョンまでをそろえたい。

のだが、結構難しい。

## distroless にはデバッグ用のイメージがある

```sh
docker run --rm -it gcr.io/distroless/base:debug
```

これで busybox につながる。

例えば base でないイメージでも

```sh
docker run --rm -it --entrypoint=sh gcr.io/distroless/nodejs22-debian12:debug
```

`FROM gcr.io/distroless/nodejs22-debian12:debug` で作ったイメージも同様に`--entrypoint=sh`で busybox に入れる。

参考: <https://github.com/GoogleContainerTools/distroless?tab=readme-ov-file#debug-images>

## 例えば gcr.io/distroless/nodejs22-debian12 のとき

npm は入ってないので、`npm run start` に書いてあるスクリプトを実行する必要があって、
で、gcr.io/distroless/nodejs22-debian12 は nodejs が起動するので、CMD には`/nodejs/bin/node` は書かない。

## Docker Content Trust (DCT)

```sh
export DOCKER_CONTENT_TRUST=1
```

にすると署名してないイメージが `docker run` できなくなる。
自分で作ったイメージも実行できなくなる。

```sh
docker trust key generate heiwa4126
```

カレントディレクトリに `heiwa4126.pub` ができる。
秘密鍵はどこ?

```sh
ls ~/.docker/trust/private
```

はい、`docker trust key generate`で作成した鍵を Docker Hub に登録することができます。以下に手順を説明します:

1. 鍵の生成:
   まず、`docker trust key generate`コマンドを使用して鍵を生成します[1][2][3]。

```sh
docker trust key generate your-name
```

このコマンドは秘密鍵を生成し、対応する公開鍵ファイル(your-name.pub)を現在のディレクトリに出力します[3]。

2. 公開鍵の Docker Hub への追加:
   生成した公開鍵を Docker Hub のリポジトリに追加します。これには`docker trust signer add`コマンドを使用します[2]。

```sh
docker trust signer add --key your-name.pub your-name your-dockerhub-username/your-repository:tag
```

このコマンドは、指定した Docker Hub リポジトリに対して、生成した公開鍵を信頼された署名者として追加します。

3. イメージの署名とプッシュ:
   鍵を登録した後、イメージを署名してプッシュすることができます。これには`docker trust sign`コマンドを使用するか、`DOCKER_CONTENT_TRUST=1`環境変数を設定してから`docker push`を実行します[2][4]。

```sh
docker trust sign your-dockerhub-username/your-repository:tag
```

または

```sh
export DOCKER_CONTENT_TRUST=1
docker push your-dockerhub-username/your-repository:tag
```

これらの手順を実行することで、`docker trust key generate`で作成した鍵を Docker Hub に登録し、その鍵を使用してイメージに署名することができます。
署名されたイメージは Docker Content Trust (DCT)が有効な環境でも実行可能になります[4]。

注意点として、鍵の管理は非常に重要です。特にルート鍵(root key)の紛失は回復不可能なので、安全な場所にバックアップを取ることをお勧めします[5]。

Citations:
[1] https://matsuand.github.io/docs.docker.jp.onthefly/engine/reference/commandline/trust_key_generate/
[2] https://matsuand.github.io/docs.docker.jp.onthefly/engine/security/trust/
[3] https://docs.docker.com/reference/cli/docker/trust/key/generate/
[4] https://yuya-hirooka.hatenablog.com/entry/2021/08/14/164518
[5] https://docs.docker.com/engine/security/trust/trust_key_mng/

**ローカルイメージに直接署名することはできません。イメージはまずリモートリポジトリにプッシュする必要があります**

Docker Content Trust (DCT) は、Docker イメージに対する信頼性を確保するための仕組みで、イメージのパブリックレジストリ(例えば Docker Hub)に対して署名を行うことを主に目的としています。しかし、ローカルイメージにも署名を行いたい場合、以下の手順で対応することが可能です。

1. **Notary サーバーのセットアップ**:
   Docker Content Trust は Notary サーバーを使用してイメージのメタデータを管理します。ローカルで Notary サーバーをセットアップする必要があります。以下のコマンドを使用して Docker Compose で Notary サーバーをセットアップできます。

   ```bash
   git clone https://github.com/theupdateframework/notary
   cd notary
   docker-compose up -d
   ```

2. **Docker デーモンの設定**:
   ローカルで署名されたイメージをプッシュするために、Docker デーモンが Notary サーバーを使用するように設定します。`/etc/docker/daemon.json` ファイルに以下の内容を追加します。

   ```json
   {
     "content-trust": {
       "notary-server": "http://localhost:4443"
     }
   }
   ```

   設定を反映するために Docker デーモンを再起動します。

   ```bash
   sudo systemctl restart docker
   ```

3. **イメージのタグ付け**:
   署名するイメージに適切なタグを付けます。タグには Notary サーバーのリポジトリ名を含めます。

   ```bash
   docker tag <your-image>:<tag> localhost:5000/<your-repo>:<tag>
   ```

4. **署名とプッシュ**:
   DCT を有効にしてイメージをプッシュします。以下のコマンドを実行して署名とプッシュを行います。

   ```bash
   export DOCKER_CONTENT_TRUST=1
   docker push localhost:5000/<your-repo>:<tag>
   ```

5. **イメージの検証**:
   署名されたイメージを検証するために、以下のコマンドを実行します。

   ```bash
   docker pull localhost:5000/<your-repo>:<tag>
   ```

これらの手順を踏むことで、ローカルイメージに対して Docker Content Trust を使用して署名することができます。

## Alpine の musl は 2024 年でもまだ不安定だったり遅かったりしますか?

2021 年の記事:
[軽量 Docker イメージに安易に Alpine を使うのはやめたほうがいいという話 - inductor's blog](https://blog.inductor.me/entry/alpine-not-recommended)

2024-07 の GTP-4o の答え

2024 年においても、Alpine Linux の musl には、glibc ベースのシステムと比較した場合にパフォーマンスや安定性に関するいくつかの懸念が残っています。musl はその軽量性とセキュリティ機能で高く評価されていますが、すべての使用ケースで glibc のパフォーマンスに完全には追いついていません。

1. **パフォーマンスの違い**: musl を使用すると、特定のシナリオで著しいパフォーマンス低下が発生することがあります。たとえば、musl を使用するアプリケーションは、システムコールの処理やライブラリの実装の違いにより、CPU 使用率が高くなり、応答時間が遅くなる可能性があります ​ ([Elixir Programming Language Forum](https://elixirforum.com/t/using-alpine-and-musl-instead-of-gnu-libc-affect-performance/57670))​​ ([GitHub](https://github.com/haproxytech/kubernetes-ingress/issues/541))​。HAProxy や Erlang などの特定のアプリケーションは、このようなパフォーマンスの欠点に気付きましたが、これらの違いを緩和するための作業とアップデートが進行中です ​ ([Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/729342/performance-issue-with-alpine-musl-library))​​ ([Alpine Linux Wiki](https://wiki.alpinelinux.org/wiki/Musl))​。
2. **安定性の懸念**: musl の特定の機能、例えばロケールサポートの実装は、glibc と比較して制限されています。このため、これらの機能に大きく依存するアプリケーションでは、機能が制限されたり追加の設定が必要となることがあります ​ ([Alpine Linux Wiki](https://wiki.alpinelinux.org/wiki/Musl))​。

リソース効率とセキュリティが最優先される環境では、musl は依然として有力な選択肢です。しかし、パフォーマンスが重要なアプリケーションに対しては、必要なパフォーマンスと安定性基準を満たしていることを確認するために、慎重な評価とテストが推奨されます。

[musl-locales - Alpine Linux packages](https://pkgs.alpinelinux.org/contents?name=musl-locales)

## すごい参考になる (`RUN --mount=type=`)

[2024 年版の Dockerfile の考え方&書き方 | フューチャー技術ブログ](https://future-architect.github.io/articles/20240726a/)

<https://docs.docker.com/reference/dockerfile/#example-cache-apt-packages> とか。

## docker pull でイメージが更新されないとき

debian:bookworm-slim (debian 12.9) が 12.10 になんだか更新されないで困ったときの話。

1. [debian Tags | Docker Hub](https://hub.docker.com/_/debian/tags?name=bookworm-slim) へ行く
2. OS/ARCH を選んで digest のリンクをクリック
3. Index digest の sha256 がわかるので `docker pull debian@sha256:xxxxx` xxxx のところを置き換えて実行
4. 終わったら `docker image prune` とかしておく。

## IMAGE ID

IMAGE ID は同じイメージでも docker ごとに異なるらしい。

比較が必要なら digest を得る。 `docker images --digests`

## ヘルスチェック

- <https://docs.docker.com/reference/dockerfile/#healthcheck>
- <https://docs.docker.jp/engine/reference/builder.html#healthcheck>

例えばこんな風に書く

```dockerfile
FROM python:3.9
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1
```

## 最新のコンテナ

最新のコンテナにするコマンドは特にないみたい。
`docker pull hoge:latest` ぐらい?
