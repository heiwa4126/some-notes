# mavenメモ

# ドキュメント

まあいろいろあるけど、ここから始めるのがいちばん。

- [Maven – Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)
- 
- [Maven – POM Reference](https://maven.apache.org/pom.html)



# Mavenとは？

[What is Maven?](https://maven.apache.org/guides/getting-started/index.html#What_is_Maven)の機械翻訳(+x)

Mavenは一見すると様々なものであるように見えますが、一言で言うと、プロジェクトのビルドインフラにパターンを適用し、ベストプラクティスの使用における明確な道筋を提供することで理解力と生産性を促進しようとするものです。Mavenは本質的にプロジェクト管理・理解ツールであり、管理を支援する方法を提供します。

- ビルド
- ドキュメンテーション
- レポーティング
- 依存関係
- SCM (ソフトウェア構成管理 software configuration management）
- リリース
- 配布

Mavenの背景についてもっと知りたい場合は、「[Mavenの哲学](https://maven.apache.org/background/philosophy-of-maven.html)」と「[Mavenの歴史](https://maven.apache.org/background/history-of-maven.html)」をご覧ください。それでは、Mavenを使用することで、どのようなメリットがあるのかについて説明します。


# vscodeであったほうがよさそうな拡張機能

このへんは自動で入る
- Debugger for Java
- Extension Pack for Java

このへんは手動もしくは「入れる?」って聞いてくるやつ
- Dependency Analytics
- Maven for Java
- Project Manager for Java
- SonarLint

# archetype:generate の archetypeArtifactId

maven標準は
- [Apache Maven Archetypes – Maven Archetypes](https://maven.apache.org/archetypes/index.html)
- [Maven – Introduction to Archetypes](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html#provided-archetypes)

よくみる `maven-archetype-quickstart` は
[Maven Quickstart Archetype – Maven Quickstart Archetype](https://maven.apache.org/archetypes/maven-archetype-quickstart/)

で、
`mvn archetype:generate` の `-DarchetypeGroupId=` で
標準でないarchetypeも選択出来て、たとえば
[deangerber/java11-junit5-archetype: Maven archetype to create a project configured for Java 11 and using JUnit 5.](https://github.com/deangerber/java11-junit5-archetype)


自分でarchetypeを作るには
- [Maven – Guide to Creating Archetypes](https://maven.apache.org/guides/mini/guide-creating-archetypes.html)
- [Guide to Maven Archetype | Baeldung](https://www.baeldung.com/maven-archetype)


# JUnit5

- [JUnit5 使い方メモ - Qiita](https://qiita.com/opengl-8080/items/efe54204e25f615e322f) リンク切れ多いけど参考になる
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)

あと
- [JUnitのアサーションライブラリHamcrest,AssertJ比較 - Qiita](https://qiita.com/disc99/items/31fa7abb724f63602dc9)
- [JunitでHamcrestを使用する理由](https://codechacha.com/ja/how-to-use-hamcrest-in-junit/)
- [Java Hamcrest](http://hamcrest.org/JavaHamcrest/)
- [Hamcrest Tutorial](http://hamcrest.org/JavaHamcrest/tutorial)


# ライフサイクル

これが参考になる
- [Built\-in Lifecycle Bindings](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html#built-in-lifecycle-bindings)
- [Mavenの「よくわらない」を解消 ！ ライフサイクル、フェーズ、バインドの概念 | dawaan](https://dawaan.com/maven-life-cycle-in-depth/)

デフォルトのデフォルトライフサイクルは(ややこしい)
```xml
<packaging>jar</packaging>
```
で、
[Plugin bindings for jar packaging](https://maven.apache.org/ref/3.8.6/maven-core/default-bindings.html#Plugin_bindings_for_jar_packaging)

```bash
mvn package
# 上は下とだいたい同じ
mvn compile test jar:jar
```




```xml
 <defaultGoal>clean package</defaultGoal>
```


# 階層

- ライフサイクル
  - フェーズ
    - ゴール

`mvn` の後ろに指定できるのは フェーズかゴール。

フェーズを指定するとき
ライフサイクル名は指定できない
そのライフサイクルの一連のフェーズのうち、指定フェーズより前のすべてのフェーズも実行される
 (例えば`mvn deploy`はライフサイクルdefaultのフェーズpackageの実行)

ゴールは単体で実行される


# デフォルトのライフサイクル

デフォルトのライフサイクルで実行される最も一般的なフェーズを紹介します(全部ではない)。
([Maven – Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)から引用)

- validate: プロジェクトが正しく、必要な情報がすべて利用可能であることを検証します。
- compile: プロジェクトのソースコードをコンパイルする。
- test: 適当なユニットテストフレームワークを使って、コンパイルされたソースコードをテストする。これらのテストは、コードのパッケージやデプロイメントなしに実行できるはず。
- package: コンパイルされたコードを受け取り、JARのような配布可能な形式でパッケージ化する。
- integration-test: パッケージを処理し、必要であれば統合テストを実行できる環境に配備する。
- verify: パッケージが有効であり、品質基準を満たしていることを確認するためのあらゆるチェックを実行する。
- install: パッケージをローカルリポジトリにインストールし、他のプロジェクトの依存関係としてローカルで使用する。
- deploy: 統合またはリリース環境で行われ、他の開発者やプロジェクトと共有するために最終的なパッケージをリモートリポジトリにコピーします。

フェーズは、実際には基本的な目標にマッピングされます。
フェーズごとに実行される特定のゴールは、プロジェクトのパッケージングタイプに依存します。例えば、
プロジェクトのタイプが JAR の場合、package は jar:jar を実行し、
プロジェクトのタイプが WAR の場合、war:war を実行します。
