# AI エージェントサーバー

AI エージェントの tools をサーブするのが MCP。
では AI エージェントをサーブするのは?

## AI エージェントはそもそも何で書く?

LangGraph/LangChain が最有力。

OpenAI Agents SDK は litellm 経由で他の生成 AI も使えるらしい。

ほか CrewAI, AutoGen, Smolagents, AgentLite, TaskWeaver など。もっと調べる

## ざっくり調査

セルフホスト向きとか、フレームワークが特定とか
いろいろ混じってるけどあとで分類。
WebUI だけのやつはなるべく省略

- LangGraph Server で書いて、セルフホストまたは LangGraph Platform(旧 LangGraph Cloud)でサーブ。料金プラン色々
- Eidolon
- CrewAI
- AutoGen. 単体で API サーバとして動くらしい。詳細不明
- OpenServ
- OWL (CAMEL-AI/OWL)
- Stack AI
- Strands Agents
- Open Agent Platform(langchain-ai/open-agent-platform). litellm 経由で OpenAI 以外のモデルも使えるらしい。
- Amazon Bedrock AgentCore
- Azure AI Agent Service. やはり AutoGen と相性がいいらしい
- n8n
- Botpress
- Flowise
- Langflow
- Agentforce(Salesforce)
- Microsoft Copilot Studio

## LangGraph Server

LangGraph でエージェントを書くのと同じ要領で書いて langgraph-cli で起動するとさまざまな Rest 風 API が立ち上がる。
LangGraph Platform(旧 LangGraph Cloud)で動かすこともできる。
この API に接続する UI 用に LangGraph SDK がある(Python 版と TypeScript 版)ので、
CLI 版クライアントはもとより、手の込んだ WebUI は React とか Next.js で作る感じ。Streamlit も使える。
動作チェック用にプリビルドされた UI([Agent Chat](https://agentchat.vercel.app/))がある。

Streamlit のサンプル:
[LangGraph Cloud をサクッと触ってみた！ #LLM - Qiita](https://qiita.com/yu-Matsu/items/d69a55062f92d7300476#%E3%81%9B%E3%81%A3%E3%81%8B%E3%81%8F%E3%81%AA%E3%81%AE%E3%81%A7%E7%B0%A1%E5%8D%98%E3%81%AA%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E4%BD%9C%E3%81%A3%E3%81%A6%E3%81%BF%E3%82%8B)
