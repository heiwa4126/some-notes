# bun (バン) メモ

- [bun の概要](#bun-の概要)
- [Windows でインストールに失敗するとき](#windows-でインストールに失敗するとき)
- [bun でこれだけはやっといたほうがいい設定](#bun-でこれだけはやっといたほうがいい設定)
- [`npm ls` の equivalent](#npm-ls-の-equivalent)
- [bun には publish がない](#bun-には-publish-がない)
- [Bun で bun.lockb を bun.lock(新フォーマットのテキストベースの lockfile)に変換するには](#bun-で-bunlockb-を-bunlock新フォーマットのテキストベースの-lockfileに変換するには)
  - [手順](#手順)
- [bun のグローバルキャッシュをクリアする](#bun-のグローバルキャッシュをクリアする)
- [bun で 〇〇は...](#bun-で-〇〇は)
- [`bun audit`](#bun-audit)
- [pnpm の minimumReleaseAge 相当](#pnpm-の-minimumreleaseage-相当)
- [`bun build` はバンドラなんだけど](#bun-build-はバンドラなんだけど)
- [bun の shell completions](#bun-の-shell-completions)
- [bun の .env と run-scripts の変な挙動](#bun-の-env-と-run-scripts-の変な挙動)
  - [何が違うか](#何が違うか)
  - [実用上の結論](#実用上の結論)
  - [.env 関連 issues](#env-関連-issues)

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
[2]: https://bun.com/docs/guides/install/yarnlock?utm_source=chatgpt.com "Generate a yarn-compatible lockfile"
[3]: https://www.codingtag.com/bun-lockb-file-explained?utm_source=chatgpt.com "Bun.lockb File Explained"
[4]: https://bsky.app/profile/bun.sh/post/3ld26dxe5n226?utm_source=chatgpt.com "Bun"

## bun のグローバルキャッシュをクリアする

```sh
bun pm cache rm
```

## bun で 〇〇は...

```sh
# npm list
bun pm ls
```

## `bun audit`

v1.3 系から使えるようになった。

[bun audit - Bun](https://bun.com/docs/pm/cli/audit)

あと `bun why` も。

## pnpm の minimumReleaseAge 相当

bunfig.toml で

```toml
[install]
# 単位は分。1440 = 24時間
minimumReleaseAge = 1440
```

[bunfig.toml - Bun](https://bun.com/docs/runtime/bunfig#install-minimumreleaseage)

以下は ~/.config/pnpm/rc の例で、下 2 つはいまのところ bun に相当するものはない。

```conf
minimumReleaseAge=1440        # 公開後24時間未満の新バージョンを拒否(default 0)[1](https://pnpm.io/supply-chain-security)
blockExoticSubdeps=true       # トランジティブ依存の git/tarball 等を禁止(default false)[1](https://pnpm.io/supply-chain-security)
trustPolicy=no-downgrade      # 信頼レベルが低下したバージョンを拒否(default off)[1](https://pnpm.io/supply-chain-security)
```

## `bun build` はバンドラなんだけど

「単一 bundle を作る」のが目的なので

- .d.ts が出せない
- ファイルごとに .ts -> .js ができない
- IIFE + globalName ができない

なので、再利用できるモジュールを作るのはつらいかも。
tsdown とかをつかいましょう。

## bun の shell completions

`bun run` の completions がほしい

`bun completions` で取得できるのは bash 用でしかもあんまり出来がよくない。

`.bun/_bun` も存在しない。

[bun/completions at main · oven\-sh/bun](https://github.com/oven-sh/bun/tree/main/completions)
が、そこそこメンテナンスされてるみたいなので試す...

zsh 版は期待通り動く

bash 版(<https://github.com/oven-sh/bun/blob/main/completions/bun.bash>)は

> sed: -e expression #1, char 40: unknown option to `s'

というエラーになる。Claude に丸投げした

```text
bun の bash completions (https://github.com/oven-sh/bun/blob/main/completions/bun.bash)を試してるんですが、

> sed: -e expression #1, char 40: unknown option to `s'

というエラーになります。修正パッチを作って
```

出てきたのが以下で、デリミタを `/` から `|` に変える

```diff
--- a/completions/bun.bash
+++ b/completions/bun.bash
@@ -1,5 +1,5 @@
-        local re_script=$(echo ${package_json_compreply[@]} | sed 's/[^ ]*/(&)/g');
-        local new_reply=$(echo "${COMPREPLY[@]}" | sed -E "s/$re_script//");
+        local re_script=$(echo ${package_json_compreply[@]} | sed 's|[^ ]*|(&)|g');
+        local new_reply=$(echo "${COMPREPLY[@]}" | sed -E "s|$re_script||");
```

...エラーはでなくなったけど、`bun run` の補完はしてくれない...

- Issue: [Bash autocomplete #6037](https://github.com/oven-sh/bun/issues/6037)
- PR: [fix: bash completion script #17147](https://github.com/oven-sh/bun/pull/17147)(未マージ)

ただ run-scripts で複数行の JSON があると死ぬらしい。

いちおう Gist にしといた。普段使いでは問題ないのでは

- [bun bash completion\(バグ修正版\) oven\-sh/bun 公式の completions/bun\.bash にあるバグを修正したものです。PR も issuse も出てるけど全然取り込まれないので自分用に](https://gist.github.com/heiwa4126/dc0b087e89026c235281655b6a835ae6)

## bun の .env と run-scripts の変な挙動

bun は .env を自前で処理する
<https://bun.com/docs/runtime/environment-variables#setting-environment-variables>
んですが、run-scripts で

```json
"scripts": {
  "foo1": "./script/foo.sh",
  "foo2": "bash ./script/foo.sh",
}
```

だと
`bun run foo1` は .env(や.env.production, .env.development, .env.test, .env.local) で設定した値が foo.sh に渡るのに、
`bun run foo2` は渡らない、
というへんな挙動がある。

これは Bun の内部実装(`run_command.zig`)に起因する既知の非対称性。

### 何が違うか

Linux/macOS で `bun run <script>` を実行するとき、package.json の script 文字列は最終的に **システムの `bash`/`sh`/`zsh` を `-c` フラグ付きでspawnする** ことで実行されます(Bun Shell が使われるのは Windows や bun で直接 `.sh` を実行する場合で、package.json の script 経由では Unix 系だと通常のシェルが使われます)。

- `"foo": "bash script/foo.sh"` のように**複数語からなるコマンド**の場合 → Bun はこれを `bash -c "bash script/foo.sh"` のように**新しいシェルプロセスへディスパッチ**します。このディスパッチ経路では、`.env`/`.env.production` などから読み込んでマージした環境変数が、実際に spawn されるシェルプロセスの OS レベルの環境(envp)に反映されないという既知の制限があります。同様の症状は `"env": "env"` というだけのスクリプトを `bun run env` した場合にも報告されていて、`bun` の REPL で見る `process.env` にはロード済みの `.env` の値が入っているのに、`bun run env` の出力にはそれが出てこない、という不整合が Bun の issue でも指摘されています。

- `"foo": "./script/foo.sh"` のように**単一の実行可能ファイルパス**の場合 → Bun はシェルを経由した文字列パース(`bash -c "..."`)を挟まず、**そのファイルを直接exec**する、より単純な経路を取ります。この経路では、bun 自身のプロセスが既に `.env` 読み込み後に持っている環境(process.env)がそのまま引き継がれるため、期待通り環境変数が渡ります。

つまり「シェル文字列として解釈・spawn されるか」「実行可能ファイルとして直接 exec されるか」で、環境変数の引き継ぎに差が出るという、Bun の内部実装上の非対称性が原因です。ドキュメント上は明記されていない、実装依存の挙動です。

### 実用上の結論

- `chmod +x script/foo.sh` して `"foo": "./script/foo.sh"` にする、というやり方は正しい回避策です。これなら前回の TypeScript ラッパーは不要になります。
- 引数を渡したい場合も `"foo": "./script/foo.sh --flag value"` のように**先頭が実行可能ファイルパスであること**を保ってあれば同様に動くはずです(念のため一度動作確認してみてください)。
- 逆に `"foo": "bash script/foo.sh"` や `"foo": "sh script/foo.sh"` のように**インタプリタ名を明示する形**は避けたほうが安全、ということになります。

### .env 関連 issues

- [NODE_ENV=production in package.json scripts no longer reads from .env.production (#9635)](https://github.com/oven-sh/bun/issues/9635)
- ["bun run env" does not include environment variables from .env (#9925)](https://github.com/oven-sh/bun/issues/9925)
- [Specific .env.[mode] does not override .env via package.json script (#6334)](https://github.com/oven-sh/bun/issues/6334)
- [Incorrect parsing of empty envs in .env file, when running via package.json script (#5097)](https://github.com/oven-sh/bun/issues/5097)
- [Setting env variables in package.json scripts with more than 16 characters fails (#9823)](https://github.com/oven-sh/bun/issues/9823)
- [`bun run script.js` fails when script has node shebang (#4850)](https://github.com/oven-sh/bun/issues/4850)
- [Bun should automatically load environment variable files when running package.json scripts (#14189)](https://github.com/oven-sh/bun/issues/14189)
