# Husky v9 のメモ

Git のフックを使いやすくする薄いラッパー。
検索だと v9 以前の情報が多すぎるので注意。

- [husky - npm](https://www.npmjs.com/package/husky)
- [Husky](https://typicode.github.io/husky/)
- [typicode/husky: Git hooks made easy 🐶 woof!](https://github.com/typicode/husky#readme)
  - [How To | Husky](https://typicode.github.io/husky/how-to.html) 参考になる

## ありがちな使い方

[Get started | Husky](https://typicode.github.io/husky/get-started.html)

```sh
pnpm add -D husky
pnpm exec husky init
```

`.husky/pre-commit` をエディタで開いて

```sh
pnpm check
pnpm test
```

などと書く。次に run-scripts の prepare に

```json
	"scripts": {
		"prepare": "husky"
  }
```

と書いとく。

prepare は手動、または `npm install` の install後のフックとして実行される。

## v9 のメモ

すごく小さくなった。

pre-commit するだけなら `git config core.hooksPath .githooks` で `.githooks/pre-commit` に書いてもいい

`.husky/_/` はさわらないこと。またレポジトリに含めること。

`husky add` などがなくなったのはv9以降
