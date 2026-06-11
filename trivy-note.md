# Trivy メモ

GitHub の Dependabot + Secret Scanning みたいなやつ。
"Code Scanning"ではないので「このプロジェクトの XSS 見つけろ」みたいのはできない。
他、設定ファイルのベストプラクティスを知っていて(例えば[Top 22 Docker Security Best Practices: Ultimate Guide](https://www.aquasec.com/blog/docker-security-best-practices/))、従ってないと警告してくる。

## 公式のリンク

- [Trivy Home - Trivy](https://trivy.dev/)
- [Overview - Trivy](https://aquasecurity.github.io/trivy/)
  - [aquasecurity/trivy: Find vulnerabilities, misconfigurations, secrets, SBOM in containers, Kubernetes, code repositories, clouds and more](https://github.com/aquasecurity/trivy)
- [Trivy Action · Actions · GitHub Marketplace](https://github.com/marketplace/actions/trivy-action)
  - [aquasecurity/trivy-action: Runs Trivy as GitHub action to scan your Docker container image for vulnerabilities](https://github.com/aquasecurity/trivy-action)
- [趣味で作ったソフトウェアが海外企業に買われるまでの話 - knqyf263's blog](https://knqyf263.hatenablog.com/entry/2019/08/20/120713) - Trivy の作者(2019-08-20)
- [趣味で作ったソフトウェアが海外企業に買われ分野世界一になるまでの話 - knqyf263's blog](https://knqyf263.hatenablog.com/entry/2021/07/29/143500) - Trivy の作者(2021-07-29)

### 発音

<https://aquasecurity.github.io/trivy/latest/getting-started/faq/#how-to-pronounce-the-name-trivy>

「**tri**gger(引き金) と en**vy**(妬み) の発音」だそうです。ˈtrivē

## ローカルのプロジェクトだったらとりあえず

プロジェクトルートで

```sh
trivy fs .
trivy config .
```

でスキャンできる。Python の仮想環境を使うプロジェクト、例えば Hatch だったら

```sh
hatch run trivy fs .
hatch run trivy config .
```

的にやる。

## docker image をスキャンするとき

`--ignore-unfixed` オプションはつけたほうがいい。
ディストリで対応してないものは簡単に対策しようもないし。

例:

```sh
trivy image python:3-slim
# ↑↓の2つを比べてみて
trivy image python:3-slim --ignore-unfixed
```

参考:

[Filtering - Trivy](https://aquasecurity.github.io/trivy/latest/docs/configuration/filtering/#by-status)
の "By Status" 節の一番下。

例: 2024-07-08

```console
$ trivy image python:3-slim --ignore-unfixed
2024-07-08T15:31:56+09:00       INFO    Need to update DB
2024-07-08T15:31:56+09:00       INFO    Downloading DB...       repository="ghcr.io/aquasecurity/trivy-db:2"
49.62 MiB / 49.62 MiB [-----------------------------------------------------------------------------------------------------------------------------------------] 100.00% 20.17 MiB p/s 2.7s
2024-07-08T15:32:00+09:00       INFO    Vulnerability scanning is enabled
2024-07-08T15:32:00+09:00       INFO    Secret scanning is enabled
2024-07-08T15:32:00+09:00       INFO    If your scanning is slow, please try '--scanners vuln' to disable secret scanning
2024-07-08T15:32:00+09:00       INFO    Please see also https://aquasecurity.github.io/trivy/v0.53/docs/scanner/secret#recommendation for faster secret detection
2024-07-08T15:32:02+09:00       INFO    Detected OS     family="debian" version="12.6"
2024-07-08T15:32:02+09:00       INFO    [debian] Detecting vulnerabilities...   os_version="12" pkg_num=106
2024-07-08T15:32:02+09:00       INFO    Number of language-specific files       num=1
2024-07-08T15:32:02+09:00       INFO    [python-pkg] Detecting vulnerabilities...
2024-07-08T15:32:02+09:00       WARN    Using severities from other vendors for some vulnerabilities. Read https://aquasecurity.github.io/trivy/v0.53/docs/scanner/vulnerability#severity-selection for details.

python:3-slim (debian 12.6)

Total: 8 (UNKNOWN: 0, LOW: 0, MEDIUM: 8, HIGH: 0, CRITICAL: 0)

┌──────────────────┬────────────────┬──────────┬────────┬───────────────────┬──────────────────┬────────────────────────────────────────────┐
│     Library      │ Vulnerability  │ Severity │ Status │ Installed Version │  Fixed Version   │                   Title                    │
├──────────────────┼────────────────┼──────────┼────────┼───────────────────┼──────────────────┼────────────────────────────────────────────┤
│ libgssapi-krb5-2 │ CVE-2024-37370 │ MEDIUM   │ fixed  │ 1.20.1-2+deb12u1  │ 1.20.1-2+deb12u2 │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37370 │
│                  ├────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│                  │ CVE-2024-37371 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37371 │
├──────────────────┼────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│ libk5crypto3     │ CVE-2024-37370 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37370 │
│                  ├────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│                  │ CVE-2024-37371 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37371 │
├──────────────────┼────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│ libkrb5-3        │ CVE-2024-37370 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37370 │
│                  ├────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│                  │ CVE-2024-37371 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37371 │
├──────────────────┼────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│ libkrb5support0  │ CVE-2024-37370 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37370 │
│                  ├────────────────┤          │        │                   │                  ├────────────────────────────────────────────┤
│                  │ CVE-2024-37371 │          │        │                   │                  │ krb5: GSS message token handling           │
│                  │                │          │        │                   │                  │ https://avd.aquasec.com/nvd/cve-2024-37371 │
└──────────────────┴────────────────┴──────────┴────────┴───────────────────┴──────────────────┴────────────────────────────────────────────┘
```

少し待つと debian:bookworm-slim 経由で python:3-slim にも反映されると思われる。

## trivy が対応している OS や設定ファイル

OS と言語
[Vulnerability - Trivy](https://aquasecurity.github.io/trivy/latest/docs/scanner/vulnerability/)

設定ファイルは
[Overview - Trivy](https://aquasecurity.github.io/trivy/latest/docs/scanner/misconfiguration/)

シークレットは
[Secret - Trivy](https://aquasecurity.github.io/trivy/latest/docs/scanner/secret/)
全貌はソースをみろ、って書いてある。

- [trivy/pkg/fanal/secret/builtin-rules.go at main · aquasecurity/trivy](https://github.com/aquasecurity/trivy/blob/main/pkg/fanal/secret/builtin-rules.go)
- [trivy/pkg/fanal/secret/builtin-allow-rules.go at main · aquasecurity/trivy](https://github.com/aquasecurity/trivy/blob/main/pkg/fanal/secret/builtin-allow-rules.go)

## ライセンスのスキャン

fs の場合の例:

```sh
trivy fs --scanners license --severity HIGH,CRITICAL .
```

`--severity ...` を消すと
全部の依存パッケージのライセンスが表示されるけど、
まあ普通はそれを知りたいとは思わない。

参考: [License - Trivy](https://trivy.dev/docs/latest/scanner/license/)

### CRITICAL と HIGH について

Trivy のライセンス分類は **Google License Classification** をベースにしており、分類と severity の対応はこうなっています:

| Classification                     | Severity     |
| ---------------------------------- | ------------ |
| **Forbidden**                      | **CRITICAL** |
| **Restricted**                     | **HIGH**     |
| Reciprocal                         | MEDIUM       |
| Notice / Permissive / Unencumbered | LOW          |
| Unknown                            | UNKNOWN      |

で、

| Severity     | 特徴                                                                                                      |
| ------------ | --------------------------------------------------------------------------------------------------------- |
| **CRITICAL** | 商用利用が事実上禁止 or ソース公開義務がネット配布にも及ぶ(AGPLなど)                                      |
| **HIGH**     | 強いコピーレフト。プロダクトに組み込むと**派生物全体のソース公開が必要**になりうる(GPL, LGPL, CC-SA など) |

プロプライエタリなプロダクトや SaaS で依存ライブラリを使う場合に引っかかりやすいのが HIGH (Restricted) なので、`--severity HIGH,CRITICAL` は実用的な設定といえます。

#### CRITICAL (Forbidden) — 使用自体が禁じられるライセンス

Google の分類で「Forbidden」とされるライセンスで、ドキュメント中の例では AGPL-3.0 が代表例として挙げられています。
**ネットワーク越しに提供するソフトウェアにもソース公開義務を課す**など、商用プロダクトへの組み込みがほぼ不可能なもの。

#### HIGH (Restricted) — 強いコピーレフトを持つライセンス

「派生物を同じライセンスで公開しなければならない」という**強いコピーレフト条件**を持つライセンスです。
デフォルト設定から読み取れる典型的な性質:

- **GPL 系** — ソース全体の公開義務、リンクした全コードへの伝播
- **LGPL 系** — GPL より緩いが動的リンクでも条件あり
- **CC-BY-SA / CC-BY-ND / CC-BY-NC 系** — 改変禁止・非商用限定・継承義務など
- **Commons-Clause 付きライセンス** — 商用利用を明示制限する追加条項
- **OSL / QPL / NPL 系** — ネット配布にも公開義務が及ぶもの
- **Sleepycat / WTFPL** など — 商用条件や公序良俗上の問題があるもの

## 公開鍵を利用できないため、以下の署名は検証できませんでした: NO_PUBKEY 35B8ACA44FD9CA9F (2026-04)

以下のコマンドで公開鍵を再登録:

```bash
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | \
  gpg --dearmor | \
  sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
```

次に、リポジトリの設定が鍵を参照しているか確認:

```bash
cat /etc/apt/sources.list.d/trivy.list
```

以下のように `signed-by` が指定されていればOK:

```
deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb jammy main
```

最後に再度 `sudo apt update` を実行
