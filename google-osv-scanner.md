# google/osv-scanner

ロックファイル等を見て、ヤバい依存パッケージをみつけるやつ。trivy に似てる

- [google/osv-scanner: Vulnerability scanner written in Go which uses the data provided by https://osv.dev](https://github.com/google/osv-scanner)
- [OSV-Scanner | Use OSV-Scanner to find existing vulnerabilities affecting your project’s dependencies.](https://google.github.io/osv-scanner/)

これ読んで知った:

[【npm】11 月 21 日以降に npm install した人へ - Shai-Hulud 感染チェック & 多層防御ガイド](https://zenn.dev/hand_dot/articles/04542a91bc432e)

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

## この系統の製品まとめ

ここに書くのも変なんだけど
「プロジェクトのロックファイルから脆弱性をみつけるツール」のまとめ

### 軽量・無料・導入容易 (OSS 中心)

インストールが容易で実行が簡単で早くて無料。CI/CD でも使いやすい

- **osv-scanner**
  - Google 製。OSV データベースを利用して`lockfile`や`SBOM`をスキャン
- **Trivy**
  - Aqua Security 製。コンテナ・ファイル・リポジトリ・SBOM 対応
- **パッケージマネージャ組込機能**
  - `npm audit` (Node.js)
  - `yarn audit`
  - `pip-audit` (Python)
  - `cargo audit` (Rust)
- **Grype**
  - Anchore 製。コンテナやディレクトリをスキャン。SBOM 対応
- **Snyk CLI(無料枠あり)**
  - OSS 版は制限付きだが簡単に使える。`package.json`や`lockfile`対応
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
