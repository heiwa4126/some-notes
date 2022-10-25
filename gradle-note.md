
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


Hello world的なもの
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

```powershell
mkdir demo3 ; cd demo3
gradle init --type java-application `
--incubating `
--dsl groovy `
--test-framework junit `
--project-name demo3 `
--package com.example.demo3
./gradlew -q run
```
