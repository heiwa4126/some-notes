# google/osv-scanner

ロックファイル等を見て、ヤバい依存パッケージをみつけるやつ。trivy に似てる

- [google/osv-scanner: Vulnerability scanner written in Go which uses the data provided by https://osv.dev](https://github.com/google/osv-scanner)
- [OSV-Scanner | Use OSV-Scanner to find existing vulnerabilities affecting your project’s dependencies.](https://google.github.io/osv-scanner/)

これ読んで知った:

[【npm】11 月 21 日以降に npm install した人へ - Shai-Hulud 感染チェック & 多層防御ガイド](https://zenn.dev/hand_dot/articles/04542a91bc432e)

## 概要

要は「依存関係に含まれる既知の脆弱性」を検出するツール

「依存関係に含まれる既知の脆弱性」は長いので

- 依存脆弱性 (dependency vulnerabilities)
- 依存関係の脆弱性
- SCA 脆弱性 (SCA = Software Composition Analysis)
- サプライチェーン脆弱性 (supply chain vulnerabilities)
- 自分のコードではなく、取り込んだ外部コンポーネントに起因する脆弱性

とも言う。

## インストール

Aqua だと `aqua g -i google/osv-scanner ; aqua i` でインストールできる。Linux でも Windows でも同様。

## 使い方と実行例

とりあえず作業ディレクトリで

```sh
osv-scanner -r .
```

で再帰的にスキャンしてくれる。

実行例:

```console
$ osv-scanner -v
osv-scanner version: 2.3.0
osv-scalibr version: 0.4.0
commit: b0b6027aa7b2b50fd3fe5fe185d609f481f02a44
built at: 2025-11-19T04:12:01Z

$ osv-scanner -r .

Scanning dir .
Starting filesystem walk for root: /
Scanned /home/user1/works/node/hello-signed/package-lock.json file and found 0 packages
Scanned /home/user1/works/node/aws-node2/package-lock.json file and found 109 packages
Scanned /home/user1/works/node/hello/package-lock.json file and found 0 packages
(略)
End status: 613 dirs visited, 1749 inodes visited, 18 Extract calls, 78.838016ms elapsed, 78.838081ms wall time
Total 47 packages affected by 55 known vulnerabilities (1 Critical, 16 High, 28 Medium, 8 Low, 2 Unknown) from 1 ecosystem.

55 vulnerabilities can be fixed.

+-------------------------------------+------+-----------+-----------------------------+---------+---------------+-----------------------------------------+
| OSV URL                             | CVSS | ECOSYSTEM | PACKAGE                     | VERSION | FIXED VERSION | SOURCE                                  |
+-------------------------------------+------+-----------+-----------------------------+---------+---------------+-----------------------------------------+
| https://osv.dev/GHSA-968p-4wvh-cqc8 | 6.2  | npm       | @babel/helpers (dev)        | 7.24.7  | 7.26.10       | hello-ts/package-lock.json              |
| https://osv.dev/GHSA-v6h2-p8h4-qcjw | 3.1  | npm       | brace-expansion (dev)       | 1.1.11  | 1.1.12        | hello-ts/package-lock.json              |
| https://osv.dev/GHSA-3xgq-45jj-v275 | 7.7  | npm       | cross-spawn (dev)           | 7.0.3   | 7.0.5         | hello-ts/package-lock.json              |
| https://osv.dev/GHSA-mh29-5h37-fv8m | 5.3  | npm       | js-yaml (dev)               | 3.14.1  | 3.14.2        | hello-ts/package-lock.json              |
| https://osv.dev/GHSA-mh29-5h37-fv8m | 5.3  | npm       | js-yaml (dev)               | 4.1.0   | 4.1.1         | hello-ts/package-lock.json              |
| https://osv.dev/GHSA-952p-6rrq-rcjv | 5.3  | npm       | micromatch (dev)            | 4.0.7   | 4.0.8         | hello-ts/package-lock.json              |
| https://osv.dev/GHSA-v6h2-p8h4-qcjw | 3.1  | npm       | brace-expansion (dev)       | 1.1.11  | 1.1.12        | npm-fizzbuzz/package-lock.json          |
| https://osv.dev/GHSA-mh29-5h37-fv8m | 5.3  | npm       | js-yaml (dev)               | 4.1.0   | 4.1.1         | npm-fizzbuzz/package-lock.json          |
| https://osv.dev/GHSA-952p-6rrq-rcjv | 5.3  | npm       | micromatch (dev)            | 4.0.7   | 4.0.8         | npm-fizzbuzz/package-lock.json          |
| https://osv.dev/GHSA-v6h2-p8h4-qcjw | 3.1  | npm       | brace-expansion (dev)       | 1.1.11  | 1.1.12        | npm-hello/package-lock.json             |
| https://osv.dev/GHSA-mh29-5h37-fv8m | 5.3  | npm       | js-yaml (dev)               | 4.1.0   | 4.1.1         | npm-hello/package-lock.json             |
| https://osv.dev/GHSA-952p-6rrq-rcjv | 5.3  | npm       | micromatch (dev)            | 4.0.7   | 4.0.8         | npm-hello/package-lock.json             |
+-------------------------------------+------+-----------+-----------------------------+---------+---------------+-----------------------------------------+
(長いのであちこち略)
```

## CI/CD

GitHub Actions あり。
[google/osv-scanner-action](https://github.com/google/osv-scanner-action)

なんか書き方が普通じゃないので
[GitHub Action | OSV-Scanner](https://google.github.io/osv-scanner/github-action/)
参照。

SARIF を生成して GitHub Security にレポートも出せるけど、脆弱性がないと空でつまらない。cron で週 1 ぐらいで回すといいんだな、たぶん。

npm / PyPI パッケージのプロジェクトなら Trivy よりお勧めらしい。

- npm なら `npm audit`
- PyPI なら `pip-audit`

を併用

※ ただし pip-audit は requirements.txt 前提で uv.lock をサポートしていない。

## GitHub Actions で Reusable Workflow を使うか、Action を使うか

- Reusable Workflow(の例): <https://github.com/google/osv-scanner-action/blob/main/.github/workflows/osv-scanner-reusable.yml>
- Action の方: [osv-scanner-action/osv-scanner-action/action.yml at 375a0e8ebdc98e99b02ac4338a724f5750f21213 · google/osv-scanner-action](https://github.com/google/osv-scanner-action/blob/375a0e8ebdc98e99b02ac4338a724f5750f21213/osv-scanner-action/action.yml)

Action の方は自由度は高い。CLI で osv-scanner する感覚に近い。事前に action/checkout が必要。

Reusable Workflow のほうは機能が高く(sarif、`--ghsa` オプション)、設定は簡単。
ただし steps に書けないので job にする。事前に action/checkout が不要(内部でやる)

## osv-scanner をテストする

pnpm を使う例

```sh
mkdir working1 && cd working1
pnpm init
pnpm add lodash@4.17.15
osv-scanner .
# または
osv-scanner scan -L pnpm-lock.yaml
# おまけで
pnpm audit
# さらにおまけだ
trivy fs .
grype .
```

出力例:

```console
$ osv-scanner .

Starting filesystem walk for root: /
Scanned /home/heiwa/works/tmp/working1/pnpm-lock.yaml file and found 1 package
End status: 0 dirs visited, 1 inodes visited, 1 Extract calls, 158.931μs elapsed, 158.979μs wall time
Total 1 package affected by 3 known vulnerabilities (0 Critical, 2 High, 1 Medium, 0 Low, 0 Unknown) from 1 ecosystem.
3 vulnerabilities can be fixed.

╭─────────────────────────────────────┬──────┬───────────┬─────────┬─────────┬───────────────┬────────────────╮
│ OSV URL                             │ CVSS │ ECOSYSTEM │ PACKAGE │ VERSION │ FIXED VERSION │ SOURCE         │
├─────────────────────────────────────┼──────┼───────────┼─────────┼─────────┼───────────────┼────────────────┤
│ https://osv.dev/GHSA-29mw-wpgm-hmr9 │ 5.3  │ npm       │ lodash  │ 4.17.15 │ 4.17.21       │ pnpm-lock.yaml │
│ https://osv.dev/GHSA-35jh-r3h4-6jhm │ 7.2  │ npm       │ lodash  │ 4.17.15 │ 4.17.21       │ pnpm-lock.yaml │
│ https://osv.dev/GHSA-p6mc-m468-83gw │ 7.4  │ npm       │ lodash  │ 4.17.15 │ 4.17.19       │ pnpm-lock.yaml │
╰─────────────────────────────────────┴──────┴───────────┴─────────┴─────────┴───────────────┴────────────────╯
```

以下おまけの出力:

```console
$ pnpm audit

┌─────────────────────┬────────────────────────────────────────────────────────┐
│ high                │ Command Injection in lodash                            │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Package             │ lodash                                                 │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Vulnerable versions │ <4.17.21                                               │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Patched versions    │ >=4.17.21                                              │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Paths               │ .>lodash                                               │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ More info           │ https://github.com/advisories/GHSA-35jh-r3h4-6jhm      │
└─────────────────────┴────────────────────────────────────────────────────────┘
┌─────────────────────┬────────────────────────────────────────────────────────┐
│ high                │ Prototype Pollution in lodash                          │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Package             │ lodash                                                 │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Vulnerable versions │ >=3.7.0 <4.17.19                                       │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Patched versions    │ >=4.17.19                                              │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Paths               │ .>lodash                                               │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ More info           │ https://github.com/advisories/GHSA-p6mc-m468-83gw      │
└─────────────────────┴────────────────────────────────────────────────────────┘
┌─────────────────────┬────────────────────────────────────────────────────────┐
│ moderate            │ Regular Expression Denial of Service (ReDoS) in lodash │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Package             │ lodash                                                 │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Vulnerable versions │ >=4.0.0 <4.17.21                                       │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Patched versions    │ >=4.17.21                                              │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ Paths               │ .>lodash                                               │
├─────────────────────┼────────────────────────────────────────────────────────┤
│ More info           │ https://github.com/advisories/GHSA-29mw-wpgm-hmr9      │
└─────────────────────┴────────────────────────────────────────────────────────┘
3 vulnerabilities found
Severity: 1 moderate | 2 high

$ trivy fs .

2026-01-08T16:32:29+09:00       INFO    [vulndb] Need to update DB
2026-01-08T16:32:29+09:00       INFO    [vulndb] Downloading vulnerability DB...
2026-01-08T16:32:29+09:00       INFO    [vulndb] Downloading artifact...        repo="mirror.gcr.io/aquasec/trivy-db:2"
79.87 MiB / 79.87 MiB [-----------------------------------------------------------------------] 100.00% 7.01 MiB p/s 12s
2026-01-08T16:32:44+09:00       INFO    [vulndb] Artifact successfully downloaded       repo="mirror.gcr.io/aquasec/trivy-db:2"
2026-01-08T16:32:44+09:00       INFO    [vuln] Vulnerability scanning is enabled
2026-01-08T16:32:44+09:00       INFO    [secret] Secret scanning is enabled
2026-01-08T16:32:44+09:00       INFO    [secret] If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2026-01-08T16:32:44+09:00       INFO    [secret] Please see https://trivy.dev/docs/v0.68/guide/scanner/secret#recommendation for faster secret detection
2026-01-08T16:32:44+09:00       INFO    Number of language-specific files       num=1
2026-01-08T16:32:44+09:00       INFO    [pnpm] Detecting vulnerabilities...

Report Summary

┌────────────────┬──────┬─────────────────┬─────────┐
│     Target     │ Type │ Vulnerabilities │ Secrets │
├────────────────┼──────┼─────────────────┼─────────┤
│ pnpm-lock.yaml │ pnpm │        4        │    -    │
└────────────────┴──────┴─────────────────┴─────────┘
Legend:
- '-': Not scanned
- '0': Clean (no security findings detected)


pnpm-lock.yaml (pnpm)

Total: 4 (UNKNOWN: 0, LOW: 0, MEDIUM: 1, HIGH: 3, CRITICAL: 0)

┌─────────┬────────────────┬──────────┬────────┬───────────────────┬───────────────┬──────────────────────────────────────────────────────────────┐
│ Library │ Vulnerability  │ Severity │ Status │ Installed Version │ Fixed Version │                            Title                             │
├─────────┼────────────────┼──────────┼────────┼───────────────────┼───────────────┼──────────────────────────────────────────────────────────────┤
│ lodash  │ CVE-2020-8203  │ HIGH     │ fixed  │ 4.17.15           │ 4.17.19       │ nodejs-lodash: prototype pollution in zipObjectDeep function │
│         │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2020-8203                    │
│         ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│         │ CVE-2021-23337 │          │        │                   │ 4.17.21       │ nodejs-lodash: command injection via template                │
│         │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2021-23337                   │
│         ├────────────────┤          │        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│         │ NSWG-ECO-516   │          │        │                   │ >=4.17.19     │ Allocation of Resources Without Limits or Throttling         │
│         │                │          │        │                   │               │ https://www.npmjs.com/advisories/1523                        │
│         ├────────────────┼──────────┤        │                   ├───────────────┼──────────────────────────────────────────────────────────────┤
│         │ CVE-2020-28500 │ MEDIUM   │        │                   │ 4.17.21       │ nodejs-lodash: ReDoS via the toNumber, trim and trimEnd      │
│         │                │          │        │                   │               │ functions                                                    │
│         │                │          │        │                   │               │ https://avd.aquasec.com/nvd/cve-2020-28500                   │
└─────────┴────────────────┴──────────┴────────┴───────────────────┴───────────────┴──────────────────────────────────────────────────────────────┘

$ grype .
 ✔ Indexed file system                                                                                                                                    .
 ✔ Cataloged contents                                                                      cdb4ee2aea69cc6a83331bbe96dc2caa9a299d21329efb0336fc02a82e1839a8
   ├── ✔ Packages                        [1 packages]
   ├── ✔ File digests                    [1 files]
   ├── ✔ Executables                     [0 executables]
   └── ✔ File metadata                   [1 locations]
 ✔ Scanned for vulnerabilities     [3 vulnerability matches]
   ├── by severity: 0 critical, 2 high, 1 medium, 0 low, 0 negligible
   └── by status:   3 fixed, 0 not-fixed, 0 ignored [0000]  WARN no explicit name and version provided for directory source, deriving artifact ID from the giv
NAME    INSTALLED  FIXED IN  TYPE  VULNERABILITY        SEVERITY  EPSS         RISK
lodash  4.17.15    4.17.19   npm   GHSA-p6mc-m468-83gw  High      3.4% (87th)  2.5
lodash  4.17.15    4.17.21   npm   GHSA-35jh-r3h4-6jhm  High      0.7% (72nd)  0.5
lodash  4.17.15    4.17.21   npm   GHSA-29mw-wpgm-hmr9  Medium    0.2% (47th)  0.1
```

### GitHub Actions の reuseable workflow を使って lodash のやつを試してみた

あたりまえだけど、おなじログが出る。SARIF はこんな感じ(結構大きいので貼るのやめた)。

重要:「GitHub の Code scanning alerts は、デフォルトブランチでのスキャン結果のみを Security タブに表示します。」

## この系統の製品まとめ

ここに書くのも変なんだけど
「プロジェクトのロックファイルから脆弱性をみつけるツール」のまとめ

### 軽量・無料・導入容易 (OSS 中心)

インストールが容易で実行が簡単で早くて無料。CI/CD でも使いやすい

- **パッケージマネージャ組込機能**
  - `npm audit`, `yarn audit`, `pnpm audit` (Node.js) - bun には audit がない
  - `pip-audit` (Python)
  - `cargo audit` (Rust)
- **osv-scanner**
  - Google 製。[OSV データベース](https://osv.dev/)を利用して`lockfile`や`SBOM`をスキャン
- **Trivy**
  - Aqua Security 製。コンテナ・ファイル・リポジトリ・SBOM 対応
- **Grype**
  - Anchore 製。コンテナやディレクトリをスキャン。デフォルトで再帰検索。lockfile は直接サポートしないので、SBOM 出してから、それをスキャン
- **Snyk CLI(無料枠あり)**
  - OSS 版は制限付きだが簡単に使える。`package.json`や`lockfile`対応。無料枠でもアカウント作ってログイン(`snyk auth`)する必要があるのでめんどくさい。
- **Safety**
  - Python 専用。`requirements.txt` や `pip` 環境をスキャン
- **Dependency-Check**
  - OWASP 製。Java や.NET など幅広い言語対応。Java が要るのがめんどい

### 高機能・有料・導入負荷大(エンタープライズ向け)

高機能だがインストールが面倒で有料で CI/CD で使うのは困難

- **Black Duck**(Synopsys)
  - OSS コンプライアンス+脆弱性管理。CI/CD 統合は可能だが重い。
- **SonarQube**(有料版)
  - 静的解析+セキュリティ。コード品質中心だが依存関係も一部対応。
- **Veracode**
  - SAST/DAST +ソフトウェアコンポジション解析(SCA)。
- **Checkmarx**
  - SAST 中心だが SCA 機能あり。
- **JFrog Xray**
  - アーティファクト管理+脆弱性スキャン。Artifactory と連携。
- **Snyk(有料プラン)**
  - CI/CD 統合、PR ベース修正提案など高機能。

### それ以外

前述の 2 種が主流だが、それに微妙に属さない製品

#### クラウドサービス型(SaaS)

無料枠あり・導入は簡単だが完全無料ではない

- **GitHub Advanced Security (Dependabot Alerts)**
  - GitHub に統合されていて、`lockfile`や依存関係を自動スキャン。OSS 利用なら無料だが、Enterprise 機能は有料。
- **GitLab Dependency Scanning**
  - GitLab CI/CD に統合。OSS 版でも基本機能あり、有料版で強化。
- **Snyk(無料枠あり)**
  - CLI は軽量だが、クラウド連携や PR 修正提案は有料。OSS プロジェクトなら無料で使える範囲が広い。

### SBOM から脆弱性検出

CI/CD で使いやすいが、単体では検出しない

- **CycloneDX + Dependency-Track**
  - CycloneDX で SBOM 生成 → Dependency-Track で脆弱性管理。OSS だが構築はやや複雑。
- **Syft(SBOM 生成) + Grype(スキャン)**
  - Anchore 製。組み合わせで強力だが、単体では「生成のみ」または「スキャンのみ」。

#### IDE 統合型

開発者向け、CI/CD ではなくローカルで使う

- **JetBrains Security Plugin**
  - IntelliJ 系 IDE で依存関係の脆弱性を検出。
- **VSCode 拡張(Snyk, SonarLint など)**
  - 開発中に警告を出すが、CI/CD 向けではない。

## osv-scanner vs Trivy vs Grype

3 つとも
[aqua](https://github.com/aquaproj/aqua)
でインストール・更新できる

- name: google/osv-scanner
- name: aquasecurity/trivy
- name: anchore/grype

※ aquasecurity と aquaproj は別物

### Trivy と Grype は脆弱性 DB 型

ローカル DB を更新して動く。

CI/CD だとキャッシュを構成するべき

### osv-scanner は API 型

Google OSV API で動く。オフラインモードあり

```sh
# 1. OSVデータをローカルに取得
git clone https://github.com/google/osv.git
# 2. スキャン時にオフラインモードを指定
osv-scanner --offline --local-db ./osv <lockfile>
```

## OSV(Open Source Vulnerabilities)

- **管理運営**:OSV.dev は Google と OpenSSF(Open Source Security Foundation)によって開発・運営されています。公式「OSV Team」によりメンテされています。 [\[osv.dev\]](https://osv.dev/), [\[osv.dev\]](https://osv.dev/blog/)
- **データソース**:GitHub Security Advisories、OSS‐Fuzz、PyPA、RustSec、Debian Security Tracker、Chainguard など 30 以上のエコシステム・ディストリビューションから情報を取り込み。[Data sources | OSV](https://google.github.io/osv.dev/data/)
- **更新頻度**:
  - データは継続的に取り込まれるため、**随時・リアルタイムに近い更新**が行われます。
  - ブログや SLO でも、「API クエリが高速化」「カバレッジ拡充」などに触れられており、最新版状態の維持を重視しています。 [\[osv.dev\]](https://osv.dev/blog/)

## NVD(National Vulnerability Database)

CVE(Common Vulnerabilities and Exposures)をだしてるところ。

- **管理機関**:NVD は米国 NIST(National Institute of Standards and Technology) ITL(Information Technology Laboratory)が運営しています。 [\[nist.gov\]](https://www.nist.gov/itl/nvd), [\[inventivehq.com\]](https://inventivehq.com/blog/nvd-database-update-frequency-and-cve-enrichment-timeline)
- **更新フロー**:
  1.  MITRE が CVE ID を割り当てる → CVE リスト公開
  2.  NIST が NVD に **自動インジェスト**(毎時間実行) → CVE データ取り込み [\[inventivehq.com\]](https://inventivehq.com/blog/nvd-database-update-frequency-and-cve-enrichment-timeline), [\[nist.gov\]](https://www.nist.gov/itl/nvd)
  3.  NIST アナリストが CVSS スコア、CWE 分類、CPE マッピングなど**データの精緻化(エンリッチ)作業**を実施 [\[inventivehq.com\]](https://inventivehq.com/blog/nvd-database-update-frequency-and-cve-enrichment-timeline), [\[nist.gov\]](https://www.nist.gov/itl/nvd)
- **頻度**:
  - 基本的に **毎時間** CVE を取り込み
  - エンリッチされた情報(スコア付与など)は **数時間〜数日単位で随時更新**。 [\[inventivehq.com\]](https://inventivehq.com/blog/nvd-database-update-frequency-and-cve-enrichment-timeline), [\[dev.housin...rizona.edu\]](https://dev.housing.arizona.edu/how-often-is-the-nvd-updated)
  - 日々 10〜20 件の新規 CVE と、数件の既存エントリ更新が行われています。 [\[inventivehq.com\]](https://inventivehq.com/blog/nvd-database-update-frequency-and-cve-enrichment-timeline), [\[dev.housin...rizona.edu\]](https://dev.housing.arizona.edu/how-often-is-the-nvd-updated)

### エンリッチ(enrich)

基本情報に追加の詳細や付加価値を加える処理のことです。
NVD の場合、MITRE から受け取った CVE の「最低限の情報」(ID、概要)に対して、次のような追加作業をします:

- CVSS スコア(脆弱性の深刻度を数値化)
- CWE 分類(脆弱性の種類)
- CPE マッピング(影響を受ける製品やバージョンの特定)
- 関連リンクやパッチ情報の追加

このプロセスによって、単なる「脆弱性 ID のリスト」が、リスク評価や対策判断に使える豊富なデータセットに変わります。
要するに、「エンリッチ」= 情報を充実させることです。

## Trivy の脆弱性 DB (trivy‐db)

- **ビルド担当**:Aqua Security チームが管理する `trivy-db` リポジトリが、主要な更新源です。 [\[github.com\]](https://github.com/aquasecurity/trivy-db), [\[trivy.dev\]](https://trivy.dev/docs/latest/community/contribute/vulnerability-database/overview/)
- **構成フロー**:
  1.  **`vuln-list-update`** リポジトリ:Cron ジョブで NVD、GHSA、各 Linux ディストリビューションのアドバイザリ等を定期取得し `vuln-list` に格納。 [\[trivy.dev\]](https://trivy.dev/docs/latest/community/contribute/vulnerability-database/overview/)
  2.  **`trivy-db`** リポジトリ:`vuln-list` のデータを受け取り、Trivy 独自形式に加工し、6 時間ごとに OCI レジストリへビルド・公開。 [\[github.com\]](https://github.com/aquasecurity/trivy-db), [\[trivy.dev\]](https://trivy.dev/docs/latest/community/contribute/vulnerability-database/overview/)
- **更新間隔**:おおよそ **6 時間ごと** に最新化されます。 [\[github.com\]](https://github.com/aquasecurity/trivy-db), [\[trivy.dev\]](https://trivy.dev/docs/latest/community/contribute/vulnerability-database/overview/)
- **データ元**:NVD、Red Hat、Debian、GitHub Advisory、その他多数のアドバイザリを統合。 [\[github.com\]](https://github.com/aquasecurity/trivy-db), [\[deepwiki.com\]](https://deepwiki.com/aquasecurity/trivy-db)

## Grype の脆弱性 DB (vulnerability.db)

- **ビルド&メンテナ**:Anchore(開発元)が提供する `grype-db` ツールと `vunnel` を使って CI(GitHub Actions)で自動的に daily 更新。 [\[cloudsecurity.org\]](https://cloudsecurity.org/tool/grype), [\[dev.to\]](https://dev.to/chainguard/deep-dive-where-does-grype-data-come-from-n9e)
- **更新フロー**:
  1.  **vunnel ツール**:NVD、Red Hat、Debian、GHSA、Canonical、Ubuntu、Alpine などのアドバイザリを収集し標準化。 [\[dev.to\]](https://dev.to/chainguard/deep-dive-where-does-grype-data-come-from-n9e)
  2.  **grype-db ツール**:収集データを SQLite 形式の `vulnerability.db` にまとめる。 [\[cloudsecurity.org\]](https://cloudsecurity.org/tool/grype), [\[dev.to\]](https://dev.to/chainguard/deep-dive-where-does-grype-data-come-from-n9e)
  3.  **日時頻度**:**毎日** GitHub Actions によりビルド・公開されます。 [\[cloudsecurity.org\]](https://cloudsecurity.org/tool/grype), [\[dev.to\]](https://dev.to/chainguard/deep-dive-where-does-grype-data-come-from-n9e)
- **DB の構造**:SQLite v6 スキーマを採用し、ブロブ型ストレージ&インデックス付き。 [\[deepwiki.com\]](https://deepwiki.com/anchore/grype/2.2-vulnerability-database-system), [\[dev.to\]](https://dev.to/chainguard/deep-dive-where-does-grype-data-come-from-n9e)

## 速報性で比較すると

1. Dependabot (GitHub ネイティブ、最速)
1. npm audit (GitHub Advisory 統合済み)
1. Snyk (独自 DB + GitHub Advisory)
1. osv-scanner (OSV 経由で GitHub Advisory)
1. trivy (複数 DB 統合)

`npm audit`は代表で、pip-audit([PyPI Advisory Database](https://github.com/pypa/advisory-database)使用)など

## pip-audit デモ

```sh
uv init working2 --build-backend uv && cd working2
uv add pip-audit --dev

# 脆弱性があるパッケージをインストール
# 例: Django 2.2.0 (複数の既知の脆弱性あり)
uv add django==2.2.0

# pip-auditで検出
uv run pip-audit

# おまけ
osv-scanner . # osv-scannerで検出
trivy fs .    # trivyで検出
grype .       # grypeで検出
```

## 言い方

「依存関係まわりの脆弱性」を指す用語はむやみにたくさんある。
Perplexity にリストを作ってもらった。

### 「依存関係の脆弱性」を直接指す言い方

- 既知の脆弱性を持つコンポーネントの利用 / 使用[3]
- 既知の脆弱性を含むコンポーネント / ライブラリ / パッケージ[4][3]
- 脆弱なコンポーネント / ライブラリ / パッケージ / OSS コンポーネント[6][3][4]
- 脆弱な依存パッケージ / 依存コンポーネント[5][10]
- 依存関係に起因する脆弱性 / 依存関係由来の脆弱性[1][5]
- オープンソースの脆弱性 / OSS の脆弱性(管理)[2][6]

### SCA・サプライチェーン文脈の言い方

- ソフトウェアサプライチェーンの脆弱性 / リスク[5][6]
- ソフトウェアサプライチェーンセキュリティのリスク[6]
- サードパーティコンポーネントの脆弱性 / サードパーティ依存の脆弱性[3][5]
- ソフトウェア構成(コンポジション)の脆弱性 / OSS 構成の脆弱性[2][4][6]

### 「依存関係ツリー」や階層性に言及する言い方

- 間接依存関係に潜む脆弱性 / 深い階層の依存関係に潜む脆弱性[4][1]
- 依存関係の依存関係(transitive dependencies)の脆弱性[4]
- 依存関係ツリー全体に内在する脆弱性 / 依存グラフに内在する脆弱性[6][4]

### 攻撃手法寄りの言い方(広義には同じ領域)

これらは狭義には「脆弱性」より「攻撃」ですが、実務では依存関係・サプライチェーン脆弱性の話とセットで同列に語られます。[7][1][5]

- 依存関係混乱攻撃(Dependency Confusion / 依存関係かく乱攻撃)[7][1]
- パッケージのタイポスクワッティング(typosquatting)[1][7]
- マリシャスパッケージ(悪意あるパッケージ)[7]
- サプライチェーン攻撃(ソフトウェアサプライチェーン攻撃)[5][1][6]

### ツール・管理側から見た呼び方

- OSS 脆弱性管理 / OSS コンポーネントの脆弱性管理[8][2][6]
- 依存関係の脆弱性管理 / 依存関係リスク管理[10][5][6]
- オープンソースパッケージの既知の脆弱性(検出)[8][4]
- SCA による OSS 脆弱性の可視化 / 依存関係の可視化[2][8][6]

このあたりを組み合わせれば、「依存関係に含まれる既知の脆弱性」を少しニュアンスを変えて表現したいときにかなりバリエーションを持たせられると思います。

[1]: https://guardian.jpn.com/security/cloud-supply/vulnerable-dependencies/
[2]: https://www.hitachi-solutions.co.jp/sbom/blog/2021120106/
[3]: https://www.jhipster.tech/jp/dependency-vulnerabilities-check/
[4]: https://www.paloaltonetworks.jp/cyberpedia/what-is-sca
[5]: https://japanese.opswat.com/blog/managing-dependency-vulnerabilities-in-your-software-supply-chain
[6]: https://yamory.io/blog/about-sca
[7]: https://yamory.io/blog/about-malicious-package
[8]: https://www.ricksoft.jp/blog/articles/001258.html
[9]: https://blog.serverworks.co.jp/web-security-basic-terms-guide
[10]: https://zenn.dev/mavericks/articles/5c7c6a4aa7955b

## 使い分け

小規模なパッケージだったら `pnpm audit`(類) で十分。

npmjs(等)にパブリッシュするときに osv-scanner(等)使うのはありだと思う。
