# trivy メモ

## 概要

GitHub の Depandabot + Secret Scanning

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
