# JAVA関係ノート

JAVAめんどくさい。

- [JAVA関係ノート](#java関係ノート)
- [Tomcatの新し目のやつをRHELに入れたときに参考にした記事](#tomcatの新し目のやつをrhelに入れたときに参考にした記事)
- [tomcatで不要なwebapps](#tomcatで不要なwebapps)
- [JAVAのCLASSPATH](#javaのclasspath)
- [headlessとは](#headlessとは)
- [Ubuntuで開発](#ubuntuで開発)
- [Gradleインストール](#gradleインストール)
- [Gradleチュートリアル](#gradleチュートリアル)
  - [実行](#実行)
  - [実行できるjarを作る その1](#実行できるjarを作る-その1)
  - [実行できるjarを作る その2](#実行できるjarを作る-その2)
- [Gradle参考リンク](#gradle参考リンク)
- [Groovyチュートリアル](#groovyチュートリアル)
- [Kotlinチュートリアル](#kotlinチュートリアル)
- [Spring Boot チュートリアル](#spring-boot-チュートリアル)


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

TODO: SDKMANも考慮する

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

# Gradleチュートリアル

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

例えば(これは普通でない方法)
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

普通はこっち。
```
./gradlew installDist
build/install/demo/bin/demo
```
でもOK.


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

[com.google.common.base.Strings#repeat](https://guava.dev/releases/19.0/api/docs/com/google/common/base/Strings.html#repeat(java.lang.String,%20int))を使って、Hello worldの上下に罫線を引く。

`src/main/java/demo/App.java`

```java
/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package demo;

import com.google.common.base.Strings; // <-here

public class App {
  public String getGreeting() {
    return "Hello world.";
  }

  public static void main(String[] args) {
    String hr = Strings.repeat("-",12);  // <-here
    System.out.println(hr);  // <-here
    System.out.println(new App().getGreeting());
    System.out.println(hr);  // <-here
  }
}
```

`bundle.gradle`はguavaの依存のとこだけ`implementation`に戻して、`./gradlew run`すると

```
------------
Hello world.
------------
```

で、
```
./gradlew jar
java -jar ./build/libs/demo.jar
```
すると、
「`com/google/common/base/Strings`が見つからない」
ってエラーが出る。

ここで、`shadow plugin` を使う。

`bundle.gradle`を編集して
```diff
@@ -12,6 +12,8 @@ plugins {

     // Apply the application plugin to add support for building a CLI application.
     id 'application'
+
+    id 'com.github.johnrengelman.shadow' version '6.0.0'
 }
@@ -32,3 +35,14 @@ application {
     // Define the main class for the application.
     mainClassName = 'demo.App'
 }
+
+jar {
+    manifest {
+        attributes 'Main-Class': 'demo.App'
+    }
+}
+
+// Minimizing an shadow JAR
+shadowJar {
+    minimize()
+}
```

参考:
- [shadow plugin - Getting Started](https://imperceptiblethoughts.com/shadow/getting-started/#default-java-groovy-tasks)
- [Gradle: 依存ライブラリ入りのjarを作る - Qiita](https://qiita.com/suin/items/641c1c1ec9ab5447221e)

`./gradlew tasks`でshadow関係が増えてるのを確認して、
```
./gradlew shadowJar
java -jar ./build/libs/demo-all.jar
```
**`demo.jar`ではなくて`demo-all.jar`なのに注意。**

`shadowDistZip`と`shadowDistTar`もあるけど、
jarでなくていいなら
`distZip`,`distTar`で十分だと思う。
minimizeができるのは大きいかも。

実験:
```
$ ./gradlew distTar shadowDistTar distZip shadowDistZip
## `./gradlew build`でもOK
$ ls -sh1 ./build/distributions/demo*.{tar,zip}
120K ./build/distributions/demo-shadow.tar
 92K ./build/distributions/demo-shadow.zip
3.0M ./build/distributions/demo.tar
2.6M ./build/distributions/demo.zip
```

# Gradle参考リンク

- [いい感じのbuild.gradleが書きたい - Qiita](https://qiita.com/kuro46/items/1e42a54c9a52c1f0381c)
- [GradleでのJavaのビルドとテスト - GitHub Docs](https://docs.github.com/ja/actions/language-and-framework-guides/building-and-testing-java-with-gradle)


# Groovyチュートリアル

Hello worldぐらいは書いてみる。

- [The Apache Groovy programming language - Documentation](https://groovy-lang.org/documentation.html#gettingstarted)
- [1. index - Apache Groovyチュートリアル](https://koji-k.github.io/groovy-tutorial/)

インストールとGroovy shell起動
```
sdk install groovy
groovysh
```
参考:
- [The Apache Groovy programming language - Install Groovy](https://groovy-lang.org/install.html#SDKMAN)
- [Available SDKs - SDKMAN! the Software Development Kit Manager](https://sdkman.io/sdks#groovy)

Groovy shellで
```
println "Hello world!"
# cntl+dで抜ける
```

`hello.groovy`を作る
```grooby
println "Hello world!"
```
で、

```sh
groovy Hello.groovy
# or 
groovy Hello
```
または
```sh
groovyc Hello.groovy
groovy Hello
```

...あんまり楽しくない。

出来たclassの中身見てみる。
```
$ javap Hello.class
Compiled from "Hello.groovy"
public class Hello extends groovy.lang.Script {
  public static transient boolean __$stMC;
  public Hello();
  public Hello(groovy.lang.Binding);
  public static void main(java.lang.String...);
  public java.lang.Object run();
  protected groovy.lang.MetaClass $getStaticMetaClass();
}

$ javap -v Hello.class
(略)
```

なんとなく何やってるかは想像がつく。

実行可能なjarを作る方法は想像もつかないのでGradleでやる。

```
mkdir xxx
cd !$
gradle init # application, groovyを選ぶ
./gradlew installDist
```
で`build/install/`の下みるとantとか入ってる。groovy-allの依存が多いらしい。

もっとチューニングする。


# Kotlinチュートリアル

Hello worldぐらいは書いてみる。

- [Tutorials - Kotlin Programming Language](https://kotlinlang.org/docs/tutorials/)
  - [Working with the Command Line Compiler - Kotlin Programming Language](https://kotlinlang.org/docs/tutorials/command-line.html)
  - [Kotlin Koans - Kotlin Programming Language](https://kotlinlang.org/docs/tutorials/koans.html)

```sh
sdk install kotlin
```

```
$ kotlin -version
Kotlin version 1.3.72-release-468 (JRE 1.8.0_262-b10)
```

```sh
mkdir hello-kotlin
cd !$
emacs hello.kt
```

`hello.kt`
```kotlin
fun main(args: Array<String>) {
  println("Hello, World!")
}
```

```sh
kotlinc hello.kt -include-runtime -d hello.jar
java -jar hello.jar
```

これはわかりやすい。jarの中身を覗いてみる。
```
$ jar -xvf hello.jar META-INF/MANIFEST.MF HelloKt.class

$ cat META-INF/MANIFEST.MF
Manifest-Version: 1.0
Created-By: JetBrains Kotlin
Main-Class: HelloKt

$ javap HelloKt.class
Compiled from "hello.kt"
public final class HelloKt {
  public static final void main(java.lang.String[]);
}

$ javap -v HelloKt.class
(略)
```

groovyよりは面白そうだなあ。
shellが`kotlinc-jvm`ってタイプしにくいぞ。

# Spring Boot チュートリアル

- [Spring Boot 入門 - 公式ドキュメントの日本語訳](https://spring.pleiades.io/spring-boot/docs/current/reference/html/getting-started.html)
- [Spring | ガイド - コードサンプル](https://spring.pleiades.io/guides#tutorials)
  - [チュートリアル | Spring Boot と Kotlin を使用した Web アプリケーションの構築](https://spring.pleiades.io/guides/tutorials/spring-boot-kotlin/)
  - [Spring Initializr](https://start.spring.io/)
- [Spring Boot Maven プラグインのドキュメント - 日本語訳](https://spring.pleiades.io/spring-boot/docs/current/maven-plugin/reference/html/#repackage)
- [Spring Boot Gradle プラグインリファレンスガイド - ドキュメント](https://spring.pleiades.io/spring-boot/docs/current/gradle-plugin/reference/html/)
- [Spring Web MVC サーブレットスタック - ドキュメント](https://spring.pleiades.io/spring/docs/5.2.8.RELEASE/spring-framework-reference/web.html#mvc)

```sh
sdk install springboot
spring --version  # Spring CLI v2.3.2.RELEASE
```

[Spring Boot 入門 - 公式ドキュメントの日本語訳](https://spring.pleiades.io/spring-boot/docs/current/reference/html/getting-started.html)
終わった。簡単。
mvn + JAVAでjarまで出来る。

次は
[入門 | Spring Boot JAR を WAR へ変換](https://spring.pleiades.io/guides/gs/convert-jar-to-war/)
...あれ。詰んだ。

Gradleでwarのを試してみる。まずGradleの普通の
[Getting Started | Building an Application with Spring Boot](https://spring.io/guides/gs/spring-boot/)

なんとか動くwarまで出来たけど、手順がめんどうだなあ。
