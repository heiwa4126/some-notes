# AgentCore (AWS Bedrock AgentCore) のメモ

"Amazon Bedrock Agent" とは別

## これは何?

マネージド AI エージェント

任意のエージェントフレームワークのコードをコンテナ化して実行するための環境。

- あなたが書いたエージェント(Python や TS、LangGraph/CrewAI/Strands など)を、
- AWS が用意した「AgentCore Runtime」という**サーバレス実行環境**に載せて、
- スケーリング・セキュリティパッチ・ログ・メモリ・ツール呼び出しなどを**マネージドで面倒見てくれる “ホストされたAIエージェント”**

「Lambda+Step Functions+Bedrock+MCP をいい感じに束ねて、LangGraph 等のエージェントを“サーバレス PaaS”としてホストしてくれる」
みたいな感じ。

- フレームワーク非依存:LangGraph/Strands/CrewAI、あるいはフレームワーク無しの自前コードでも OK。 [docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/develop-agents.html)
- モデル非依存:Bedrock 上の Claude/Nova 等に限らず、OpenAI、Gemini、Llama、Mistral など任意 LLM を利用できる。 [aws.amazon](https://aws.amazon.com/bedrock/agentcore/)
- 実行環境マネージド:セッション単位の分離、長時間・非同期処理、マルチモーダルペイロード、セキュアなツール呼び出しなどを備えた Runtime 上で動く。 [youtube](https://www.youtube.com/watch?v=wizEw5a4gvM)
- 呼び出しは単一 API または CLI:`agentcore invoke`や Runtime API 経由で、プロンプトを渡すとエージェントのループ(ツール実行、メモリ参照含む)が走る。 [docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/)

「タスク分解」「ツール実行」「外部システム連携」「長時間処理」「権限委譲」などを伴う業務プロセス寄りのエージェントを、AgentCore で本番運用する
みたいな使い方。

## AgentCore Runtime

AgentCore Runtime は、以下を提供する**マネージド実行基盤**

- サーバレスでのホスティング(スケーリング/高可用性) [docs.aws.amazon](https://docs.aws.amazon.com/AWSCloudFormation/latest/TemplateReference/aws-resource-bedrockagentcore-runtime.html)
- 言語ランタイムの管理とセキュリティパッチ適用(Lambda 的な責任分界) [docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-code-deploy.html)
- CloudWatch へのログ連携などのオブザーバビリティ機能 [docs.aws.amazon](https://docs.aws.amazon.com/fr_fr/bedrock-agentcore/latest/devguide/agentcore-get-started-toolkit.html)
- メモリ、ツール呼び出し、コードインタプリタなどの AgentCore 統合機能との接続 [docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/)

ドキュメントにも「AgentCore Runtime は Lambda と似た shared responsibility model」と明記されていて、
**AWS側はランタイム・パッチ等を管理し、利用者はエージェントのコードと依存ライブラリに責任を持つ**構造になっている。
[docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-code-deploy.html)

## "Getting Started" は?

- [Get started with the AgentCore CLI - Amazon Bedrock AgentCore](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-cli.html)
- 旧版 - [Runtime Quickstart - Amazon Bedrock AgentCore](https://aws.github.io/bedrock-agentcore-starter-toolkit/user-guide/runtime/quickstart.html)

## AgentCore CLI で生成されるテンプレートに含まれるものは?

CLI やツールキットを使うと、
以下が自動的に用意されます: [docs.aws.amazon](https://docs.aws.amazon.com/fr_fr/bedrock-agentcore/latest/devguide/agentcore-get-started-toolkit.html)

- エージェントの**ひな型コード**(Strands Agents / LangGraph / OpenAI Agents SDK / Google Agent SDK など、どれを使うか選べる) [docs.aws.amazon](https://docs.aws.amazon.com/fr_fr/bedrock-agentcore/latest/devguide/agentcore-get-started-toolkit.html)
- 利用する**LLMプロバイダとモデルの設定**(Bedrock のモデル、OpenAI、Gemini、Claude、Nova、Llama、Mistral などから選択) [docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agents-tools-runtime.html)
- IaC(Terraform または CDK)か、Python プロジェクトフォルダのどちらか [docs.aws.amazon](https://docs.aws.amazon.com/fr_fr/bedrock-agentcore/latest/devguide/agentcore-get-started-toolkit.html)
- Gateway、Memory、Observability が自動セットアップ [docs.aws.amazon](https://docs.aws.amazon.com/fr_fr/bedrock-agentcore/latest/devguide/agentcore-get-started-toolkit.html)
- Runtime 用の IAM ロール、エントリポイント、requirements、認証モデルの設定 [docs.aws.amazon](https://docs.aws.amazon.com/fr_fr/bedrock-agentcore/latest/devguide/agentcore-get-started-toolkit.html)

この「ひな型+インフラ設定+ランタイム環境」が組み合わさって、
**マネージドAIエージェントとして即デプロイ可能な状態**になる。 [docs.aws.amazon](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/agents-tools-runtime.html)

## サンプル

- [Amazon Bedrock AgentCoreとは?全体像の理解から最初のエージェントデプロイまで](https://zenn.dev/taketaka1986/articles/2026-02-21-amazon-bedrock-agentcore-introduction)
- Web 操作エージェント (これだけ単体プロジェクトで、専用サービス + Quickstart あり。)
  - [Interact with web applications using Amazon Bedrock AgentCore Browser - Amazon Bedrock AgentCore](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-tool.html)
  - [Get started with AgentCore Browser - Amazon Bedrock AgentCore](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/browser-quickstart.html)
- データ分析・コード実行エージェント(以下 Runtime に内包される機能)
  - [Code Interpreter(概要:AgentCoreでコード実行)](https://aws.amazon.com/jp/bedrock/agentcore/) [\[docs.aws.amazon.com\]](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-getting-started.html)
  - ※専用の「Code Interpreter 単独 Quickstart」は公開ドキュメントとして独立ページ見つからず(Browser のような専用ページなし)
  - 代替:AgentCore CLI / Runtime Quickstart で組み込む形
    - [Get started with the AgentCore CLI](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-cli.html) [\[zenn.dev\]](https://zenn.dev/taketaka1986/articles/2026-02-21-amazon-bedrock-agentcore-introduction)
- 長時間タスク処理エージェント
  - [Amazon Bedrock AgentCore(長時間ワークロード説明)](https://aws.amazon.com/jp/bedrock/agentcore/) [\[docs.aws.amazon.com\]](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-getting-started.html)
  - ※専用 Quickstart なし(Runtime 機能の挙動)
  - 代替:Runtime Quickstart で確認
    - [Runtime Quickstart(starter toolkit)](https://aws.github.io/bedrock-agentcore-starter-toolkit/user-guide/runtime/quickstart.html) [\[qiita.com\]](https://qiita.com/yakumo_09/items/eaa3b6062396227615a2)
- パーソナライズ学習エージェント(Memory)
  - [Amazon Bedrock AgentCore(Memory説明)](https://aws.amazon.com/jp/bedrock/agentcore/) [\[docs.aws.amazon.com\]](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-getting-started.html)
  - ※Memory 単体 Quickstart なし(CLI/Runtime に内包)
  - 代替:CLI で統合管理
    - [Get started with the AgentCore CLI](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-cli.html) [\[zenn.dev\]](https://zenn.dev/taketaka1986/articles/2026-02-21-amazon-bedrock-agentcore-introduction)
- マルチツールオーケストレーションエージェント
  - [Amazon Bedrock エージェントの仕組み](https://docs.aws.amazon.com/ja_jp/bedrock/latest/userguide/agents-how.html) [\[aws.github.io\]](https://aws.github.io/bedrock-agentcore-starter-toolkit/user-guide/builtin-tools/quickstart-browser.html)
  - ※AgentCore 単体の専用ページではなく「Agent 挙動の定義」側
  - 実装入口
    - [Get started with the AgentCore CLI](https://docs.aws.amazon.com/bedrock-agentcore/latest/devguide/runtime-get-started-cli.html) [\[zenn.dev\]](https://zenn.dev/taketaka1986/articles/2026-02-21-amazon-bedrock-agentcore-introduction)
