# Kiro メモ

[Kiro: Agentic AI development from prototype to production](https://kiro.dev/)

## Kiro IDE はオフライン環境では使えない

Kiro IDE は Kiro なしでは事実上利用不可

ドキュメントで「standalone agentic IDE」と記載があるが、これは「AWS サービス連携なしで動作可能」という意味であり、
AI 機能を外せるという意味ではない

[Kiro: Agentic AI development from prototype to production](https://kiro.dev/#how-can-i-get-started-with-kiro)

## AGENTS.md を分解しなけりゃいけないらしい

- Steering: `.kiro/steering/` - [Steering - IDE - Docs - Kiro](https://kiro.dev/docs/steering/)
- Specs: `.kiro/specs/` - [Specs - IDE - Docs - Kiro](https://kiro.dev/docs/specs/)
- Hooks: `.kiro/hooks/` - [Hooks - IDE - Docs - Kiro](https://kiro.dev/docs/hooks/)

簡単なまとめ:

- Steering →「プロジェクトのルール・方針」を記述 (AI の行動指針)
- Specs →「要件・設計・タスク」を構造化 (仕様駆動開発)
- Hooks →「イベント駆動の自動化」(AI によるワークフロー効率化)

Steering のデフォルト:

- product.md : 製品概要 (目的・ターゲット・ビジネス目標)
- tech.md : 技術スタック (使用するフレームワーク・ライブラリ)
- structure.md : プロジェクト構造 (ディレクトリ構成・命名規則)

なんかめんどくさそうだけど、たぶん「AGENTS.md を分解して」って頼めばいいと思う。
