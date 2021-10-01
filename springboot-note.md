
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


