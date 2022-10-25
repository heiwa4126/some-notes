2022-10ごろの [Maven - Introduction to the POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html) 機械翻訳

- [POMとは何ですか？](#pomとは何ですか)
- [スーパーPOM](#スーパーpom)
- [最小限のPOM](#最小限のpom)
- [プロジェクトの継承](#プロジェクトの継承)
  - [例1](#例1)
  - [例2](#例2)
- [プロジェクトの集約](#プロジェクトの集約)
  - [例3](#例3)
  - [例4](#例4)
- [「プロジェクトの集約」対「プロジェクトの継承」](#プロジェクトの集約対プロジェクトの継承)
  - [例5](#例5)
- [プロジェクト補間と変数](#プロジェクト補間と変数)
  - [利用可能な変数](#利用可能な変数)
    - [プロジェクトモデルの変数](#プロジェクトモデルの変数)
    - [特殊な変数](#特殊な変数)
- [プロパティ](#プロパティ)
- [実際にやってみた](#実際にやってみた)

# POMとは何ですか？

プロジェクト・オブジェクト・モデルまたはPOMは、Mavenの基本的な作業単位です。
これはプロジェクトに関する情報および Maven がプロジェクトをビルドするために使用する設定の詳細を含む XML ファイルです。
ほとんどのプロジェクトのデフォルト値が含まれています。
例えば、ビルドディレクトリは target、ソースディレクトリは `src/main/java`、
テストソースディレクトリは `src/test/java`、などです。
タスクまたはゴールを実行するとき、MavenはカレントディレクトリにあるPOMを探します。
POMを読み込んで、必要な設定情報を取得し、ゴールを実行します。

POMで指定できる構成には、プロジェクトの依存関係、実行可能なプラグインまたはゴール、ビルドプロファイルなどがあります。
その他、プロジェクトのバージョン、説明、開発者、メーリングリストなどの情報も指定することができます。


# スーパーPOM

Super POMは、MavenのデフォルトのPOMです。 (訳注:要はデフォルト値です)

すべての POM は明示的に設定しない限り Super POM を継承し、
Super POM で指定された設定は、プロジェクト用に作成した POM に継承されることを意味します。

[Maven 3.6.3 の Super POM](https://maven.apache.org/ref/3.6.3/maven-model-builder/super-pom.html) は、Maven Core リファレンス・ドキュメントで参照できます。


# 最小限のPOM

POMの最小要件は以下の通りです。

- `プロジェクト` ルート
- `modelVersion` - 4.0.0 に設定する必要があります。
- `groupId` - プロジェクトのグループのid。
- `artifactId` - アーティファクト（プロジェクト）のid。
- `version` - 指定されたグループの下にあるアーティファクトのバージョン

以下はその例です。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
</project>
```

POMは、groupId、artifactId、およびversionを設定する必要があります。
これら3つの値は、プロジェクトの完全修飾されたアーティファクト名を形成します。
これは、`<groupId>:<artifactId>:<version>` という形式をとります。
上記の例では、完全修飾型アーティファクト名は「com.mycompany.app:my-app:1」です。

また、最初のセクションで述べたように、設定の詳細が指定されていない場合、Maven はそのデフォルト値を使用します。
これらのデフォルト値の1つにパッケージングタイプがあります。
すべてのMavenプロジェクトには、パッケージングタイプがあります。
POMで指定されていない場合、デフォルト値の「jar」が使用されます。

さらに、最小限のPOMでは、リポジトリが指定されていないことがわかります。
最小限のPOMを使用してプロジェクトをビルドすると、Super POMのリポジトリ設定を継承することになります。
したがって、Mavenが最小限のPOMの依存関係を見たとき、これらの依存関係はSuper POMで指定されたhttps://repo.maven.apache.org/maven2 からダウンロードされることがわかるでしょう。


# プロジェクトの継承

マージされるPOMの要素は以下の通りです。

- 依存関係
- 開発者と貢献者
- プラグインのリスト (レポートを含む)
- プラグインの実行と一致するID
- プラグインの設定
- リソース

Super POMはプロジェクト継承の一例ですが、以下の例で示すように、POMに親要素を指定することで独自の親POMを導入することも可能です。

## 例1

**シナリオ**
例として、前回の成果物である com.mycompany.app:my-app:1 を再利用し、
別の成果物である com.mycompany.app:my-module:1 を導入することにしましょう。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-module</artifactId>
  <version>1</version>
</project>
```

そして、そのディレクトリ構造を以下のように指定します:

```
.
 |-- my-module
 |   `-- pom.xml
 `-- pom.xml
```

注：
`my-module/pom.xml` は `com.mycompany.app:my-module:1` の POM で、
`pom.xml` は `com.mycompany.app:my-app:1` の POM である。

**解決方法**
ここで、`com.mycompany.app:my-app:1` を `com.mycompany.app:my-module:1` の親アーティファクトにする場合、`com.mycompany.app:mymodule:1` の POM を以下の構成に変更しなければならないでしょう。

`com.mycompany.app:my-module:1` の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <parent>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1</version>
  </parent>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-module</artifactId>
  <version>1</version>
</project>
```

親セクションが追加されていることに注意してください。
このセクションでは、どのアーティファクトがPOMの親であるかを指定することができます。
そして、親POMの完全修飾されたアーティファクト名を指定することで、そうします。
このセットアップにより、モジュールは親 POM のプロパティの一部を継承できるようになりました。

また、モジュールの groupId や version を親と同じにしたい場合は、モジュールの POM から groupId や version の ID を削除します。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <parent>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1</version>
  </parent>
 
  <artifactId>my-module</artifactId>
</project>
```

これにより、モジュールは親POMのgroupIdやバージョンを継承することができます。


## 例2

**シナリオ**
ただし、親プロジェクトがすでにローカルリポジトリにインストールされているか、
その特定のディレクトリ構造（親のpom.xmlはモジュールのpom.xmlより1つ上のディレクトリ）にある場合は、うまくいくでしょう。

しかし、親がまだインストールされておらず、次の例のようなディレクトリ構造になっている場合はどうでしょうか?

```xml
.
 |-- my-module
 |   `-- pom.xml
 `-- parent
     `-- pom.xml
```

**解決方法**
このディレクトリ構造（あるいは他のディレクトリ構造）に対応するためには、親セクションに `<relativePath>` 要素を追加する必要があります。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <parent>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1</version>
    <relativePath>../parent/pom.xml</relativePath>
  </parent>
 
  <artifactId>my-module</artifactId>
</project>
```

# プロジェクトの集約

「プロジェクトの集約」は「プロジェクトの継承」と似ています。
しかし、モジュールから親POMを指定するのではなく、親POMからモジュールを指定します。
そうすることで、親プロジェクトはそのモジュールを知ることができるようになり、親プロジェクトに対してMavenコマンドを実行すると、そのMavenコマンドが親のモジュールに対しても実行されるようになるのです。
プロジェクト集約を行うには、以下のようにする必要があります。

- 親POMのパッケージを "pom"に変更する。
- 親POMに、そのモジュール（子POM）のディレクトリを指定する。

## 例3

**シナリオ**
以前のオリジナルアーティファクトのPOMとディレクトリ構造がある場合
(訳注:例1参照)。

`com.mycompany.app:my-app:1`  の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
</project>
```

`com.mycompany.app:my-module:1` の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-module</artifactId>
  <version>1</version>
</project>
```

ディレクトリ構造
```
.
 |-- my-module
 |   `-- pom.xml
 `-- pom.xml
```

**解決方法**
もし、my-moduleをmy-appに集約するのであれば、my-appを修正すればよいことになります。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
  <packaging>pom</packaging>
 
  <modules>
    <module>my-module</module>
  </modules>
</project>
```

改訂版 `com.mycompany.app:my-app:1` では、
packaging セクションと modules セクションが追加されました。
パッケージングについては、その値を「pom」とし、
モジュールセクションについては、`<module>my-module</module>`という要素を設けています。`<module>`の値は、`com.mycompany.app:my-app:1` から `com.mycompany.app:my-module:1` の POM への相対パスです（実際には、モジュールの artifactId をモジュールディレクトリ名として使用します）。

これで、Maven コマンドが com.mycompany.app:my-app:1 を処理するたびに、その同じ Maven コマンドが com.mycompany.app:my-module:1 に対しても実行されるようになります。さらに、いくつかのコマンド（特にゴール）は、プロジェクト集約を異なる方法で処理します。


## 例4

**シナリオ**
しかし、ディレクトリ構造を次のように変更したらどうでしょう。(訳注:例2参照)

```
.
 |-- my-module
 |   `-- pom.xml
 `-- parent
     `-- pom.xml
```
親POMはどのようにモジュールを指定するのでしょうか?

**解決方法**
答えは、例3と同じように、モジュールへのパスを指定します。

```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
  <packaging>pom</packaging>
 
  <modules>
    <module>../my-module</module>
  </modules>
</project>
```

# 「プロジェクトの集約」対「プロジェクトの継承」

複数のMavenプロジェクトがあり、それらがすべて似たような設定になっている場合、それらの似たような設定を取り出して親プロジェクトを作ることで、プロジェクトをリファクタリングすることができます。そのため、Mavenプロジェクトにその親プロジェクトを継承させるだけで、それらの構成が全てに適用されることになります。

また、一緒にビルドや処理を行うプロジェクト群がある場合、親プロジェクトを作成し、その親プロジェクトにそれらのプロジェクトをモジュールとして宣言させることができます。
そうすることで、親プロジェクトだけをビルドすれば、あとは自動的にビルドされるようになります。

しかし、もちろん、プロジェクトの継承とプロジェクトの集約の両方を行うことができます。
つまり、モジュールに親プロジェクトを指定させ、同時にその親プロジェクトにMavenプロジェクトをモジュールとして指定させることができるのです。
3つのルールをすべて適用する必要があるだけです。

- すべての子POMで、親POMが誰であるかを指定する。
- 親POMのパッケージングを "pom"に変更する。
- 親POMに、モジュール（子POM）のディレクトリを指定する。

## 例5

**シナリオ**
以前のオリジナルアーティファクトのPOMを再度みてみましょう。

`com.mycompany.app:my-app:1`  の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
</project>
```

`com.mycompany.app:my-module:1` の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-module</artifactId>
  <version>1</version>
</project>
```

ディレクトリ構造はこうです
```xml
.
 |-- my-module
 |   `-- pom.xml
 `-- parent
     `-- pom.xml
```

**解決方法**
プロジェクトの継承と集約の両方を行うには、3つのルールをすべて適用すればよい。

`com.mycompany.app:my-app:1`  の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <version>1</version>
  <packaging>pom</packaging>
 
  <modules>
    <module>../my-module</module>
  </modules>
</project>
```

`com.mycompany.app:my-module:1` の POM
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
 
  <parent>
    <groupId>com.mycompany.app</groupId>
    <artifactId>my-app</artifactId>
    <version>1</version>
    <relativePath>../parent/pom.xml</relativePath>
  </parent>
 
  <artifactId>my-module</artifactId>
</project>
```

# プロジェクト補間と変数

Mavenが推奨するプラクティスの1つは、「同じことを繰り返さない」ことです。
しかし、複数の異なる場所で同じ値を使用する必要がある場合があります。値が一度だけ指定されるように支援するために、MavenではPOMで独自の変数と事前定義された変数の両方を使用することができます。

例えば、project.version 変数にアクセスするには、次のように参照します。

```xml
  <version>${project.version}</version>
```

注意点としては、これらの変数は上記のように継承された後に処理されることです。
つまり、親プロジェクトが変数を使用する場合、最終的に使用されるのは親ではなく子プロジェクトでの定義となります。

## 利用可能な変数

### プロジェクトモデルの変数

モデルのフィールドのうち、単一の値要素であるものはすべて変数として参照することができます。例えば、
`${project.groupId}`,
`${project.version}`,
`${project.build.sourceDirectory}`
などです。プロパティの全リストは、POMリファレンスを参照してください。

これらの変数は、すべて "project. "という接頭辞で参照されます。
また、pom.を接頭辞とする参照や、接頭辞を完全に省略した参照も見られますが、これらの形式は現在では非推奨であり、使用すべきではありません。

### 特殊な変数

| 変数                  | 意味                                                                        |
| --------------------- | --------------------------------------------------------------------------- |
| project.basedir       | 現在のプロジェクトが存在するディレクトリです。                              |
| project.baseUri       | 現在のプロジェクトが存在するディレクトリを URI で表します。Maven 2.1.0 以降 |
| maven.build.timestamp | ビルドの開始を示すタイムスタンプ (UTC)。Maven 2.1.0-M1より                  |

フォーマットのパターンは SimpleDateFormat の API ドキュメントで与えられているルールに従わなければなりません。このプロパティが存在しない場合、フォーマットのデフォルトは、例で既に与えられた値です。

# プロパティ

また、プロジェクトで定義されている任意のプロパティを変数として参照することができます。次のような例で考えてみましょう。

```xml
<project>
  ...
  <properties>
    <mavenVersion>3.0</mavenVersion>
  </properties>
 
  <dependencies>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-artifact</artifactId>
      <version>${mavenVersion}</version>
    </dependency>
    <dependency>
      <groupId>org.apache.maven</groupId>
      <artifactId>maven-core</artifactId>
      <version>${mavenVersion}</version>
    </dependency>
  </dependencies>
  ...
</project>
```

# 実際にやってみた

継承で
親POMの
packaging typeはpomでないとダメ。
アーティファクトがjarとかのやつは親にできない。

継承で
親POMがあるjarをインストールして、
それに依存するプロジェクトを書くと
元の親POMもレポジトリに必要(ローカルでもリモートでもいい)。

↑package時にeffective POMにできればいいのでは。
[java - Maven package effective pom - Stack Overflow](https://stackoverflow.com/questions/33365633/maven-package-effective-pom)

集約は
プロジェクト全部おなじゴールしか指定できない。
mod-a/ではinstall
mod-b/ではfatjarを作る
みたいのはできない。

↑build profilesでできるのでは?
[java - Maven Aggregate POM with Goal? - Stack Overflow](https://stackoverflow.com/questions/4230553/maven-aggregate-pom-with-goal)
