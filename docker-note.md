# Dockerメモ

- [Dockerメモ](#dockerメモ)
- [インストール](#インストール)
  - [メモ](#メモ)
- [便利なコマンド](#便利なコマンド)
- [dockerの「ボリューム」](#dockerのボリューム)
- [dockerが実際にどれぐらいディスクを使っているか](#dockerが実際にどれぐらいディスクを使っているか)
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
  - [install](#install)
- [CentOS7でpodman](#centos7でpodman)
- [minikube](#minikube)
- [rootless mode](#rootless-mode)
- [BuildKit](#buildkit)
- [dockerのtag](#dockerのtag)
- [dockerでコンテナが実行されているときに、元のイメージを書き換えるとどうなる?](#dockerでコンテナが実行されているときに元のイメージを書き換えるとどうなる)
- [いらんイメージを手早く消す](#いらんイメージを手早く消す)


# インストール

Docker CE (コミュニティエディション)をインストールしてみる。

公式サイトの文書に従うだけ。簡単。

[Get Docker CE for Ubuntu | Docker Documentation](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

```sh
sudo docker run hello-world
```
まで実行して、動作確認できたら

[Post-installation steps for Linux | Docker Documentation](https://docs.docker.com/install/linux/linux-postinstall/)

で、「sudoなしでdocker実行」ができるようになる。(一旦logoutする必要があるかも)

```sh
docker run hello-world
# or
docker run --rm hello-world
```

ここまで終わったら、
終了したコンテナは消しておく。
```sh
docker rm $(docker ps -aq)
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


# dockerが実際にどれぐらいディスクを使っているか

```bash
sudo du -hs /var/lib/docker/
```


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
$ CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o clock -trimpath -ldflags="-w -s" clock.go
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

RHEL7とかだとDocker社がRed Hatと喧嘩して
snapしかDockerを使う方法がないみたい。


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
- [How to run docker-compose up -d at system start up? - Stack Overflow](https://stackoverflow.com/questions/43671482/how-to-run-docker-compose-up-d-at-system-start-up) - ホスト起動時にdocker-compose upする手法いろいろ。
- [Compose における環境変数 — Docker-docs-ja 17.06 ドキュメント](https://docs.docker.jp/compose/environment-variables.html) - yamlの中で環境変数を参照する方法や.envについて。

## install

ディストリのdocker-composeを削除。

あとは以下に従う。
[Docker Compose のインストール — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/compose/install.html#linux)

要は
1. githubのreleaseページからバイナリを落とす。
2. `/usr/local/bin/docker-compose`とかの名前で置いて、実行権限をつける。



# CentOS7でpodman

```
sudo yum install podman
```

podman-dockerパッケージをインストールすればdockerコマンドのふりができる。
manも入ってるけどメンテされてないのかまともに動かない。
```
$ man docker
man: can't open /usr/share/man/man1/./docs/build/man/podman.1: No such file or directory
No manual entry for docker
```

で
```
$ podman run hello-world
Trying to pull registry.access.redhat.com/hello-world...
  name unknown: Repo not found
Trying to pull registry.redhat.io/hello-world...
  unable to retrieve auth token: invalid username/password: unauthorized: Please login to the Red Hat Registry using your Customer Portal credentials. Further instructions can be found here: https://access.redhat.com/RegistryAuthentication
...
```

先にregistry.redhat.ioを探しに行くのをやめさせるには?
あるいはdocker.ioを先にするには?

man podman-pullに書いてあった。`/etc/containers/registries.conf`だ。


docker-composeに相当するものは
[containers/podman-compose: a script to run docker-compose.yml using podman](https://github.com/containers/podman-compose)。

python3なので、pipでインストール。
```
sudo yum install python3
pip3 install --user -U pip
# 一旦logout
pip install --user -U podman-compose
hash -r
podman-compose --help
```

podman-composeには`--version`が無い。

podman-composeにはpsサブコマンドがない。
podman-composeにはlogsサブコマンドがない。

podman的にはKubernetesを使え、ということらしい。

参考: [Podman で Compose したかったらどうするの？ - Qiita](https://qiita.com/thirdpenguin/items/c9e58c27e96f02b0a96d)


# minikube

AWS上のUbuntu 18.04LTSにminikubeを作ってみる。

参考: [勉強用にminikubeをEC2上で実行する - Qiita](https://qiita.com/masahiko_katayose/items/34605e04b4a81610e668)

```sh
sudo apt-get install docker.io conntrack
# kubectl(kubernetesのCLI操作ツール) を導入
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# minkubeを導入
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/
# minikube開始
sudo -i
minikube start --vm-driver=none
```


実行例
```
$ minikube version
minikube version: v1.15.1
commit: 23f40a012abb52eff365ff99a709501a61ac5876

$ sudo -i

# minikube start --vm-driver=none

* Ubuntu 18.04 (xen/amd64) 上の minikube v1.15.1
* 設定を元に、 none ドライバを使用します
* コントロールプレーンのノード minikube を minikube 上で起動しています
* Running on localhost (CPUs=2, Memory=3933MB, Disk=29715MB) ...
* OS は Ubuntu 18.04.5 LTS です。
* Docker 19.03.14 で Kubernetes v1.19.4 を準備しています...
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
! kubectl か minikube コマンドを独自のユーザーとして使用するには、そのコマンドの再配置が必要な場合があります。たとえば、独自の設定を上書きするには、以下を実行します
*
  - sudo mv /root/.kube /root/.minikube $HOME
  - sudo chown -R $USER $HOME/.kube $HOME/.minikube
*
* これは環境変数 CHANGE_MINIKUBE_NONE_USER=true を設定して自動的に行うこともできます
* Kubernetes コンポーネントを検証しています...
* 有効なアドオン: storage-provisioner, default-storageclass
* Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```

停止は`minikube stop`

なんか一般ユーザでも動かせそうだが
`the 'none' driver must be run as the root user`
と言われて動かない。

ステータスは
```
sudo -i minikube status
```
`-i`オプションがいる。

[Hello Minikube | Kubernetes](https://kubernetes.io/ja/docs/tutorials/hello-minikube/)

```
minikube dashboard --url=false
```
毎回違うポートになるな... 固定できないのか。


# rootless mode

v.19で試験的導入。v.20で正規機能。

- [Run the Docker daemon as a non-root user (Rootless mode) | Docker Documentation](https://docs.docker.com/engine/security/rootless/)
- [root ユーザー以外による Docker デーモン起動（rootless モード） | Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/engine/security/rootless/)


Dockerそのもののインストール: [Install Docker Engine on Ubuntu | Docker Documentation](https://docs.docker.com/engine/install/ubuntu/)
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
```
sudo apt install uidmap
```

systemdのuserモードでdockerが上がる。ログインするとdockerが起動する。
ここ `/home/YOURHOME/.config/systemd/user/docker.service`

```sh
systemctl --user status docker.service
```
で確認。


PATHを通すのと環境変数1個。.bashrcとかに入れる
```
export PATH=/home/heiwa/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
```

docker-composeは?

[DockerにRootlessモードが入ったぞ！という話 - Qiita](https://qiita.com/inductor/items/75db0c1c0d49646dd68a)

# BuildKit

最近のdockerなら
```
DOCKER_BUILDKIT=1 docker build .
```
でOK。

参考:
- [BuildKit でイメージ構築 — Docker-docs-ja 19.03 ドキュメント](https://docs.docker.jp/develop/develop-images/build_enhancements.html)
- [BuildKit によるイメージ構築 | Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/develop/develop-images/build_enhancements/) 同じ内容
- [BuildKitによる高速でセキュアなイメージビルド](https://www.slideshare.net/AkihiroSuda/buildkit) - 「使えない」と書いてある機能は使えるようになってる模様
- [Docker 18.09 新機能 (イメージビルド&セキュリティ) | by Akihiro Suda | nttlabs | Medium](https://medium.com/nttlabs/docker-v18-09-%E6%96%B0%E6%A9%9F%E8%83%BD-%E3%82%A4%E3%83%A1%E3%83%BC%E3%82%B8%E3%83%93%E3%83%AB%E3%83%89-%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3-9534714c26e2) 同じ内容(同じ筆者?)ちょっと詳しい。よみやすい
- [Docker の BuildKit を使ってセキュアなビルドを試す - Qiita](https://qiita.com/takasp/items/56e1399a484ed5bfaade)



さらにつおいbuildx
[Docker Buildx | Docker ドキュメント](https://matsuand.github.io/docs.docker.jp.onthefly/buildx/working-with-buildx/)


# dockerのtag

1つのイメージに複数のタグをつけることができる。
`docker images` (or `docker image ls`) で同じIDのイメージが複数あるように見える。


# dockerでコンテナが実行されているときに、元のイメージを書き換えるとどうなる?

予想では
「Repository=<none>になって残るので何も起きない」
「i-nodeを掴んでいるので何も起きない(Windowsとかは知らない)」
だと思われる。

素のAlpineにttyでつないでいるところをscratchに書き換えてみる。

...予想通りだった。
おそらくrepository:tag が image IDかハッシュに変換されて読み込んでるのであろう。

じゃいま動いてるイメージをrmiするとどうなる。

```
$ docker rmi b11fdd96e58e
Error response from daemon: conflict: unable to delete b11fdd96e58e (cannot be forced) - image is being used by running container 726262b5a406

# いちおう
$ docker rmi b11fdd96e58e --force
Error response from daemon: conflict: unable to delete b11fdd96e58e (cannot be forced) - image is being used by running container 726262b5a406
```

rmiできないし、forceオプションでもダメ。
ある意味当然か。


# いらんイメージを手早く消す

```sh
docker image prune -f
```
[使用していない Docker オブジェクトの削除（prune） — Docker-docs-ja 20.10 ドキュメント](https://docs.docker.jp/config/pruning.html)

`prune`には他いろんなものが消せるオプションがあるので↑参考。
