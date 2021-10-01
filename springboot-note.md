
# チュートリアル

[ガイド - 公式サンプルコード](https://spring.pleiades.io/guides)

これ全部やればエキスパートになれると思う。


# MyBatis

[MyBatis – MyBatis 3 | イントロダクション](https://mybatis.org/mybatis-3/ja/index.html)

pom.xmlやbuild.gradeに追加

```xml
		<!-- MyBatis -->
		<dependency>
			<groupId>org.mybatis.spring.boot</groupId>
			<artifactId>mybatis-spring-boot-starter</artifactId>
			<version>2.1.4</version>
		</dependency>
		<!-- Model Mapper -->
		<dependency>
			<groupId>org.modelmapper.extensions</groupId>
			<artifactId>modelmapper-spring</artifactId>
			<version>2.3.9</version>
		</dependency>
```

- [Maven Repository: org.mybatis.spring.boot » mybatis-spring-boot-starter](https://mvnrepository.com/artifact/org.mybatis.spring.boot/mybatis-spring-boot-starter)
- [Maven Repository: org.modelmapper.extensions » modelmapper-spring](https://mvnrepository.com/artifact/org.modelmapper.extensions/modelmapper-spring)

エンティティクラスつくる。package com.example.domain.xxxx.model。Lombokの@Data

↑のレポジトリつくる。＠Mapperで。interfaceで。

↑のクラスと同じ名前の.xmlにSQL書く。

サービスのinterface書く。implも。
(これよくわからん。なぜ一旦抽象をつくるのか)



application.configにmybatis.mapper-location書く。

@Configurationのクラス作ってmodel mapper登録する。

サービスつくる。

コントローラを修正する。


[絶対分かるMyBatis！MyBatisで覚えるべきチェックルール25（中編） - Qiita](https://qiita.com/5zm/items/0864d6641c65f976d415)


# <where>

[MyBatis – MyBatis 3 | 動的 SQL](https://mybatis.org/mybatis-3/ja/dynamic-sql.html)

> where 要素は、内包するタグのどれかが結果を返すときだけ "WHERE" を挿入します。更に、内包するタグから返された結果が "AND" または "OR" で始まっていた場合はこれを削除します。




# 古いmavenやgradleを更新ってできるの?

時々セキュリティアップデートとか出てるのでgradlewなどのwrapperは更新できるのかチェック。
まあむやみに更新すると動かなくなるけど、それは別問題。

- [The Gradle Wrapper](https://docs.gradle.org/current/userguide/gradle_wrapper.html)

```
$ gradle --version
Gradle 6.9.1
(略)

$ ./gradlew --version
Gradle 6.8.3
(略)

$ gradle wrapper
(略)

$ ./gradlew --version
(略)
Gradle 6.9.1
(略)

$ git status
(略)
        modified:   gradle/wrapper/gradle-wrapper.jar
        modified:   gradle/wrapper/gradle-wrapper.properties
        modified:   gradlew
        modified:   gradlew.bat
```


# application.propertiesを切り替える

- [Spring Bootでapplication.propertiesを環境ごとに切り替える方法 - 知的好奇心](https://intellectual-curiosity.tokyo/2019/04/29/spring-boot%E3%81%A7application-properties%E3%82%92%E7%92%B0%E5%A2%83%E3%81%94%E3%81%A8%E3%81%AB%E5%88%87%E3%82%8A%E6%9B%BF%E3%81%88%E3%82%8B%E6%96%B9%E6%B3%95/)
- [Springのプロファイル機能、そしてSpring Bootのapplication.properties - Qiita](https://qiita.com/suke_masa/items/98b4c1b562ea6ec89bf7)


`application.properties`に、`spring.profiles.active`だけ書いて
`-Dspring.profiles.active=xxxxx`で切替えるのが普通らしい。

`application.properties`に書いた`spring.profiles.active`以外のプロパティは
共通で読まれるらしい。

環境変数 SPRING_PROFILES_ACTIVE もあり。

`--spring.profiles.active=`も使える。

`-D`は`-jar`の前。
`--spring.profiles.active=`は`-jar`の後。

サンプル作りました。
[heiwa4126/springboot-cmdline-hello1: Spring Bootでコマンドラインアプリのサンプル。加えてプロファイル切替の実験。](https://github.com/heiwa4126/springboot-cmdline-hello1)

参考:

- [7\.3\. Profiles](https://docs.spring.io/spring-boot/docs/2.5.5/reference/htmlsingle/#features.profiles)
- [12\.2\.6\. Set the Active Spring Profiles](https://docs.spring.io/spring-boot/docs/2.5.5/reference/htmlsingle/#features.profiles)
- [7\.3\. プロファイル](https://spring.pleiades.io/spring-boot/docs/2.5.4/reference/htmlsingle/#features.profiles) - 日本語
- [12\.2\.6\. アクティブ Spring プロファイルを設定する](https://spring.pleiades.io/spring-boot/docs/2.5.4/reference/htmlsingle/#features.profiles) - 日本語

Spring Bootのプロパティって1000以上もあるらしい。
[Spring Boot アプリケーションプロパティ設定一覧 \- リファレンス](https://spring.pleiades.io/spring-boot/docs/current/reference/html/application-properties.html)


# Spring Bootで非Webアプリは作れるの?

- [1\.5\. 非 Web アプリケーションを作成する](https://spring.pleiades.io/spring-boot/docs/current/reference/html/howto.html#howto.application.non-web-application) - うむ、わからん。
- [Spring Bootで簡単なコマンドラインアプリケーションを作成してみる \- Reasonable Code](https://reasonable-code.com/command-line-runner/)
- [Spring BootでCommandLineRunnerを使ってはいけない - Qiita](https://qiita.com/taka_22/items/7320642d1cafe88c7bf8)
- [1\.10\. ApplicationRunner または CommandLineRunner の使用](https://spring.pleiades.io/spring-boot/docs/current/reference/html/features.html#features.spring-application.command-line-runner)
- 