
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

↑のレポジトリつくる。＠Mapperで。interfaceで

↑のクラスと同じ名前の.xmlにSQL書く。クラス

application.configにmybatis.mapper-location書く。

JavaConfigでmodel mapper登録する。
