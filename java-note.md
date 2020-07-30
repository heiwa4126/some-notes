# JAVA関係ノート

JAVAめんどくさい。

- [JAVA関係ノート](#java関係ノート)
- [Tomcatの新し目のやつをRHELに入れたときに参考にした記事](#tomcatの新し目のやつをrhelに入れたときに参考にした記事)
- [tomcatで不要なwebapps](#tomcatで不要なwebapps)
- [JAVAのCLASSPATH](#javaのclasspath)
- [headlessとは](#headlessとは)
- [Ubuntuで開発](#ubuntuで開発)
- [Gradleインストール](#gradleインストール)
- [gradleチュートリアル](#gradleチュートリアル)
  - [実行](#実行)
  - [実行できるjarを作る その1](#実行できるjarを作る-その1)
  - [実行できるjarを作る その2](#実行できるjarを作る-その2)


# Tomcatの新し目のやつをRHELに入れたときに参考にした記事

* [CentOS 7にTomcat9/JDK8の開発環境を構築する - Qiita](https://qiita.com/mkyz08/items/97802acb6911f0173e7c)

自分は OpenJDK(RHELの配布)と、ApacheのTomcat9で設定した。
「参考」というよりはほぼそのままコピペ(tomcat.seviceとか)。

- /optの下に展開する
- /etc/profile.dで全ユーザにJAVA_HOME,CATALINA_HOMEを設定する
- 「Managerにログイン」の設定方法が載ってる

のがよい。

logrotateだけ追加したけど、
tomcat9では自前のloggerがちゃんとしてるので
いらないかもしれない。

単にJava Servletコンテナを使うんだったらjettyのほうがいいんじゃないかとは思うけど、諸般の事情があって辛い。

下の
[Tomcat の初期設定まとめ - Qiita](https://qiita.com/hidekatsu-izuno/items/ab604b6c764b5b5a86ed)
も参照

# tomcatで不要なwebapps

デフォルトで入っていることが多い(ディストリ版ではそうでもない)、
不要＆セキュリティに問題のあるwebapps

- ROOT
- docs
- examples
- manager
- host-manager

ディレクトリごと削除 または どこかに移動する。

参考:
- [Tomcat の初期設定まとめ - Qiita](https://qiita.com/hidekatsu-izuno/items/ab604b6c764b5b5a86ed)


# JAVAのCLASSPATH

実行時に指定するのがキツイ。

# headlessとは

グラフィックスサポートが無いバージョン。
Linix serverでX11がなくても使える。

# Ubuntuで開発

サーバなら
```sh
apt install openjdk-11-jdk-headless
# or
apt install openjdk-8-jdk-headless
```

例)
```
$ sudo apt install openjdk-11-jdk-headless

$ java -version
openjdk version "11.0.8" 2020-07-14
OpenJDK Runtime Environment (build 11.0.8+10-post-Ubuntu-0ubuntu118.04.1)
OpenJDK 64-Bit Server VM (build 11.0.8+10-post-Ubuntu-0ubuntu118.04.1, mixed mode, sharing)

$ javac -version
javac 11.0.8
```

# Gradleインストール

SDKMAN!入れる
参考: [Installation - SDKMAN! the Software Development Kit Manager](https://sdkman.io/install)

```sh
sudo apt install zip unzip -y
curl -s "https://get.sdkman.io" | bash
```
メッセージに従ってパスを通して、バージョンだけ確認

```
$ sdk version
==== BROADCAST =================================================================
* 2020-07-29: Micronaut 2.0.1 released on SDKMAN! #micronautfw
* 2020-07-28: Jbang 0.34.1 released on SDKMAN! Checkout https://github.com/jbangdev/jbang/releases/tag/v0.34.1. Follow @jbangdev #jbang
* 2020-07-26: Jbang 0.34.0 released on SDKMAN! Checkout https://github.com/jbangdev/jbang/releases/tag/v0.34.0. Follow @jbangdev #jbang
================================================================================

SDKMAN 5.8.5+522
```

Gradle入れる。
参考: [Gradle | Installation](https://gradle.org/install/)

```sh
sdk install gradle 6.5.1
```

バージョンの確認は
- [Gradle | Releases](https://gradle.org/releases/)
- [Releases · gradle/gradle](https://github.com/gradle/gradle/releases)

から。インストールできたら、これもバージョン確認。
```sh
gradle -version
```

# gradleチュートリアル

参考: [Building Java Applications](https://guides.gradle.org/building-java-applications/)

プロジェクトフォルダ作って、移動。
```sh
mkdir -p ~/works/gradle/demo
cd !$
gradle init
```

最初に `applicaion`と`Java`を選び、
あとはデフォルト値でリターンキーを押すだけ。
```
Select type of project to generate:
  1: basic
  2: application
  3: library
  4: Gradle plugin
Enter selection (default: basic) [1..4] 2

Select implementation language:
  1: C++
  2: Groovy
  3: Java
  4: Kotlin
  5: Swift
Enter selection (default: Java) [1..5] 3
(略)
```

参考: [Build Init Plugin](https://docs.gradle.org/current/userguide/build_init_plugin.html)

Unix/Windowsで作業できるようにgradle wrapperがプロジェクトルートに出来るので、以下は`gradle`コマンドの代わりに、`./gradlew`を使う。

実行は
```
./gradlew run
```
で `Hello world.`が表示される。

ここまでが本家のドキュメント
[Building Java Applications](https://guides.gradle.org/building-java-applications/)
に書いてあること(かなり飛ばした)。

## 実行

```
./gradlew build
```
で
`./build/distributions/`に、
ディストリビューションパッケージが
tarとzipが出来てるので、
例えば
```sh
mkdir x
cd x
tar xvf ../build/distributions/demo.tar
demo/bin/demo
```
とかすると
```
Hello world!
```
が表示される。依存jarファイルもそのまま入っている。


## 実行できるjarを作る その1

```sh
./gradlew jar
java -jar ./build/libs/demo.jar
```
としても実行できない。実行例:

```
$ java -jar ./build/libs/demo.jar
no main manifest attribute, in ./build/libs/demo.jar
```

- これはhello worldで外部jarとかいらないのでとりあえず消す
- 自動生成される`./build/tmp/jar/MANIFEST.MF`に`Main-Class`が抜けている

ので`build.groove`を編集する。のまえに
```sh
git init
git add --all
git commit -am 'Inital commit'
```
しておく。

以下の要領で`build.gradle`を編集。
```diff
diff --git a/build.gradle b/build.gradle
index a91a718..dd8997f 100644
--- a/build.gradle
+++ b/build.gradle
@@ -22,7 +22,7 @@ repositories {

 dependencies {
     // This dependency is used by the application.
-    implementation 'com.google.guava:guava:29.0-jre'
+    testImplementation 'com.google.guava:guava:29.0-jre'

     // Use JUnit test framework
     testImplementation 'junit:junit:4.13'
@@ -32,3 +32,9 @@ application {
     // Define the main class for the application.
     mainClassName = 'demo.App'
 }
+
+jar {
+    manifest {
+        attributes 'Main-Class': 'demo.App'
+    }
+}
```

で、
```sh
./gradlew jar
java -jar ./build/libs/demo.jar
```

実行例:
```
$ java -jar ./build/libs/demo.jar
Hello world.
```

## 実行できるjarを作る その2

「その1」で「依存するjarなし」にして作ったわけだけど、
そんなプロジェクトはあるとも思えないので、
最初から入ってた
[Google Guava - Wikipedia](https://ja.wikipedia.org/wiki/Google_Guava)
を使ったApp.javaに変えてみる。






