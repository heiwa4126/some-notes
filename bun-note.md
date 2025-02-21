# bun メモ

- [bun の概要](#bun-の概要)
- [bun でこれだけはやっといたほうがいい設定](#bun-でこれだけはやっといたほうがいい設定)
- [`npm ls` の equivalent](#npm-ls-の-equivalent)
- [bun には publish がない](#bun-には-publish-がない)
- [bun のグローバルキャッシュをクリアする](#bunのグローバルキャッシュをクリアする)

## bun の概要

- [Bun — A fast all-in-one JavaScript runtime](https://bun.sh/)
- [oven-sh/bun: Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one](https://github.com/oven-sh/bun)

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

## bun のグローバルキャッシュをクリアする

```sh
bun pm cache rm
```
