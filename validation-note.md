# JavaScript のバリデーションのメモ

圧倒的に流行っているのは ajv らしい。

- [ajv vs io-ts vs joi vs typebox vs validator vs zod | npm trends](https://npmtrends.com/ajv-vs-io-ts-vs-joi-vs-typebox-vs-validator-vs-zod)

どうも express-validator, Fastify, webpack で使われてるので(未確認)、知らずに使われているらしい。

## 比較や一覧

[moltar/typescript-runtime-type-benchmarks: 📊 Benchmark Comparison of Packages with Runtime Validation and TypeScript Support](https://github.com/moltar/typescript-runtime-type-benchmarks?tab=readme-ov-file#readme)

あと ajv は早い。
[gcanti/io-ts-benchmarks](https://github.com/gcanti/io-ts-benchmarks?tab=readme-ov-file#results)

## ajv の使い方のメモ

1. JSON Schema 書く。JTD(JSON Type Definition) も使えるけど、なんか遅い感じ
2. (TypeScript なら) 型を書く。ここが二度手間
3. `const ajv = new Ajv({...options}); const validate = ajv.compile(schema);`
4. `validate(object)`
5. JTD には `ajv.compileParser()` と `ajv.complie.compileSerializer()` もある。<https://ajv.js.org/api.html#ajv-compileparser-schema-object-json-string-any>

で、compile は起動時に毎回必要。

JDT ならスキーマから型を導出するユーティリティ JTDDataType がある。
型ガードしてくれる JSONSchemaType,JTDSchemaType がある。
[Using with TypeScript | Ajv JSON schema validator](https://ajv.js.org/guide/typescript.html)

validate() だけは Ajv 不要のスタンドアローンコードを作成でき、毎回 compile は不要になる。
[Standalone validation code | Ajv JSON schema validator](https://ajv.js.org/standalone.html)
スタンドアローンコードは複数スキーマを束ねられるけど、スキーマ間でコードが共有されない。

### スキーマはちょっとづつ追加できる

`$id`さえちゃんとしていれば addSchema()で追加していけるらしい。
<https://ajv.js.org/api.html#ajv-addschema-schema-object-object-key-string-ajv>
にサンプルが。

### `ajv compile` で `--code-esm` が使える、と書いてあるけど使えない

- [Standalone validation code | Ajv JSON schema validator](https://ajv.js.org/standalone.html)
- [Standalone esm option \`--code-esm\` is not recognized · Issue #2354 · ajv-validator/ajv](https://github.com/ajv-validator/ajv/issues/2354)

### '$schema' を書かないと

draft-7 として扱われるらしい。
<https://ajv.js.org/json-schema.html#draft-07>

> draft-07 の方がパフォーマンスが良い。後のバージョンの新機能が必要でなければ、このドラフトを使った方がより効率的にコードを生成できるだろう。

## ajv 本家以外の参考リンク

- [JSON Schema や Ajv と TypeScript の型を紐づけるときの考え方や技術 | blog.ojisan.io](https://blog.ojisan.io/ajv-to-type/)
- [TypeScript, JSON Schema, Ajv の組み合わせを考える | blog.ojisan.io](https://blog.ojisan.io/typescript-json-schema-ajv/)
- [Ajv × JTD で JSON の型定義とバリデータを同時に得る](https://zenn.dev/ningensei848/articles/getting-started-with-ajv-on-jtd)
- [Ajv v7 から email 等のフォーマットをチェックする場合には ajv-formats を入れる必要があるようです - ダメ元エンジニアのお勉強おメモ](https://rasp.hateblo.jp/entry/2021/06/27/231827)

## ajv の感想

JSON Schema と JTD の学習コストが高い。

## Hono のバリデータ

[honojs/middleware: monorepo for Hono third-party middleware/helpers/wrappers](https://github.com/honojs/middleware)の packages/ の下にある \*-validator

- [middleware/packages/arktype-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/arktype-validator)
- [middleware/packages/class-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/class-validator)
- [middleware/packages/conform-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/conform-validator)
- [middleware/packages/effect-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/effect-validator)
- [middleware/packages/typebox-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/typebox-validator)
- [middleware/packages/typia-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/typia-validator)
- [middleware/packages/valibot-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/valibot-validator)
- [middleware/packages/zod-validator at main · honojs/middleware · GitHub](https://github.com/honojs/middleware/tree/main/packages/zod-validator)

よく使われてるのは zod らしい。
[@hono/zod-validator - npm](https://www.npmjs.com/package/@hono/zod-validator)

## Express.js のバリデータ

express-validator を使うことが多いらしい。

## Fastify のバリデータ

デフォルトは Ajv らしい。
[Validation-and-Serialization | Fastify](https://fastify.dev/docs/latest/Reference/Validation-and-Serialization/)

JSON Schema を直接書かずに、Typebox などを使うとかっこいいらしい。
[Type-Providers | Fastify](https://fastify.dev/docs/latest/Reference/Type-Providers/)

## JSON Schema のメモ

### 野良`$id`はどう書くべき?

よくわからん。TODO

## JTD(JSON Type Definition) のメモ

"format"はない。
