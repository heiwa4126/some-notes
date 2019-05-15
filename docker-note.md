# Dockerメモ

- [Dockerメモ](#dockerメモ)
- [インストール](#インストール)
- [JDKなしでjava](#jdkなしでjava)

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

# JDKなしでjava

あちこちから出ている
OpenJDKを試してみたかったので
`HelloWorld.java`をコンパイル&runしてみる。

参考:
- [Dockerで色んなJDKを試す - Qiita](https://qiita.com/kikutaro/items/d140f519253f276b94e0)
- [adoptopenjdk's Profile - Docker Hub](https://hub.docker.com/u/adoptopenjdk)

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
docker run -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest \
 java HelloWorld
```

実行
``` bash
docker run -v $(pwd):/tmp -u $UID:$(id -g) -w /tmp adoptopenjdk/openjdk11:latest \
 java HelloWorld
```

実行例
```
Hello World!!
version: 11.0.3
vender: AdoptOpenJDK
vm: OpenJDK 64-Bit Server VM
```

何回も繰り返すと、どんどんコンテナが貯まるので
```
docker rm $(docker ps -q -a)
```
でとりあえず終わったものは消しておく。

