# AGENTS.md のメモ

[AGENTS.md] はガイドラインであって、`AGENTS.md` という名前のファイルを書け、ではないと思うんだけど:

[AGENTS.md]: [https://agents.md/] "A simple, open format for guiding coding agents,used by over 50k open-source projects."

> リポジトリのルートに AGENTS.md ファイルを作成してください。多くのコーディングエージェントは、お願いすれば AGENTS.md をひな形として作成してくれます。

と書かれているせいもあって、
もはやこんな感じ
[Code search results](https://github.com/search?q=path%3AAGENTS.md&type=code)
で止められない。

## どの AGENTS.md を読んでるかの挙動の確認は?

エージェントのログを見る、ぐらいしか方法がない。

## いちおうデフォルトのパスなど

リポジトリのルートの AGENTS.md も読むとは思うのだがいちおうメモ

### プロジェクト固有

- GitHub Copilot - `.github/copilot-instructions.md`
- Amazon Q - `.amazonq/rules/**/*.md` 全部の md がマージされるらしい
- Claude Code - `.claude/agents/*.md`
  - リポジトリのルートの AGENTS.md は読まないらしい。これ参照: [How to use AGENTS.md in Claude Code](https://aiengineerguide.com/blog/how-to-use-agents-md-in-claude-code/)
- Cursor - `.cursor/rules` または `.cursorrules` 参照: [Practical guide to mastering Claude Code’s main agent and Sub‐agents | by Md Mazaharul Huq | Medium](https://jewelhuq.medium.com/practical-guide-to-mastering-claude-codes-main-agent-and-sub-agents-fd52952dcf00)
- Kiro
  - **Steering Files**: `~/.kiro/steering/` (グローバル) または `.kiro/steering/` (プロジェクトルート)
  - **AGENTS.md**: グローバル steering (`~/.kiro/steering/`) またはプロジェクトルートに配置
  - **Specs**: `.kiro/specs/` (プロジェクトルート)
  - **Hooks**: `.kiro/hooks/` (プロジェクトルート)
- Windsurf (Codeium)
  - `.windsurf/workflows/`　または `.windsurfrules`
- Gemini CLI - `GEMINI.md`
  - `.gemini/settings.json` で `{"contextFileName": "AGENTS.md"}` で AGENTS.md が使える
- RooCode、Cline(Claude Dev)、OpenCode、Zed - 調べ中
