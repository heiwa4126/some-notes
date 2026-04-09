# note:test と node:assert

Mocha/Chai とか jest とか vitest などのテストフレームワークって
なんか依存性の脆弱性多いよね... ということで node 組み込みのを調べてみる

- [Test runner | Node.js v25.9.0 Documentation](https://nodejs.org/api/test.html)
- [Assert | Node.js v25.9.0 Documentation](https://nodejs.org/api/assert.html)

node:test は node v20 から stable

node:asset はずいぶん前からある

スパイ・スタブとして mock は node:test に組み込み済み。
HTTP テストは supertest が定番で、node:test と組み合わせてそのまま使えるらしい。

TypeScript テストは tsx と組み合わせる。型チェックがないので `tsc --noEmit` は必要

| 用途                     | パッケージ                                    |
| ------------------------ | --------------------------------------------- |
| スパイ・スタブ           | `node:test`組み込みの`mock`(基本はこれで十分) |
| 高度なスパイ             | `sinon`                                       |
| HTTPテスト               | `supertest` または `supertest-fetch`          |
| fetchモック              | `fetch-mock`                                  |
| TypeScriptトランスパイル | `tsx`                                         |

カバレッジは、c8 不要で組み込みカバレッジが使える。
こんな具合:

```sh
node --import tsx --test --experimental-test-coverage **/*.test.ts
```
