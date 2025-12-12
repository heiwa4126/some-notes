# tsdown のメモ

## 2025 年末時点での展望

- **tsup**: 公式 README で「**もはや積極的にメンテされていないので _tsdown_ を使って**」と明記。機能追加は鈍化、バグ修正は時折入るが長期の主役復帰は考えにくい。 [\[github.com\]](https://github.com/egoist/tsup), [\[github.com\]](https://github.com/egoist/tsup/releases)
- **pkgroll**: Rollup ベースの「**ゼロ設定パッケージ用バンドラ**」。継続的に小刻みなリリースが続いており、Node/TS の**ライブラリ配布**に安定選択。 [\[github.com\]](https://github.com/privatenumber/pkgroll/blob/master/README.md), [\[github.com\]](https://github.com/privatenumber/pkgroll/releases)
- **tsdown**: VoidZero(Vite/Rolldown 陣営)の「**Rolldown 駆動・ライブラリ特化**」新星。**tsup 互換オプション**や移行ガイドを掲げており、Vite が Rolldown 統合を進める流れと相乗して**採用が拡大**する見込み。 [\[github.com\]](https://github.com/rolldown/tsdown), [\[vite.dev\]](https://vite.dev/guide/rolldown)

## tsup からのミグレーション

[Migrate from tsup - The Elegant Bundler for Libraries](https://tsdown.dev/guide/migrate-from-tsup)
だけではうまくいかなくて、tsdown.config.ts と tsconfig.json をけっこういじった。

- outExtension が outExtensions になって、式がかわる
- iife 出力にすると、拡張子が `.iife.js` になって、outExtensions では js のとこしか書き換えられない。
  - ので rolldown にオプションを渡して対処する
    ```ts
        outputOptions: {
        // outExtensionsでは対応できない。hello.iife.global.js になる
        // [name] はエントリファイル名 (hello) に置き換わります
        entryFileNames: "[name].global.js",
      },
    ```
- tsconfig.json の設定のいくつかが、tsdown.config.ts より優先される。代表例が declarationMap によるソースマップの自動有効化 [Source Maps - The Elegant Bundler for Libraries](https://tsdown.dev/options/sourcemap)

## tsconfig.json の設定のいくつかが、tsdown.config.ts より優先される

の件がかなりややこしいので、ChatGPT にまとめてもらったんだけどよくわからん。
いちおう引用しておきます。

---

結論から言うと、**tsdown では “tsconfig.json の一部の設定がビルド挙動を強く左右し、場合によっては tsdown.config.ts より優先” されます**。ただし\*\*一般則は「tsdown/ Rolldown のトップレベル指定(=tsdown.config.ts 経由で渡すオプション)が優先」\*\*で、**例外的に tsconfig 側が強制するケース**がいくつかあります。代表例が **`declarationMap` によるソースマップの自動有効化**です。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig), [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)

以下、\*\*公開ドキュメントに基づく“優先・影響関係の全リスト”\*\*を整理しました(tsdown は Rolldown をコアに使っているため、Rolldown の「tsconfig の取り込み仕様」が事実上の根拠になります)。

### 優先ルールの一般原則

- **(原則)tsdown/ Rolldown のトップレベル設定が tsconfig より優先**  
  Rolldown 公式の `tsconfig` オプション解説では「**トップレベルの transform 等の設定が tsconfig の設定より常に優先**」と明記されています。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

- **(例外)tsconfig が機能を“強制有効化”することがある**  
  tsdown の公式「Source Maps」では「**tsconfig.json の `declarationMap` が有効なら、`--sourcemap` を指定していなくてもソースマップは常に有効**」と書かれています。これは \*\*tsconfig 側が tsdown のソースマップ設定を事実上“上書き”\*\*する代表的なパターンです。 [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)

### tsconfig.json が tsdown(Rolldown)に与える影響:項目別一覧

#### 1) **モジュール解決(Resolver)系:tsconfig が優先的に参照される**

- `compilerOptions.baseUrl`:パス解決の基準ディレクトリ。Rolldown のリゾルバが使用。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
- `compilerOptions.paths`:モジュールのエイリアス解決。Rolldown のリゾルバが使用。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

> これらは **tsdown.config.ts の通常オプションよりも先に**「**tsconfig を見て解決**」される設計です。トップレベルで別途 `resolve` 系をオーバーライドしない限り、**tsconfig の指定が実際の解決結果を決める**と考えてよいです。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

#### 2) **トランスフォーム(Transformer)系:tsdown 側で明示しない限り tsconfig の影響が残る**

Rolldown は TypeScript 関連の以下のコンパイラオプションを**選択的に利用**します。**tsdown 側の transform 等で明示上書きしない限り、tsconfig の値が効きます。** [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

- `compilerOptions.jsx`(`react-jsx` など):JSX 変換モード。  
  ※tsdown/ Rolldown のトップレベル `transform.jsx.mode` を指定した場合はそちらが優先。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
- `compilerOptions.experimentalDecorators`:デコレーターを許可。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
- `compilerOptions.emitDecoratorMetadata`:デコレーターのメタデータを出力。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
- `compilerOptions.verbatimModuleSyntax`:モジュール構文の保存。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
- `compilerOptions.useDefineForClassFields`:クラスフィールドの定義セマンティクス。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

> **優先関係**:上記は **tsconfig →(上書きがあれば)tsdown/ Rolldown の transform** の順。すなわち **tsdown で明示すれば tsdown が勝ち、明示しなければ tsconfig が効く**。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

#### 3) **ソースマップ(sourcemap)系:特殊な優先(強制有効化)あり**

- **`declarationMap`(tsconfig)**:**有効なら tsdown の `--sourcemap` 有無に関係なく、ソースマップは常に有効**になります。**tsdown.config.ts の `sourcemap: false` を形式的に設定しても、`declarationMap` により結果は“有効”になります**。 [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)
- **`sourceMap`(tsconfig)**:TypeScript の標準的なマップ出力設定。Rolldown 系では**出力側の `sourcemap`(ロールダウン/ロールアップの出力オプション)と整合が必要**になることがあり、ツールチェインでは**不整合時に警告が出る設計**が一般的です(例:Rollup の TypeScript プラグインの警告仕様)。 [\[typescriptlang.org\]](https://www.typescriptlang.org/tsconfig/sourceMap.html), [\[stackoverflow.com\]](https://stackoverflow.com/questions/63128597/how-to-get-rid-of-the-rollup-plugin-typescript-rollup-sourcemap-option-must)
- **`inlineSourceMap`(tsconfig)⇔ `sourcemap: 'inline'`(tsdown)**:tsdown の型定義では `sourcemap` に `'inline' | 'hidden'` が取れるため、**tsconfig の `inlineSourceMap` と対応づけられる挙動**が議論され、ドキュメント整備が進んでいる最中です(ディスカッション/Issue)。 [\[tsdown.dev\]](https://tsdown.dev/reference/api/typealias.sourcemap), [\[github.com\]](https://github.com/rolldown/tsdown/issues/442), [\[github.com\]](https://github.com/rolldown/tsdown/discussions/448)

#### 4) **型定義(dts)・周辺**

- **`declaration`(tsconfig)**:型定義生成のベース設定。tsdown は `dts` オプションで型生成を自動化しますが、**tsconfig の `declaration*` 系(`declarationMap` 含む)に連動した挙動**を取ります。`declarationMap` 連動による **sourcemap 強制有効化**は前述のとおりです。 [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)

### 「tsdown.config.ts より優先される」具体的な例

- **`declarationMap: true`**(tsconfig)  
  → **tsdown の `sourcemap` 設定に関わらず**、**ソースマップが常に有効**になります。 [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)

- **`paths` / `baseUrl`**(tsconfig)  
  → モジュール解決は **tsconfig の指定が事実上の根拠**。tsdown 側で解決挙動を明示的に上書きしない限り、**tsconfig が決定要因**になります。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

- **`jsx` など Transformer 系**(tsconfig)  
  → **tsdown 側で transform を明示しない**場合、**tsconfig の値が採用**されます。**明示すると tsdown が優先**。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

- **`sourceMap`**(tsconfig)  
  → **出力側の `sourcemap` と整合が必要**。ツールチェインによっては**不一致警告**が出ます(Rollup の TypeScript プラグインの例)。tsdown/ Rolldown でも**整合させるのが安全**です。 [\[stackoverflow.com\]](https://stackoverflow.com/questions/63128597/how-to-get-rid-of-the-rollup-plugin-typescript-rollup-sourcemap-option-must), [\[typescriptlang.org\]](https://www.typescriptlang.org/tsconfig/sourceMap.html)

### 逆に「tsdown.config.ts のほうが優先」される代表例

- **トップレベルの transform 設定**(例:`transform.jsx.mode` を `classic` に)  
  → **tsconfig の `jsx` よりも tsdown 側が優先**されます(Rolldown の仕様)。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

- **`sourcemap: 'inline' | 'hidden'` など tsdown 特有の指定**  
  → tsdown の型定義に準じて**tsdown の挙動が適用**されます。ただし、**`declarationMap` の“強制有効化”は別格**なので、`hidden`/`inline`の選択は**有効化の*方式***に関する指定と捉えるのが安全です。 [\[tsdown.dev\]](https://tsdown.dev/reference/api/typealias.sourcemap), [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)

### まとめ(リスト化)

**tsdown で“tsconfig が強く効く/優先しうる”主な項目一覧**:

1.  **モジュール解決**:`compilerOptions.baseUrl`、`compilerOptions.paths`(Rolldown のリゾルバが専用に利用) [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
2.  **トランスフォーム設定(tsdown 未指定なら tsconfig が有効)**:`jsx`、`experimentalDecorators`、`emitDecoratorMetadata`、`verbatimModuleSyntax`、`useDefineForClassFields`(tsdown の transform を明示した場合は tsdown が優先) [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)
3.  **ソースマップ関連**:
    - `declarationMap`(**true なら常に sourcemap が有効化**) [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)
    - `sourceMap`(**出力 `sourcemap` と整合させるのが前提**。不整合時は警告を招く設計が一般的) [\[typescriptlang.org\]](https://www.typescriptlang.org/tsconfig/sourceMap.html), [\[stackoverflow.com\]](https://stackoverflow.com/questions/63128597/how-to-get-rid-of-the-rollup-plugin-typescript-rollup-sourcemap-option-must)
    - `inlineSourceMap`(tsdown の `sourcemap: 'inline'` に対応する概念。ドキュメント整備進行中) [\[github.com\]](https://github.com/rolldown/tsdown/issues/442), [\[tsdown.dev\]](https://tsdown.dev/reference/api/typealias.sourcemap)
4.  **型定義生成**:`declaration`(tsdown の `dts` と連動)、`declarationMap`(前述のとおり sourcemap 強制) [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap)

> **注意**:tsdown 公式は「オプション体系と読み込み順(CLI > config > package.json)」の説明はありますが、**“tsconfig と tsdown の衝突時の完全リスト”を網羅的に列挙した一次ドキュメントは公開されていません**。上記リストは **tsdown 公式(Source Maps, Options Reference)と Rolldown 公式(tsconfig オプション)に基づく確定情報**+**ツールチェインの既知挙動**を統合したものです。 [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap), [\[deepwiki.com\]](https://deepwiki.com/rolldown/tsdown/4.1-options-reference), [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig)

### 実務ヒント

- **ライブラリ配布で `declarationMap: true` を使うとき**は、**tsdown の `sourcemap` は事実上“オン”前提**になる点に注意。テストや配布サイズの観点で `hidden`(コメントを埋め込まない)を選ぶのが現場では無難です。 [\[tsdown.dev\]](https://tsdown.dev/options/sourcemap), [\[tsdown.dev\]](https://tsdown.dev/reference/api/typealias.sourcemap)
- **パス解決の問題**が出たら、まず **tsconfig の `baseUrl`/`paths`** を確認。必要なら tsdown 側で Rolldown の input/ output オプションを上書きして微調整します。 [\[rolldown.rs\]](https://rolldown.rs/options/tsconfig), [\[tsdown.dev\]](https://tsdown.dev/advanced/rolldown-options)
