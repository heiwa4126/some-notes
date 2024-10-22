# Zod のメモ

- [zod - npm](https://www.npmjs.com/package/zod)

## z.coerce と z.transform の使い分け

`z.coerce`と`z.transform`は、Zod ライブラリにおけるデータ変換やバリデーションのための異なるメソッドです。それぞれの特徴を以下に示します。

### z.coerce

- **目的**: 特定の型に強制的に変換するために使用されます。これは、入力が期待される型でない場合でも、指定された型に変換することを目的としています。
- **使用例**: 例えば、文字列を数値に変換する場合などに使われます。`z.coerce.number()`を使うことで、文字列形式の数値を自動的に数値型に変換できます。
- **実装**:

  ```javascript
  import { z } from 'zod';

  const schema = z.object({
    age: z.coerce.number().positive().int()
  });
  ```

### z.transform

- **目的**: データを任意の方法で変換するためのメソッドで、バリデーション後にデータを整形したり、別の型に変換したりするために使用されます。
- **使用例**: 入力値を特定の形式に整形したい場合や、バリデーション後に追加の処理を行いたい場合に適しています。たとえば、文字列を数値に変換するだけでなく、さらにその数値を他の形式に加工することができます。
- **実装**:

  ```javascript
  import { z } from 'zod';

  const schema = z.object({
    age: z
      .string()
      .transform((val) => Number(val))
      .pipe(z.number().positive())
  });
  ```

### 比較

| 特徴               | `z.coerce`          | `z.transform`                    |
| ------------------ | ------------------- | -------------------------------- |
| 主な用途           | 型への強制的な変換  | 任意のデータ変換                 |
| バリデーション前後 | バリデーション前    | バリデーション後                 |
| 使用例             | `z.coerce.number()` | `.transform(val => Number(val))` |

このように、`z.coerce`は主に型の強制的な変換を行うために使われる一方で、`z.transform`はより柔軟なデータ処理や変換を行うためのメソッドです。

1. https://azukiazusa.dev/blog/react-hook-form-zod-5-patterns/
2. https://zenn.dev/417/scraps/051fda632e2b85
3. http://memopad.bitter.jp/web/R/R-intro.html
4. https://mitsuruog.github.io/javascript-style-guide/
5. https://qiita.com/anieca/items/c99118d6d1e4c82c20c7
6. https://docs.redhat.com/ja/documentation/red_hat_fuse/7.8/html-single/deploying_into_apache_karaf/index
7. https://zenn.dev/terrierscript/books/2023-01-typed-zod/viewer/3-2-corece
8. https://biz.webike.net/bm/800010301044/impre/o130l10c0/?ir=5&pre=57Sw6YOo44Gu5L2c44KK44GM44GX44Gj44GL44KK44GX44Gm44GE44KL&sr=-published_at
