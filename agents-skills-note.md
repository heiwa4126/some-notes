# AGENTS.md と SKILL.md (Agent Skills)

「エージェントスキルは、専門知識とワークフローを使用して AI エージェントの機能を拡張するための軽量でオープンな形式です」

「スキルはコンテキストの遅延ロード」

## 標準

- <https://agents.md/>
- <https://skill.md/> (<https://agentskills.io/home> にリダイレクト)

instructions.md には AGENTS.md や SKILL.md のような標準はない。
各ツールごとにバラバラ。

## スキルのサンプル

[anthropics/skills: Public repository for Agent Skills](https://github.com/anthropics/skills?tab=readme-ov-file)

たとえば Excelのスキル例:
[skills/skills/xlsx/SKILL.md at main · anthropics/skills](https://github.com/anthropics/skills/blob/main/skills/xlsx/SKILL.md)

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
- 「スモークテストを実行して」(スモークテストはビルド後に実行するようにSKILL.md中に指示してある)

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

バリエーションとして

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

最大の誤解は:
"SKILL.md = Agentの能力定義"
ではなく本来は:
"SKILL.md = AGENTS.mdから切り出した巨大テキスト"
という点です。

SKILL.mdはMCPツールではなくlazy-loaded prompt chunk
(遅延ロードされた巨大プロンプト)

参考:

- [Agent Skillsの作り方とベストプラクティス 徹底解説|まさお@未経験からプロまでAI活用](https://note.com/masa_wunder/n/nffa03e1d5999)
- [「保存されたプロンプト」じゃない!Agent Skills の本質を理解して最初の Skill を作る #AI - Qiita](https://qiita.com/dai_chi/items/43b912c5896357906ee9)
- [Cursorの5つの指示方法を比較してみた:AGENTS.md、ルール、コマンド、スキル、サブエージェントの使い分け](https://zenn.dev/redamoon/articles/article38-cursor-skills-rules-commands)
- [Skills - Docs by LangChain](https://docs.langchain.com/oss/python/deepagents/skills)
- [What are skills? - Agent Skills](https://agentskills.io/what-are-skills)
- [agents-md by getsentry/skills](https://skills.sh/getsentry/skills/agents-md)

## フロントマター

- [フロントマターリファレンス](https://code.claude.com/docs/ja/skills#%E3%83%95%E3%83%AD%E3%83%B3%E3%83%88%E3%83%9E%E3%82%BF%E3%83%BC%E3%83%AA%E3%83%95%E3%82%A1%E3%83%AC%E3%83%B3%E3%82%B9)
- [Header \(required\)](https://code.visualstudio.com/docs/copilot/customization/agent-skills#_header-required)

## Instructions file vs SKILL.md

Claudeの'Rules'

[Use custom instructions in VS Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions#_instructions-file-format)
にある 'Python standard' のようなのは SKILL.md に置き換えにくい。

で 'Python standard' のようなのは per-user で置ければいいのだが、
いまのところそれはないみたい。VSCodeの「プロファイル単位」でおけるらしい。

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

## SKILLはMCPと違って、instructions処理時点でname/descriptionを読まない??

(MCPは tool/description/schema)

VSCodeの場合はよくわからないけど
Claudeの場合は
(https://code.claude.com/docs/ja/features-overview#skills)
最初に読むみたいですよ。

## Hooks

とりあえず VSCode Copilot 版の話で
[Agent hooks in Visual Studio Code (Preview)](https://code.visualstudio.com/docs/copilot/customization/hooks)

以下 Copilotにまとめてもらったもの(間違いあるかも)。
まあ上のリンクの翻訳みたいではある。

---

Agent hooks(VS Code の Copilot Agent hooks / Preview)は、**エージェント・セッションのライフサイクル上の決まったタイミングで、こちらが用意したシェルコマンド(スクリプト)を必ず実行**させたい場合に使います。

「プロンプトで指示する(=従わない可能性がある)」のではなく、**決定的(deterministic)に自動化・制御**できるのがポイントです。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

### いつ使うべきか(典型ケース)

VS Code のドキュメントが挙げている “Why use hooks?” の用途を、実務に落とし込むと次のようになります。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 1) セキュリティ/ガードレールを「強制」したい

- 例:`rm -rf` や `DROP TABLE` のような破壊的操作を、エージェントが提案・実行しようとしても**事前にブロック**する。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- 例:インフラ変更(Terraform、kubectl など)や push 操作など、危険度の高いツールは**必ず手動承認にする**(auto-approve させない)。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 2) 品質チェックを「自動で必ず回す」

- 例:エージェントがファイルを編集したら、**自動で formatter / linter / unit test を走らせる**。  
  (「最後にテストして」と言うだけでは抜けがちですが、hook なら PostToolUse 等で強制できます。) [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 3) 監査ログ/コンプライアンスのために記録したい

- 例:誰がどんなプロンプトを投げ、どのツールを呼び、どんなコマンドを実行したかを**ログに残す**。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks), [\[docs.github.com\]](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks)

#### 4) コンテキスト注入を「毎回確実に」やりたい

- 例:セッション開始時に「プロジェクト名・ブランチ・ランタイムバージョン」などを自動で注入する。  
  (人間が毎回書く必要がなく、漏れません。) [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 5) 会話圧縮(PreCompact)前に、重要情報を退避したい

- 例:コンテキストが長くなり圧縮される前に、重要な決定事項・TODO をファイルに保存する。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

### どのタイミングで動かせるか(理解の要点)

VS Code はエージェント・セッション中の複数イベントで hook を発火できます(SessionStart / UserPromptSubmit / PreToolUse / PostToolUse / PreCompact / SubagentStart / SubagentStop / Stop)。  
hook は **stdin で JSON 入力**を受け取り、**stdout に JSON 出力**を返して、実行を止めたり追加コンテキストを注入したりできます。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

### 具体例(そのまま使えるイメージ)

以下は「どういう場面で、hook がどう効くか」が分かる具体例です。  
(※コードは例示です。実際の運用では権限・パス・ツール名は環境に合わせてください。)

#### 例1:破壊的なコマンドやツールを PreToolUse でブロック(セキュリティ)

**狙い**:エージェントが危険な操作を実行する前に、hook 側で確実に止める。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

- PreToolUse は「ツール実行前」に呼ばれ、`permissionDecision: deny/ask/allow` などで制御できます。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- 複数 hook がある場合は「より厳しい決定が優先」されます(deny が最優先)。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

設定例(.github/hooks/\*.json に置けます) [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "type": "command",
        "command": "./scripts/guardrail-pretool.sh",
        "timeout": 15
      }
    ]
  }
}
```

スクリプト側の考え方:

- stdin の JSON から `tool_name` / `tool_input` を見て、危険なら `permissionDecision: "deny"` を返す。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- deny すると、そのツール呼び出し自体を止められます。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 例2:インフラ変更系ツールは必ず “ask”(承認必須)にする

**狙い**:安全に倒す(自動実行させない)。  
VS Code の docs にある “Require approval for specific tools(特定ツールは確認必須)” パターンがこれです。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

- 例:`runTerminalCommand` や “infra を変更する操作” を常に `ask` にし、人間が確認してから進める。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 例3:PostToolUse でフォーマット/テストを自動実行(品質担保)

**狙い**:編集後に必ず整形・テストを回す(抜け防止)。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

- PostToolUse は「ツール成功後」に呼ばれ、追加処理やログ、追加コンテキスト注入ができます。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- docs でも「編集後に Prettier を走らせる」例が載っています。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

例えば Python + uv のプロジェクトなら:

- エージェントがファイル編集(editFiles 等)を終えたら
- hook が `uv run test` や `uv run ruff format`(お好みで)を実行
- 失敗したら `additionalContext` で「テスト失敗」を会話に注入して、エージェントに修正を促す  
  ...という流れにできます(PostToolUse の `additionalContext` がその用途です)。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 例4:SessionStart で “毎回確実に” プロジェクト情報を注入(コンテキスト漏れ防止)

**狙い**:「このリポジトリは何で、どんな制約があるか」を毎回注入して、判断ミスを減らす。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

- SessionStart では `hookSpecificOutput.additionalContext` を返して会話へ追加できます。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- 例:`Project: my-app vX.Y | Branch: main | Node: v20...` のような情報を自動で差し込む。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

#### 例5:UserPromptSubmit でプロンプト監査ログを残す(監査/可観測性)

**狙い**:ユーザーが何を依頼したか(指示の原文)を確実に記録する。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks), [\[docs.github.com\]](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks)

- VS Code 側でも「Audit user requests」用途が明記されています。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- GitHub Docs 側にも「prompt をログする」スクリプト例があります。 [\[docs.github.com\]](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks)

#### 例6:Stop hook で「テストが通るまで終われない」を実装(手戻り削減)

**狙い**:「最後にテストして終える」を、ルールとして徹底する。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

- Stop hook は「セッション終了時」に発火し、`decision: "block"` で **終了を止めて**続行させられます。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
- ただし docs でも「無限ループ防止のため stop_hook_active を確認せよ」「premium request を消費する」注意があります。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

### 「hook を使うべき」判断基準(実務的な目安)

次のどれかに当てはまるなら hook の出番です。

1.  **守らないと事故るルール**がある(削除、インフラ変更、秘密情報、監査)→ hook で強制。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
2.  **必ず毎回やる定型作業**がある(format / lint / test / log)→ hook で自動化。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)
3.  **プロンプトや指示だけでは再現性が足りない**(人やモデルでブレる)→ hook で決定的にする。 [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

### 補足:設定ファイルの置き場所(チーム共有と個人用)

VS Code は hook 設定を複数箇所から探します(例:`.github/hooks/*.json` など)。チームで共有したいなら `.github/hooks/` 配下に置くのが分かりやすいです。  
(個人用設定も可能で、ワークスペースの hook がユーザー hook より優先されます。) [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks), [\[docs.github.com\]](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/coding-agent/use-hooks) [\[code.visua...studio.com\]](https://code.visualstudio.com/docs/copilot/customization/hooks)

## GitHub Copilot の Instructions と AGENTS.md

「複数 AI エージェントを使わない」前提では
GitHub Copilot の "Repository-wide custom instructions" (`.github/copilot-instructions.md`)と
`AGENTS.md` は  
ほぼ同じ "Always-on instructions" と考えて差し支えない。

AGENTS.md は階層的に書ける。

`.github/copilot-instructions.md` と AGENTS.md は両方書かないこと。
どっちかに寄せる。

instructions のうち "Path-specific custom instructions" の方は適応するファイルのグロブが書ける

## ケーススタディ1

AIプログラミングエージェントに対して、
ワークスペースで使うPythonの標準を通知したい(例えば
"このプロジェクトではPythonのインデントはタブを使い、1行最長1000文字"
のようなPEPに反する指示)とする。

Claude Code では

1. .claude/CLAUDE.md
2. .claude/rules/\*.md
3. .claude/skills/python/SKILL.md

のうちどこに書くのが適切? これ以外に適切な場所があればそれも考慮して

1.または2.が正解らしい。

同じ標準を GitHub Copilot に指示する場合

1. .github/copilot-instructions.md
2. .github/instructions/python.instructions.md
3. .github/skills/python/SKILL.md

のうちどこに書くのが適切? これ以外に適切な場所があればそれも考慮して

これも 1.または2.が正解らしい。
