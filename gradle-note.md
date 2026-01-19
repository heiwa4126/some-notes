[Installing Gradle](https://docs.gradle.org/current/userguide/installation.html#installing_manually)

```bash
sudo mkdir -p /opt/gradle
sudo chmod $UID /opt/gradle
cd /opt/gradle
curl -LO https://downloads.gradle-dn.com/distributions/gradle-7.5.1-bin.zip
unzip gradle-7.5.1-bin.zip
ln -sf gradle-7.5.1 current
```

`/opt/gradle/current/bin` にパスかエリアス

とりあえず

```bash
PATH=$PATH:/opt/gradle/current/bin ; hash -r
gradle -version
```

Hello world 的なもの

```bash
mkdir demo1 ; cd demo1
```

```
$ gradle init --type java-application

Select build script DSL:
  1: Groovy
  2: Kotlin
Enter selection (default: Groovy) [1..2]

Generate build using new APIs and behavior (some features may change in the next minor release)? (default: no) [yes, no]
Select test framework:
  1: JUnit 4
  2: TestNG
  3: Spock
  4: JUnit Jupiter
Enter selection (default: JUnit Jupiter) [1..4]

Project name (default: demo1):
Source package (default: demo1): com.example.demo1

> Task :init
Get more help with your project: https://docs.gradle.org/7.5.1/samples/sample_building_java_applications.html

BUILD SUCCESSFUL in 1m 29s
2 actionable tasks: 2 executed
```

```bash
./gradlew build
./gradlew run
```

```bash
gradle help --task :init
```

bash 版

```bash
mkdir demo2 ; cd demo2
gradle init --type java-application \
--incubating \
--dsl groovy \
--test-framework junit \
--project-name demo2 \
--package com.example.demo2
./gradlew -q run
```

PowerShell 版

```powershell
mkdir demo3 ; cd demo3
gradle init --type java-application `
--incubating `
--dsl groovy `
--test-framework junit `
--project-name demo3 `
--package com.example.demo3
.\gradlew -q run
```

# おまけ kotlin

```bash
mkdir demo1 ; cd demo1
gradle init --type kotlin-application \
--incubating \
--dsl kotlin \
--test-framework kotlintest \
--package com.example.demo1 \
--project-name demo1
./gradlew -q run
```

.gitignore は
[https://www.toptal.com/developers/gitignore/api/gradle,kotlin,visualstudiocode](https://www.toptal.com/developers/gitignore/api/gradle,kotlin,visualstudiocode)
で置き換え。

とりあえず
`app/build.gradle.kts`の dependencies から guava だけはずしておく。
(便利だけどデカいからなあ)

## executable Jar

まず `app/build.gradle.kts` に

```kotlin
tasks.jar {
  manifest {
     attributes["Main-Class"] = "com.example.demo1.AppKt"
  }
}
```

を書き加える。

```bash
./gradlew build
java -jar ./app/build/libs/app.jar
```

Jar の中身見ると

```
$ jar -tvf ./app/build/libs/app.jar
     0 Wed Oct 26 14:21:12 JST 2022 META-INF/
    62 Wed Oct 26 14:21:12 JST 2022 META-INF/MANIFEST.MF
    52 Wed Oct 26 14:07:22 JST 2022 META-INF/app.kotlin_module
     0 Wed Oct 26 14:07:22 JST 2022 com/
     0 Wed Oct 26 14:07:22 JST 2022 com/example/
     0 Wed Oct 26 14:07:22 JST 2022 com/example/demo1/
   713 Wed Oct 26 14:07:22 JST 2022 com/example/demo1/App.class
   753 Wed Oct 26 14:07:22 JST 2022 com/example/demo1/AppKt.class
```

[Maven Repository: commons-codec » commons-codec » 1.15](https://mvnrepository.com/artifact/commons-codec/commons-codec/1.15)
いれて md5sum を意味なく計算させてみる。

`java -jar` の方は NoClassDefFoundError になるので

`app/build.gradle.kts` に

```kotlin
tasks.jar {
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
    manifest {
        attributes["Main-Class"] = "com.example.demo1.AppKt"
    }
    from(configurations.compileClasspath.get().map {if (it.isDirectory()) it else zipTree(it)})
}
```

duplicatesStrategy はファイルをコピーする時のポリシー

このへん参照。

- [Gradle 7 requires duplicatesStrategy for "fake" duplicates · Issue #17236 · gradle/gradle](https://github.com/gradle/gradle/issues/17236)
- [DuplicatesStrategy (Gradle API 7.5.1)](https://docs.gradle.org/current/javadoc/org/gradle/api/file/DuplicatesStrategy.html)

できる Jar は Java よりも若干大きい(Kotlin の標準ライブラリのぶん)。

# dependencies の apiとimplementation

- api - maven の compile スコープ実行時、コンパイル時、テスト時に必要。
- implementation - maven の runtime スコープ実行時、テスト時に必要。

# vscodeでgradleプロジェクトのimportの補完が効かない

まず
java.autobuild.enabled を false にする。
次に
Java Project の…のところから clean workspace を選ぶ(時間がかかる)。

これにより
build.gradle の右クリックで Reload Projects が効くようになるので、
build.gradle を変更するたびに Reload Projects を選ぶ。

(以下葛藤)

いやなんか build.gradle の変更するたびに clean workspace を実行しないとダメみたい。なんだこれ。

"clean workspace"は Java Project の…のところにあります。

java.autobuild.enabled を false にしたら
build.gradle の右クリックで Reload project が効くようになった。

(以下嘘)

なぜかそういうときが時々ある(再現度が低い)。うまくいくときもあるのでよくわからない。

どうも開いたディレクトリに build.gradle がないとダメみたいだけど...

なので

```bash
mkdir hello1 ; cd hello1
gradle init --type java-application \
--incubating \
--dsl groovy \
--test-framework junit \
--project-name hello1 \
--package com.example.hello1
```

で作った場合、

- app ディレクトリを vscode で開く。
- または hello1 ディレクトリを vscode で開き、app ディレクトリを「フォルダをワークスペースに追加」する。(以下オプション)「ワークスペースを名前を付けて保存する」で hello1.code-workspace を hello1 ディレクトリ直下に保存する。

という手順でなんとかする。

参考: [Java project management in Visual Studio Code](https://code.visualstudio.com/docs/java/java-project)
