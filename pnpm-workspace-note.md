# pnpmでモノレポをやる "pnpm workspace" のメモ

ディレクトリ階層中で pnpm-workspace.yaml があれば、そこが「ワークスペース」になる

package.json は再帰的に処理されるので、
ワークスペースのルートで `pnpm i` を実行すれば、全部の「パッケージ」でモジュールがインストールされる。

これは `pnpm build` とかでも同じ。

ワークスペースのルートで `pnpm i` を実行すると、ロックファイルは1個だけできる。
もし pnpm-lock.yaml がほかにも存在するなら事前に消しておくべき。

pnpm-workspace.yaml の基本は

```yaml
packages:
  - apps/*
  - packages/*
```

こんな感じ。この場合 app/ 直下のディレクトリとpackages/直下が「パッケージ」とみなされる。

パッケージをリストするには

```sh
pnpm list -r --depth -1
```

がわかりやすい。

package.json の dependenciesに

```json
	"dependencies": {
		"@shared/app": "workspace:*"
	},
```

みたいな書き方ができる。これは`pnpm i`するとワークスペースに含まれるパッケージを node_modules 以下に link してくれる。

tsconfigに

```json
		// import aliases.
		"paths": {
			"@shared/*": ["../../packages/shared/src/*"],
		},
```

みたいに書くよりずっと取り回しがいい。

これを
Workspace Protocol(workspaceプロトコル)、Workspace Dependencies、Workspace Ranges(Yarn文脈)
という。

- pnpm - [Workspace protocol \(workspace:\)](https://pnpm.io/workspaces#workspace-protocol-workspace)
- [Workspace Protocol | Yarn](https://yarnpkg.com/protocol/workspace)
- [Workspaces - Bun](https://bun.com/docs/pm/workspaces)

CLIは

```sh
pnpm add lib@workspace:^
```

workspace:\* / workspace:^ / workspace:~ が使える。

Workspaceプロトコルが、**公開するパッケージの dependencies に含まれている場合** は注意。

```json
{
  "bundleDependencies": ["foo"],
  "dependencies": {
    "foo": "workspace:*"
  }
}
```

みたいにしておくのが無難

モノレポのワークスペースのルートで
`pnpm pack` すると、全パッケージが含まれたtarballが出来上がる。

分離したい場合は

```sh
pnpm -C apps/webapi pack
pnpm -C apps/client pack
```

みたいにするしかない(--filter を使ったハックはある)

なので
monorepoでも 公開にするパッケージではパッケージ名は完全修飾名を書いといたほうがいいです。

モノレポで、共有のパッケージがprivateだと話がいきなりややこしくなる。
