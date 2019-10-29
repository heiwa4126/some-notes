# Dockerメモ

- [Dockerメモ](#docker%e3%83%a1%e3%83%a2)
- [インストール](#%e3%82%a4%e3%83%b3%e3%82%b9%e3%83%88%e3%83%bc%e3%83%ab)
  - [メモ](#%e3%83%a1%e3%83%a2)
- [便利なコマンド](#%e4%be%bf%e5%88%a9%e3%81%aa%e3%82%b3%e3%83%9e%e3%83%b3%e3%83%89)
- [dockerの「ボリューム」](#docker%e3%81%ae%e3%83%9c%e3%83%aa%e3%83%a5%e3%83%bc%e3%83%a0)
- [JDKなしでJavaをコンパイル](#jdk%e3%81%aa%e3%81%97%e3%81%a7java%e3%82%92%e3%82%b3%e3%83%b3%e3%83%91%e3%82%a4%e3%83%ab)
- [hello-worldのDockfile](#hello-world%e3%81%aedockfile)
- [GoLangでサーバを書いてimageにしてみる](#golang%e3%81%a7%e3%82%b5%e3%83%bc%e3%83%90%e3%82%92%e6%9b%b8%e3%81%84%e3%81%a6image%e3%81%ab%e3%81%97%e3%81%a6%e3%81%bf%e3%82%8b)
- [Red Hat Universal Base Image](#red-hat-universal-base-image)
- [Dockerでsyslog](#docker%e3%81%a7syslog)


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
