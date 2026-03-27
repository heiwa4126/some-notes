# GlassWorm 対策

ForceMemo と GlassWorm のメモ

## 検知と予防

「CI で Unicode 正規化(NFKC 等)後に差分検査」でおおむね検知できる。

## GitHub Action 版

[dcondrey/unicode-safety-check: GitHub Action to detect adversarial Unicode in PRs: invisible characters, bidi attacks, homoglyphs, PUA code points, and encoding issues. Zero-config, language-agnostic.](https://github.com/dcondrey/unicode-safety-check)
に action がある。

中身は簡単な bash

## CLI

### glassworm-hunter

- [afine-com/glassworm-hunter: Scan VS Code extensions, npm/PyPI packages, and local git repositories for GlassWorm supply chain attack indicators. Glassworm-hunter detects invisible Unicode payloads, decoder patterns, C2 markers, and known malicious IOCs.](https://github.com/afine-com/glassworm-hunter)
- [glassworm-hunter · PyPI](https://pypi.org/project/glassworm-hunter/)

### anti-trojan-source

- [anti-trojan-source - npm](https://www.npmjs.com/package/anti-trojan-source?activeTab=readme)
- [eslint-plugin-anti-trojan-source - npm](https://www.npmjs.com/package/eslint-plugin-anti-trojan-source)
- [lirantal/eslint-plugin-anti-trojan-source: ESLint plugin to detect and stop Trojan Source attacks](https://github.com/lirantal/eslint-plugin-anti-trojan-source)

### quickstart

```sh
uv tool install glassworm-hunter
glassworm-hunter update # ZScalerあると死ぬ
glassworm-hunter scan .

npm install -g anti-trojan-source
anti-trojan-source  --files='**/*.*'
```

## 誤検出(だと思うけど)

"Unicode 正規化(NFKC 等)後に差分検査"
なので、誤検出もけっこうある。

例:

```sh
git clone https://github.com/jgraph/drawio-i18n.git
cd drawio-i18n
glassworm-hunter scan .
anti-trojan-source --files='**/*.txt'
```

ヘブライ語の事情はよく分からない。
