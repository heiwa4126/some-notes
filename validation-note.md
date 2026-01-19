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

## Typebox

- [@sinclair/typebox - npm](https://www.npmjs.com/package/@sinclair/typebox)
- [TypeBox-Workbench](https://sinclairzx81.github.io/typebox-workbench/)

TypeCompiler が unsafe-eval なので Content Security Policy (CSP)で無効だと使えない。

- [コンテンツセキュリティポリシー (CSP) - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/CSP)
- [CSP: script-src - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Headers/Content-Security-Policy/script-src#%E5%AE%89%E5%85%A8%E3%81%A7%E3%81%AF%E3%81%AA%E3%81%84_eval_%E5%BC%8F)

Ajv も同様らしい。

## typia

Transformation モードが難しい。Generation モードも難しい。

これが使えるかも:

- [TypeScript の型システムに命を吹き込む: Typia と unplugin-typia](https://zenn.dev/ryoppippi/articles/c4775a3a5f3c11)
- [ryoppippi/unplugin-typia: unplugin for Typia with an extra Bun plugin 🫶](https://github.com/ryoppippi/unplugin-typia/)

## JSON Schema のメモ

### 野良`$id`はどう書くべき?

よくわからん。TODO

## JTD(JSON Type Definition) のメモ

"format"はない。

あと
[jtd - npm](https://www.npmjs.com/package/jtd)
という

## そもそも用語解説

### スキーマ

スキーマとは、データ構造やルールを定義する設計図です。特定のフォーマット（例: JSON Schema）を使って、データの形式や型、制約条件を記述します。

### バリデーション

バリデーションとは、与えられたデータがスキーマや仕様に従っているかを検証するプロセスです。不正なデータを検出し、エラーを防ぐために使用されます。

## バリデーションの段階

それぞれの段階での選択肢は、プロジェクトの規模や要件に応じて変わります。
最終的に目指すべきは、**メンテナンス性**と**型安全性**を両立する方法を選ぶことです。

### 0. バリデーションなし (論外)

バリデーションを行わない場合、入力データの整合性が保証されず、セキュリティや信頼性に問題が生じます。この段階は推奨されません。

### 1. プログラムでバリデーションする (メンテが面倒だが高速)

手動でロジックを書いてバリデーションを実装する方法です。

- **特徴**: 柔軟性が高いがメンテナンスが煩雑。
- **代表的な方法/ライブラリ**:
  - 独自実装 (e.g., if/else 構造)
  - バリデーションヘルパー:
    - [validator.js](https://github.com/validatorjs/validator.js)
    - [class-validator](https://github.com/typestack/class-validator)

### 2. 特殊なスキーマを書き、バリデートする

スキーマ専用の DSL(ドメイン固有言語)を用いてバリデーションルールを記述し、それに従ってバリデートを行います。

- **特徴**: スキーマ記述に特化しており、学習コストが比較的低い。例えば、Yup を使って以下のようにスキーマを定義できます。

  ```javascript
  const schema = Yup.object().shape({
    name: Yup.string().required(),
    age: Yup.number().positive().integer()
  });
  ```

- **代表的なライブラリ**:
  - [Yup](https://github.com/jquense/yup)
  - [zod](https://github.com/colinhacks/zod)
  - [io-ts](https://github.com/gcanti/io-ts)

### 3. JSON スキーマや JTD を書き、バリデータを合成する

標準化されたフォーマット(JSON Schema, JTD)を記述し、それをもとにバリデータを動的に生成する方法です。

- **特徴**: フォーマットが標準化されているため、異なるシステム間で再利用可能。
- **代表的なライブラリ**:
  - [ajv](https://github.com/ajv-validator/ajv) (JSON Schema)
  - [typescript-json-schema](https://github.com/YousefED/typescript-json-schema)
  - [jtd](https://github.com/jsontypedef/json-typedef-ts)

### 4. 特殊なスキーマを書き、それからバリデータと型を生成する

独自のスキーマフォーマットから、型情報とバリデータを両方自動生成します。

- **特徴**: 型の一貫性が保たれ、メンテナンス性が高い。例えば、zod を使ってスキーマから型を生成できます。

  ```javascript
  const UserSchema = zod.object({
    name: zod.string(),
    age: zod.number().positive().int()
  });
  type User = zod.infer<typeof UserSchema>;
  ```

- **代表的なライブラリ**:
  - [zod](https://github.com/colinhacks/zod) (スキーマから型生成)
  - [ts-json-validator](https://github.com/forabi/ts-json-validator)
  - [runtypes](https://github.com/pelotom/runtypes)

### 5. TypeScript の型からバリデータを生成する

TypeScript の型を元にバリデータを自動生成します。型駆動のアプローチです。

- **特徴**: 型定義を単一のソースに保つことで、冗長性を排除。
- **代表的なライブラリ**:
  - [ts-auto-validate](https://github.com/zaceno/ts-auto-validate)
  - [typebox](https://github.com/sinclairzx81/typebox) (型から JSON Schema を生成)
  - [typescript-is](https://github.com/woutervh-/typescript-is)
  - [io-ts](https://github.com/gcanti/io-ts)

### 6. ランタイム型推論と自動バリデーション

入力データをランタイムで型推論し、自動的にバリデーションを行うアプローチです。

- **特徴**: 明示的なスキーマ記述を省略可能。例えば、superstruct を使って以下のように型推論とバリデーションを行えます。

  ```typescript
  import { struct } from 'superstruct';
  const User = struct({
    name: 'string',
    age: 'number'
  });
  const user = User({ name: 'John', age: 30 });
  ```

- **代表的なライブラリ**:
  - [superstruct](https://github.com/ianstormtaylor/superstruct)
  - [zod](https://github.com/colinhacks/zod) (ランタイム推論対応)

### 7. マクロベースのバリデーション

TypeScript のトランスパイル時にマクロを利用してバリデーションコードを生成するアプローチです。

- **特徴**: 静的解析で効率的なコード生成が可能。
- **代表的なライブラリ**:
  - [typescript-transformer](https://github.com/longlho/typescript-transformer)

### 8. スキーマ駆動開発アプローチ

API のスキーマ(e.g., OpenAPI)から型定義やバリデータを生成するアプローチ。

- **特徴**: API ドキュメントとコードが同期するため、バージョン管理が容易。例えば、openapi-typescript を使って以下のように型定義を生成できます。

  ```sh
  npx openapi-typescript https://api.example.com/openapi.json --output schema.ts
  ```

- **代表的なライブラリ**:
  - [openapi-typescript](https://github.com/drwpow/openapi-typescript)
  - [swagger-codegen](https://swagger.io/tools/swagger-codegen/)
  - [openapi-codegen](https://github.com/kogosoftwarellc/open-api)

## メンテナンス性 と 型安全性

メンテナンス性と型安全性は、TypeScript で WebAPI の JSON 入力をバリデートする際に非常に重要な要素です。

- **メンテナンス性**
  メンテナンス性とは、コードの変更や追加が発生した際の修正の容易さを指します。
  **高いメンテナンス性**のコードは、一箇所の変更でシステム全体が整合性を保つように設計されており、冗長性が少なく、変更箇所が少ない。
- **型安全性**
  型安全性とは、コードが期待するデータ型が保証される度合いを指します。
  **高い型安全性**のシステムでは、コンパイル時に型の不整合が検出されるため、ランタイムエラーのリスクが低下します。

これらはコードの品質、保守の容易さ、バグの発生率に大きく影響します。
以下に、各段階でのメンテナンス性と型安全性について、具体的な例を交えて説明します。

### 1. プログラムでバリデーションする

#### メンテナンス性

- **低い**。手動でバリデーションロジックを記述するため、フィールドが増えたり変更があった場合、その都度コードを修正する必要があります。
- バリデーションロジックが分散しやすく、コードの重複や不整合が発生しやすい。

#### 型安全性

- **低い**。TypeScript の型はコンパイル時のみチェックされるため、ランタイムでの入力データの型チェックは手動で実装しなければなりません。
- バリデーションと型定義が別々になるため、同期が取れず型安全性が損なわれる可能性があります。

#### 例

```typescript
interface User {
  name: string;
  age: number;
}

function validateUser(data: any): User | null {
  if (typeof data.name === 'string' && typeof data.age === 'number') {
    return { name: data.name, age: data.age };
  }
  return null;
}

// 使用例
const inputData = JSON.parse(requestBody);
const user = validateUser(inputData);
if (user) {
  // バリデーション成功時の処理
} else {
  // バリデーション失敗時の処理
}
```

**問題点**:

- フィールドが増えるたびに`validateUser`関数を修正する必要があります。
- 型チェックが手動であるため、ヒューマンエラーが起きやすい。

### 2. 特殊なスキーマを書き、バリデートする

#### メンテナンス性

- **中程度**。スキーマを用いることでバリデーションロジックを簡潔に記述できますが、スキーマと型定義が別々の場合、同期が取れずメンテナンス性が低下します。

#### 型安全性

- **中程度**。スキーマによるバリデーションはあるものの、TypeScript の型定義とスキーマが別々に管理されると、不整合が発生するリスクがあります。

#### 例 (Yup を使用)

```typescript
import * as Yup from 'yup';

const userSchema = Yup.object({
  name: Yup.string().required(),
  age: Yup.number().required()
});

interface User {
  name: string;
  age: number;
}

async function validateUser(data: any): Promise<User | null> {
  try {
    const validatedData = await userSchema.validate(data);
    return validatedData as User;
  } catch (error) {
    return null;
  }
}
```

**問題点**:

- スキーマ(`userSchema`) と型定義(`User`)が別々に存在するため、変更時に両方を更新する必要があります。
- フィールドの追加や変更時に、同期が取れないとバグの原因になります。

### 4. 特殊なスキーマを書き、それからバリデータと型を生成する

#### メンテナンス性

- **高い**。スキーマから型とバリデータを同時に生成するため、一箇所の変更で済みます。
- スキーマが単一の情報源となるため、変更管理が容易です。

#### 型安全性

- **高い**。スキーマから直接型を生成するため、型の不整合が起こりにくく、コンパイル時に型チェックが可能です。

#### 例 (Zod を使用)

```typescript
import { z } from 'zod';

const UserSchema = z.object({
  name: z.string(),
  age: z.number()
});

// スキーマから型を生成
type User = z.infer<typeof UserSchema>;

function validateUser(data: unknown): User {
  return UserSchema.parse(data);
}

// 使用例
try {
  const user = validateUser(JSON.parse(requestBody));
  // バリデーション成功時の処理
} catch (error) {
  // バリデーション失敗時の処理
}
```

**利点**:

- スキーマと型定義が一体化しているため、メンテナンス性が高い。
- 型生成が自動化されているため、型安全性が保証される。

### 5. TypeScript の型からバリデータを生成する

#### メンテナンス性

- **高い**。TypeScript の型定義を一箇所で管理し、それを元にバリデータを生成するため、変更時の負担が少ない。

#### 型安全性

- **高い**。型定義が単一の情報源であるため、型の一貫性が保たれます。

#### 例 (typescript-is を使用)

```typescript
import { is } from 'typescript-is';

interface User {
  name: string;
  age: number;
}

function validateUser(data: any): User | null {
  if (is<User>(data)) {
    return data;
  }
  return null;
}
```

**注意点**:

- `typescript-is`は TypeScript コンパイラのプラグインを必要とし、セットアップが複雑になる可能性があります。
- ランタイムでの型情報を利用するため、ビルドプロセスが複雑化する可能性があります。

### **6. ランタイム型推論と自動バリデーション**

#### **メンテナンス性**

- **高い**。型やスキーマを手動で記述する必要がなく、入力データから動的に型を推論してバリデーションを実行するため、変更箇所が少ない。
- ただし、ランタイムで型を推論するため、型情報が複雑になる場合にはコードが難解になる可能性があります。

#### **型安全性**

- **中程度**。ランタイムで推論した型に基づいてバリデーションを行いますが、TypeScript のコンパイル時の型チェックほど強力ではありません。
- ランタイムエラーを完全に排除するには別途型定義を補助的に記述する必要があります。

#### **例** (Superstruct を使用)

```typescript
import { object, string, number, validate } from 'superstruct';

// スキーマの定義
const User = object({
  name: string(),
  age: number()
});

// データのバリデーション
const [error, user] = validate({ name: 'Alice', age: 25 }, User);

if (error) {
  console.error('Validation failed:', error);
} else {
  console.log('Validated user:', user);
}
```

### 7. マクロベースのバリデーション

#### メンテナンス性

- **高い**。TypeScript のマクロやトランスパイラプラグインを使用して、型定義からバリデーションコードを生成するため、一箇所の型定義を修正するだけでバリデーションが更新されます。
- プラグインやビルド環境のセットアップが必要なため、小規模プロジェクトには不向き。

#### 型安全性

- **高い**。型定義がソースコードに存在し、それをもとに生成されるため、型の不整合が発生しません。

#### **例** (typescript-transformer を使用)

```typescript
// tsconfig.jsonでtransformerを設定
// 使用例
import { is } from 'typescript-is';

interface User {
  name: string;
  age: number;
}

function validateUser(data: unknown): User {
  if (is<User>(data)) {
    return data;
  }
  throw new Error('Validation failed');
}

// データをバリデーション
const user = validateUser({ name: 'Alice', age: 25 });
console.log('Validated user:', user);
```

### 8. スキーマ駆動開発アプローチ

#### **メンテナンス性**

- **非常に高い**。API 仕様書（e.g., OpenAPI）から型定義やバリデータを自動生成するため、API の変更が即座にコードに反映されます。
- ドキュメント駆動であるため、異なるチーム間でも効率的に開発を進められます。

#### **型安全性**

- **高い**。仕様書に基づいてコードが生成されるため、API 定義とコードの同期が保たれ、型の不整合がほぼ発生しません。

#### **例** (openapi-typescript を使用)

```typescript
// OpenAPIスキーマ (schema.json)
{
  "openapi": "3.0.0",
  "info": {
    "title": "API Example",
    "version": "1.0.0"
  },
  "paths": {
    "/user": {
      "get": {
        "responses": {
          "200": {
            "description": "A user object",
            "content": {
              "application/json": {
                "schema": {
                  "type": "object",
                  "properties": {
                    "name": { "type": "string" },
                    "age": { "type": "number" }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

// コード生成と使用例
import { paths } from './schema.generated';

type UserResponse = paths['/user']['get']['responses']['200']['content']['application/json'];

function fetchUser(): Promise<UserResponse> {
  return fetch('/user').then((res) => res.json());
}
```

### メンテナンス性 と 型安全性 の比較表

| 手法                                        | メンテナンス性 | 型安全性 |
| ------------------------------------------- | -------------- | -------- |
| **1. 手動バリデーション**                   | 低             | 低       |
| **2. スキーマを使用（型と別管理）**         | 中             | 中       |
| **4. スキーマから型とバリデータを生成**     | 高             | 高       |
| **5. 型からバリデータを生成**               | 高             | 高       |
| **6. ランタイム型推論と自動バリデーション** | 高             | 中       |
| **7. マクロベースのバリデーション**         | 高             | 高       |
| **8. スキーマ駆動開発アプローチ**           | 非常に高       | 高       |

- **手動バリデーション**では、コードが煩雑になりやすく、変更時の修正箇所も多くなります。型安全性も低いため、バグの温床になります。
- **スキーマを使用**する方法では、型定義とスキーマが別々になるため、同期が取れないとメンテナンス性と型安全性が低下します。
- **スキーマから型とバリデータを生成**する方法や、**型からバリデータを生成**する方法では、単一の情報源から全てを生成するため、メンテナンス性と型安全性が高まります。

**結論**

- プロジェクトの規模やチーム構成に応じて最適な手法を選択します。
  - 小規模プロジェクトでは「スキーマから型とバリデータを生成」や「ランタイム型推論」が適している場合があります。
  - 大規模プロジェクトや API 設計が重要な場合は「スキーマ駆動開発アプローチ」を推奨します。

### 具体的なシナリオでの比較

#### **シナリオ 1: 新しいフィールドの追加**

**手動バリデーションの場合**:

```typescript
// 既存の型とバリデーション
interface User {
  name: string;
}

function validateUser(data: any): User | null {
  if (typeof data.name === 'string') {
    return { name: data.name };
  }
  return null;
}

// 新しいフィールド 'age' を追加
interface User {
  name: string;
  age: number;
}

// バリデーションロジックも修正が必要
function validateUser(data: any): User | null {
  if (typeof data.name === 'string' && typeof data.age === 'number') {
    return { name: data.name, age: data.age };
  }
  return null;
}
```

- **修正箇所が多く、バグを埋め込むリスクが高い**。

**Zod を使用する場合**:

```typescript
// スキーマと型定義
const UserSchema = z.object({
  name: z.string(),
  // 'age' フィールドを追加
  age: z.number()
});

type User = z.infer<typeof UserSchema>;

// バリデーション関数は変更不要
function validateUser(data: unknown): User {
  return UserSchema.parse(data);
}
```

- **スキーマにフィールドを追加するだけで、型定義とバリデーションが自動的に更新**されます。

#### **シナリオ 2: フィールドの型変更**

**手動バリデーションの場合**:

- フィールドの型を変更した場合、型定義とバリデーション関数の両方を手動で修正する必要があります。
- 修正漏れが発生すると、型安全性が損なわれます。

**Zod を使用する場合**:

- スキーマ内の型を変更するだけで、型定義とバリデーションが自動的に更新されます。
- **一箇所の修正で済むため、メンテナンス性が高い**。

---

### **まとめ**

- **メンテナンス性を高めるためのポイント**:

  - **単一情報源の原則**: スキーマや型定義を一箇所で管理し、自動生成することで、修正箇所を最小限に抑えます。
  - **自動生成ツールの活用**: Zod や io-ts などのライブラリを利用して、スキーマから型とバリデータを生成します。

- **型安全性を高めるためのポイント**:
  - **型とバリデーションの同期**: 型定義とバリデーションロジックを一体化することで、型の不整合を防ぎます。
  - **コンパイル時の型チェック**: TypeScript の型システムを最大限に活用し、コンパイル時にエラーを検出します。

**最適なアプローチ**:

- **スキーマから型とバリデータを生成する方法(例: Zod)**が、メンテナンス性と型安全性の両方を高める上で有効です。
- プロジェクトの規模や要件に応じて、適切なライブラリや手法を選択することが重要です。

---

**最終的に、メンテナンス性と型安全性を両立することで、開発効率の向上とバグの削減が期待できます。適切なツールやアプローチを選択し、健全なコードベースを維持しましょう。**
