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
