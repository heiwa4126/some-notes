# bun メモ

- [bun の概要](#bun-の概要)
- [Windows でインストールに失敗するとき](#windows-でインストールに失敗するとき)
- [bun でこれだけはやっといたほうがいい設定](#bun-でこれだけはやっといたほうがいい設定)
- [`npm ls` の equivalent](#npm-ls-の-equivalent)
- [bun には publish がない](#bun-には-publish-がない)
- [Bun で bun.lockb を bun.lock(新フォーマットのテキストベースの lockfile)に変換するには](#bun-で-bunlockb-を-bunlock新フォーマットのテキストベースの-lockfileに変換するには)
  - [手順](#手順)
- [bun のグローバルキャッシュをクリアする](#bun-のグローバルキャッシュをクリアする)
- [bun で 〇〇は...](#bun-で-〇〇は)

## bun の概要

- [Bun — A fast all-in-one JavaScript runtime](https://bun.sh/)
- [oven-sh/bun: Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one](https://github.com/oven-sh/bun)

## Windows でインストールに失敗するとき

```pwsh
# これを (https://bun.com/ に載ってるやつ)
powershell -c "irm bun.sh/install.ps1 | iex"
# こうする
powershell -NoProfile -c "irm https://bun.sh/install.ps1 | iex"
```

## bun でこれだけはやっといたほうがいい設定

[Lockfile – Package manager | Bun Docs](https://bun.sh/docs/install/lockfile)

```sh
git config --global diff.lockb.textconv bun
git config --global diff.lockb.binary true
```

## `npm ls` の equivalent

`bun pm ls`

[bun pm – Package manager | Bun Docs](https://bun.sh/docs/cli/pm)

```console
$ bun pm --help
bun pm: Package manager utilities

  bun pm bin                print the path to bin folder
  └  -g                     print the global path to bin folder
  bun pm ls                 list the dependency tree according to the current lockfile
  └  --all                  list the entire dependency tree according to the current lockfile
  bun pm hash               generate & print the hash of the current lockfile
  bun pm hash-string        print the string used to hash the lockfile
  bun pm hash-print         print the hash stored in the current lockfile
  bun pm cache              print the path to the cache folder
  bun pm cache rm           clear the cache
  bun pm migrate            migrate another package manager's lockfile without installing anything
  bun pm untrusted          print current untrusted dependencies with scripts
  bun pm trust names ...    run scripts for untrusted dependencies and add to `trustedDependencies`
  └  --all                  trust all untrusted dependencies
  bun pm default-trusted    print the default trusted dependencies list
```

## bun には publish がない

```console
$ bun publish --help
Uh-oh. bun publish is a subcommand reserved for future use by Bun.

If you were trying to run a package.json script called publish, use bun run publish.
```

じゃあどうやって Bun のプロジェクトを npmjs.com に発行する?

ヒントになりそうなもの:

- [Bun version & publish manager · Issue #5050 · oven-sh/bun](https://github.com/oven-sh/bun/issues/5050)
- [Bun 専用(?)TypeScript そのまま npm パッケージの作成に関する覚え書き](https://zenn.dev/macropygia/articles/typescript-only-npm-package-creation)

まあ早い話が「npm でやるのと同じようにやれ」ということですね。

## Bun で bun.lockb を bun.lock(新フォーマットのテキストベースの lockfile)に変換するには

- `bun.lockb` はバイナリ形式で高速かつサイズ効率が高いのが利点。([codingtag.com][3])
- ただしバイナリのままだと差分の確認やレビューが難しいため、テキスト形式の `bun.lock` が推奨されるようになりました。([Bun][1])
- 現在(Bun v1.2 以降)では、デフォルトで `bun.lock` が生成されるようになっています。([Bluesky Social][4])

Bun で `bun.lockb` を `bun.lock`(新フォーマットのテキストベースの lockfile)に変換するには、公式にサポートされている方法があります。
以下の手順で実行できます。([Bun][1])

### 手順

1. Bun のバージョンが **v1.1.39 以降** であることを確認。([Bun][2])
2. プロジェクトディレクトリで以下を実行:

```bash
bun install --save-text-lockfile --frozen-lockfile --lockfile-only
```

- `--save-text-lockfile` — テキスト形式の `bun.lock` を生成
- `--frozen-lockfile` — 既存の lockfile に基づいて依存性を固定
- `--lockfile-only` — インストールはせず、lockfile だけ更新

3. 成功したら、古い `bun.lockb` を手動で削除(または git 管理下から外す)

これで `bun.lockb` → `bun.lock` への移行が完了します。

[1]: https://bun.com/blog/bun-lock-text-lockfile?utm_source=chatgpt.com "Bun's new text-based lockfile"
[2]: https://bun.com/docs/guides/install/yarnlock?utm_source=chatgpt.com 'Generate a yarn-compatible lockfile'
[3]: https://www.codingtag.com/bun-lockb-file-explained?utm_source=chatgpt.com 'Bun.lockb File Explained'
[4]: https://bsky.app/profile/bun.sh/post/3ld26dxe5n226?utm_source=chatgpt.com 'Bun'

## bun のグローバルキャッシュをクリアする

```sh
bun pm cache rm
```

## bun で 〇〇は...

```sh
# npm list
bun pm ls
```
