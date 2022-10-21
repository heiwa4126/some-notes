# mavenメモ

# ドキュメント

まあいろいろあるけど、ここらから始めるのがいちばん。

- [Maven – Maven in 5 Minutes](https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html)
- [Maven – Maven Getting Started Guide](https://maven.apache.org/guides/getting-started/)
- [Maven – Guide to Configuring Maven](https://maven.apache.org/guides/mini/guide-configuring-maven.html)
- [Maven – Introduction to the POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html)
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



# 外部の依存関係を使用するにはどうすればよいですか?

[How do I use external dependencies?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-use-external-dependencies)
の機械翻訳+x

例として挙げたPOMの中に、dependenciesという要素があることにもうお気づきかと思います。
実は、これまでずっと外部依存を使用していたのですが、ここではこの仕組みについてもう少し詳しく説明します。
より詳細な紹介は、(依存関係の仕組みの紹介)[https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html]をご覧ください。

pom.xml の依存関係セクションには、プロジェクトがビルドするために必要な外部依存関係がすべてリストアップされています（コンパイル時、テスト時、実行時など、どの時点でその依存関係が必要であるかにかかわらず）。
今、私たちのプロジェクトは、JUnitだけに依存しています（分かりやすくするために、リソースフィルタリングに関するものはすべて削除しました）。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>jar</packaging>
 
  <name>Maven Quick Start Archetype</name>
  <url>http://maven.apache.org</url>
 
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</project>
```

各外部依存関係には、少なくとも groupId, artifactId, version, scope の4つを定義する必要があります。
groupId、artifactId、および version は、その依存関係を構築したプロジェクトの pom.xml で指定されたものと同じものです。
scope 要素は、プロジェクトがどのようにその依存関係を使用するかを示し、コンパイル、テスト、ランタイムなどの値を指定できます。依存関係に指定できるすべてのものの詳細については、[Project Descriptor Reference](https://maven.apache.org/ref/current/maven-model/maven.html)を参照してください。

依存関係のメカニズム全体についての詳細は、「[依存関係のメカニズム入門](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html)」を参照してください。

依存関係に関するこの情報があれば、Maven はプロジェクトをビルドする際に依存関係を参照できるようになります。
Mavenはどこから依存関係を参照するのでしょうか？
Maven はローカルリポジトリ (${user.home}/.m2/repository がデフォルトの場所) を検索して、すべての依存関係を見つけます。
前のセクションで、プロジェクトのアーティファクト (my-app-1.0-SNAPSHOT.jar) をローカルリポジトリにインストールしました。
いったんそこにインストールされると、他のプロジェクトはその pom.xml に依存関係の情報を追加するだけで、その jar を依存関係として参照できるようになります。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-other-app</artifactId>
  ...
  <dependencies>
    ...
    <dependency>
      <groupId>com.mycompany.app</groupId>
      <artifactId>my-app</artifactId>
      <version>1.0-SNAPSHOT</version>
      <scope>compile</scope>
    </dependency>
  </dependencies>
</project>
```

他の場所でビルドされた依存関係についてはどうでしょう?
どのようにローカルリポジトリに取り込まれるのでしょうか?
プロジェクトがローカルリポジトリで利用できない依存関係を参照するときはいつでも、Maven は依存関係をリモートリポジトリからローカルリポジトリにダウンロードします。
おそらく、最初のプロジェクトをビルドしたときに、Maven が多くのものをダウンロードしていることに気づいたでしょう (これらのダウンロードは、プロジェクトをビルドするために使用するさまざまなプラグインの依存関係でした)。
デフォルトでは、Maven が使用するリモートリポジトリは https://repo.maven.apache.org/maven2/ にあります（そして閲覧できます）。
デフォルトのリモートリポジトリの代わりに、またはそれに加えて使用する独自のリモートリポジトリ（会社のセントラルリポジトリなど）を設定することも可能です。
リポジトリに関する詳細については、[リポジトリ入門](https://maven.apache.org/guides/introduction/introduction-to-repositories.html)を参照してください。

プロジェクトに別の依存関係を追加してみましょう。例えば、コードにロギングを追加し、依存関係として log4j を追加する必要があるとします。
まず、log4jのgroupId, artifactId, versionが何であるかを知る必要があります。
Maven Centralの適切なディレクトリは、/maven2/log4j/log4jと呼ばれます。
そのディレクトリの中に、maven-metadata.xmlというファイルがあります。
log4j用のmaven-metadata.xmlは、以下のような感じです。

```xml
<metadata>
  <groupId>log4j</groupId>
  <artifactId>log4j</artifactId>
  <version>1.1.3</version>
  <versioning>
    <versions>
      <version>1.1.3</version>
      <version>1.2.4</version>
      <version>1.2.5</version>
      <version>1.2.6</version>
      <version>1.2.7</version>
      <version>1.2.8</version>
      <version>1.2.11</version>
      <version>1.2.9</version>
      <version>1.2.12</version>
    </versions>
  </versioning>
</metadata>
```

このファイルから、必要なgroupIdは「log4j」、artifactIdは「log4j」であることがわかります。
バージョンの値もいろいろありますが、ここでは最新版の1.2.12を使用します（maven-metadata.xmlファイルによっては、現在のリリースバージョンを指定することもできます：リポジトリメタデータリファレンスを参照）。
maven-metadata.xmlファイルの横に、log4jライブラリの各バージョンに対応するディレクトリが表示されます。
この中には、実際のjarファイル（例：log4j-1.2.12.jar）、pomファイル（これは依存関係のpom.xmlで、さらに依存関係があるかどうかや他の情報を示します）、別の maven-metadata.xml ファイルが含まれます。また、それぞれに対応する md5 ファイルがあり、これらのファイルの MD5 ハッシュが含まれています。これを使用して、ライブラリを認証したり、既に使用している特定のライブラリのバージョンを把握したりすることができます。

必要な情報がわかったので、pom.xml に依存関係を追加することができます。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>jar</packaging>
 
  <name>Maven Quick Start Archetype</name>
  <url>http://maven.apache.org</url>
 
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.11</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>log4j</groupId>
      <artifactId>log4j</artifactId>
      <version>1.2.12</version>
      <scope>compile</scope>
    </dependency>
  </dependencies>
</project>
```
ここで、プロジェクトをコンパイル（mvn compile）すると、Mavenがlog4jの依存関係をダウンロードしてくれるのがわかります。

# プラグインはどのように使用するのですか?

[How do I use plugins?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_use_plugins) の機械翻訳

Mavenプロジェクトのビルドをカスタマイズしたい場合、プラグインを追加したり再設定したりすることで行います。

この例では、JDK 5.0ソースを許可するようにJavaコンパイラーを設定します。これは、POMに追加するのと同じくらい簡単です。

```xml
...
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-compiler-plugin</artifactId>
      <version>3.3</version>
      <configuration>
        <source>1.5</source>
        <target>1.5</target>
      </configuration>
    </plugin>
  </plugins>
</build>
...
```

Mavenのすべてのプラグインが依存関係に似ていることにお気づきだと思いますが、ある意味そうです。このプラグインは自動的にダウンロードされて使用され、要求があれば特定のバージョンも使用されます (デフォルトでは最新のものが使用されます)。

コンフィギュレーション要素は与えられたパラメータをコンパイラープラグインからのすべてのゴールに適用します。
上記の場合、コンパイラープラグインはすでにビルドプロセスの一部として使用されており、これは単に設定を変更するだけです。
また、プロセスに新しいゴールを追加したり、特定のゴールを設定することも可能です。
これについては、[ビルドライフサイクルの紹介](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)を参照してください。

プラグインに対してどのような設定が可能かを調べるには、プラグインリストを参照して、使用しているプラグインとゴールに移動します。
プラグインの利用可能なパラメータの設定方法に関する一般的な情報については、[プラグインの設定ガイド](https://maven.apache.org/guides/mini/guide-configuring-plugins.html)をご覧ください。


# Plugin Management

[Plugin Management](https://maven.apache.org/pom.html#plugin-management)の機械翻訳

pluginManagement は、プラグインと一緒に表示される要素です。
プラグイン管理は、この特定のプロジェクトビルドのプラグイン情報を設定するのではなく、このビルドを継承したプロジェクトビルドを設定することを目的としていることを除いて、ほとんど同じ方法でプラグイン要素を含んでいます。
しかし、これは、子プロセスまたは現在の POM の plugins 要素内で実際に参照されているプラグインを設定するだけです。
子プロセスは、pluginManagement の定義を上書きするあらゆる権利を有します。

(pluginManagementの内容は子POMで上書きできる、ということか?)

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  ...
  <build>
    ...
    <pluginManagement>
      <plugins>
        <plugin>
          <groupId>org.apache.maven.plugins</groupId>
          <artifactId>maven-jar-plugin</artifactId>
          <version>2.6</version>
          <executions>
            <execution>
              <id>pre-process-classes</id>
              <phase>compile</phase>
              <goals>
                <goal>jar</goal>
              </goals>
              <configuration>
                <classifier>pre-process</classifier>
              </configuration>
            </execution>
          </executions>
        </plugin>
      </plugins>
    </pluginManagement>
    ...
  </build>
</project>
```

これらの仕様をplugins要素に追加した場合、単一のPOMにのみ適用されます。
しかし、pluginManagement要素の下に適用すると、**このPOMと**、ビルドにmaven-jar-pluginを追加するすべての継承POMは、同様にpre-process-classesの実行を取得することになります。
そのため、すべての子POM.xmlに上記のようなゴチャゴチャを含めるのではなく、以下のようにするだけでよいのです。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">
  ...
  <build>
    ...
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
      </plugin>
    </plugins>
    ...
  </build>
</project>
```

(継承したいものだけpluginManagement要素に書けばいい、
ということか?)

おそらく自分自身でもoverrideできるのでは。


# フェーズにゴールを追加する

[Introduction to the Build Lifecycle - Plugins](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html) の機械翻訳

フェーズにゴールを追加する2つ目の方法は、プロジェクトでプラグインを構成することです。
プラグインは、Maven にゴールを提供するアーティファクトです。
さらに、プラグインは 1 つ以上のゴールを持つことができ、各ゴールはそのプラグインの能力を表します。

例えば、コンパイラプラグインは、compileとtestCompileという2つのゴールを持ちます。
前者はメインコードのソースコードをコンパイルし、後者はテストコードのソースコードをコンパイルします。

後のセクションで説明するように、プラグインには、ゴールをどのライフサイクル・フェーズにバインドするかを示す情報を含めることができます。
プラグインを追加するだけでは十分な情報にならないことに注意しましょう。
ビルドの一部として実行させたいゴールも指定しなければなりません。

設定されたゴールは、選択されたパッケージングからすでにライフサイクルにバインドされているゴールに追加されます。
複数のゴールが特定のフェーズにバインドされている場合、パッケージングのものが最初に実行され、次にPOMで設定されたものが実行されるという順序が使用されます。
`<executions>`要素を使用すると、特定の目標の順序をより詳細に制御できることに注意してください。

例えば、Modelloプラグインは、デフォルトでそのゴール `modello:java`をgenerate-sourcesフェーズにバインドします（注：modello:javaゴールは、Javaソースコードを生成するのです）。
ですから、Modello プラグインを使用して、モデルからソースを生成させ、それをビルドに組み込むには、POM の `<build>` の `<plugins>` セクションに以下を追加することになります。

```xml
...
 <plugin>
   <groupId>org.codehaus.modello</groupId>
   <artifactId>modello-maven-plugin</artifactId>
   <version>1.8.1</version>
   <executions>
     <execution>
       <configuration>
         <models>
           <model>src/main/mdo/maven.mdo</model>
         </models>
         <version>4.0.0</version>
       </configuration>
       <goals>
         <goal>java</goal>
       </goals>
     </execution>
   </executions>
 </plugin>
...
```

なぜ `<executions>` 要素があるのか不思議に思うかもしれません。
それは、必要なら同じゴールを異なる設定で複数回実行できるようにするためです。
別々の実行ファイルに ID を与えることで、継承やプロファイルの適用時に ゴールの設定をマージするか、追加の実行ファイルにするかを制御できます。

特定のフェーズにマッチする複数の実行が与えられると、それらは**POMで指定された順序で実行され**、**継承された実行が最初に実行されます**。

さて、modello:javaの場合、generate-sourcesのフェーズでのみ意味を持ちます。
しかし、いくつかのゴールは複数のフェーズで使われることがあり、賢明なデフォルトがない場合があります。
そのような場合は、自分でフェーズを指定することができます。
たとえば、現在時刻をコマンドラインに出力するゴール display:time があり、 それを process-test-resources フェーズで実行してテストの開始時刻を示すとします。これは、次のように設定します。

```xml
...
 <plugin>
   <groupId>com.mycompany.example</groupId>
   <artifactId>display-maven-plugin</artifactId>
   <version>1.0</version>
   <executions>
     <execution>
       <phase>process-test-resources</phase>
       <goals>
         <goal>time</goal>
       </goals>
     </execution>
   </executions>
 </plugin>
...
```
