# mavenメモ

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



  
