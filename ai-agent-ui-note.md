# AI エージェントに UI

2 つ方向性があって

1. Dify, LangFlow, Flowise みたいなワークフローもノーコードで書けて UI もついてるやつ
2. Chainlit, Gradio(弱), Streamlit(さらに弱) みたいな自分で LangGraph/LangChain で書いたエージェントに UI をつけるやつ

タイプ 2 の製品では Chainlit がいまのところ(2025-07)抜きんでてる感じらしい。

あと Chainlit では state がサーバ側に保持されるみたい(セッション ID で永続化できる)。
例えば Gradio だと messages をブラウザ側で保存する。
