# AGENTS.md と SKILL.md (Agent Skills)

## 標準

- <https://agents.md/>
- <https://skill.md/> (<https://agentskills.io/home> にリダイレクト)

instructions.md には AGENTS.md や SKILL.md のような標準はない。
各ツールごとにバラバラ。

## SKILL.md 注意事項

置く場所とファイル名が固定。

参考:

- [Creating agent skills for GitHub Copilot - GitHub Docs](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/create-skills)
- [Use Agent Skills in VS Code](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Claude をスキルで拡張する - Claude Code Docs](https://code.claude.com/docs/ja/skills)

GitHub Copilot の場合

- パスは `.github/skills/*/SKILL.md` で固定。`SKILL`は大文字
- フロントマターの name: は `*` と同じもの
- `*`は 1〜64 文字の小文字英数字とハイフンのみ

Claude Code は `.claude/skills/*/SKILL.md`で以下同様らしい。

なんでこんな制約があるか?

1. 関連ファイルの遅延読み込み(Progressive Loading)のため
2. スキャンとインデックス化の高速化
3. 名前の競合(重複)を OS レベルで防ぐため

あと上のパスは「プロジェクト単位」の場合。Project 以外に
Personal, Plugin, Enterprise がある。

VSCode は SKILLs をあちこちから読む。
VSCode 設定の `chat.agentSkillsLocations` 参照。

## AGENTS.md や SKILL.md が期待どおりに動いていることを確認する方法は?

### ロード確認

「このタスクを始める前に、利用可能な指示ファイルをすべて確認して、何が書かれているか教えてください」

### 記述内容を確認する

- 「あなたの現在の役割と、遵守すべきルール(制約事項)を 3 つ教えてください」
- 「あなたが現在実行可能なツールやスキルをリストアップし、それぞれの簡単な使い方を説明してください」

### 記述したタスクを実行させてみる

- 「ユニットテストを実行して」
- 「スモークテストを実行して」(スモークテストはビルド後に実行するように指示してある)

### スラッシュコマンドで skill を実行

`name: foo-bar` だったら chat から `/foo-bar` で呼び出せる。

### あえて記述されたルールに反することを指示する

- 「uv run test を使う」と SKILL に書いて、「pytest でテストして」と指示するなど

### 確認コード

AGENTS.md に

```markdown
## 確認コード

このファイルを読んだら、タスク開始時に
"[AGENTS.md 読み込み完了]"とログに出力してください。
```

のようなものを埋め込む。

他

- 「PR 本文の末尾に必ず Agent-Rule:XYZ を入れる」
- 「回答の最後に #agent-ok を 1 行だけ付ける」
- 「テスト実行コマンドは必ず uv run test を使う(別コマンド禁止)」など

SKILL の方は

```markdown
---
name: skill-smoke-test
description: '「スモーク」または「skill-smoke-test」と言われたら必ず使う。出力に [SKILL:smoke] を含める。'
---

# Smoke Test

- このスキルを使ったら、最初の行に必ず `[SKILL:smoke]` と出力すること
```

「センチネル(検査用)スキル」というらしい。

### ログとトレースの確認

(TODO)

## コンセプト

AGENTS.md はセッション初期に常時コンテキストとして与えられるが、
LLM のコンテキストウィンドウ制限により、
セッションが長くなると影響が弱くなる。
そのため、必要なときだけ追加コンテキストとして読み込める
オンデマンド機構として SKILL.md が導入された。

SKILL.md は
AGENTS.md を 短く保つため に導入された仕組み

SKILL.md は最初から、次を前提に設計されています。

- 常時は読まれない
- 必要なときだけロードされる
- タスク単位で完結している
- 読み終わったら捨ててよい

つまり:  
「長期記憶」ではなく
「必要なときに取りに行くマニュアル」

- コンテキストウィンドウ節約
- 影響範囲の限定
- 長時間セッションでの安定性

## フロントマター

- [フロントマターリファレンス](https://code.claude.com/docs/ja/skills#%E3%83%95%E3%83%AD%E3%83%B3%E3%83%88%E3%83%9E%E3%82%BF%E3%83%BC%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9)
- [Header \(required\)](https://code.visualstudio.com/docs/copilot/customization/agent-skills#_header-required)

## Instructions file vs SKILL.md

[Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_instructions-file-format)
にある 'Python standard' のようなのは SKILL.md に置き換えにくい。

## VSCode Github Copilot の場合 (2026-02現在)

- .github/copilot-instructions.md - always-on instruction または [Repository-wide custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#repository-wide-custom-instructions)
- .github/instructions/\*.instructions.md - [Path-specific custom instructions](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#path-specific-custom-instructions)
- .github/skills/\*/SKILL.md - Agent skills

の3つ。これに加えて AGENTS.md [Adding custom instructions for GitHub Copilot CLI \- GitHub Docs](https://docs.github.com/en/copilot/how-tos/copilot-cli/customize-copilot/add-custom-instructions#agent-instructions)

優先度は

1. (弱い) copilot-instructions.md
2. AGENTS.md
3. \*.instructions.md
4. (強い) SKILL.md

AGENTS.md の優先度は

1. (弱い) .github/AGENTS.md
2. 親の親の親の... AGENTS.md
3. 親の親の AGENTS.md
4. 親の AGENTS.md
5. (強い) カレントディレクトリの AGENTS.md

オンデマンドに適応されるのは SKILLs だけ。
