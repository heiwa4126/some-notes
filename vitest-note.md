# vitestのメモ

## vitestでvite8(2026-04)

注: 以下は vitest@4.1.3 より前の話。
4.1.3 では
`pnpm up -L --config.minimumReleaseAge=0`
で、大丈夫みたい。

ダメなときは以下を実行

---

古いviteのvitestをなんとかする。lockファイルは消さない方針で。

例:

```sh
pnpm add -D -E vite@8.0.7 --config.minimumReleaseAge=0
```

バージョンなどはアレンジ。

うまくいったら、 package.json の devDependenciesからviteを消す。
`pnpm remove` じゃダメ。

で、

```sh
pnpm up --config.minimumReleaseAge=0
```

でlockfile更新。
