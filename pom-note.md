[Maven - Introduction to the POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html) の機械翻訳



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
