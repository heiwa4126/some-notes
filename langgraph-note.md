# LangGraph のメモ

## pre-built と scratch の ReAct エージェント

- [How to use the pre-built ReAct agent](https://langchain-ai.github.io/langgraph/how-tos/create-react-agent/)
- [How to create a ReAct agent from scratch](https://langchain-ai.github.io/langgraph/how-tos/react-agent-from-scratch/)

どうみても pre-built の方が簡単なんだけど、

> ここから始めてすぐにエージェントを作るのも良いのですが、
> LangGraph をフルに活用できるように、独自のエージェントの作り方を学ぶことを強くお勧めします。

とか書いてあるので scratch の方も学ばないといけない感じ。

## LangGraph 0.3 から create_react_agent は

別モジュールになって
`pip install langgraph-prebuilt`
が要るらしい。

[langgraph-prebuilt · PyPI](https://pypi.org/project/langgraph-prebuilt/)

```python
from langgraph.prebuilt import create_react_agent
```

## ReAct パターン の基礎

- 「考える」「行動する」「観察する」の 3 つのステップを繰り返す
  - 最初に問題を理解し、解決方法を考える (Thought)
  - 次に、考えた解決方法を実行する (Action)
  - 行動の結果を観察し、新たな情報を得る (Observation)
  - 得た情報を基に、再び考えて次の行動を決める
- この繰り返しで、複雑な問題も解決できる

[[2210.03629] ReAct: Synergizing Reasoning and Acting in Language Models](https://arxiv.org/abs/2210.03629)

下の図は
[How to migrate from legacy LangChain agents to LangGraph | 🦜️🔗 LangChain](https://python.langchain.com/docs/how_to/migrate_agent/)
の LangGraph pre-built 版の ReAct エージェント。

![RaAct agent](imgs/ReAct.png)

この図で ReAct の 3 要素がどこにあたるかというと

- Thought: agent ノードが、LLM が思考し、次のアクションを決定する(点線のとこ)部分に該当します。
- Action: tools ノードが、LLM が選択したツールを実行する部分に該当します。
- Observation: tools ノードから agent ノードに戻る矢印が、ツール実行の結果(Observation)を LLM にフィードバックする流れを示しています。

# Annotated の第 2 引数

LangGraph の state でこういう感じのパターンがよくある。
んだけどなんか意味が分からない。

```python
from typing import Annotated
from typing_extensions import TypedDict
from langgraph.graph.message import add_messages

class AgentState(TypedDict):
    messages: Annotated[list, add_messages]
```

まず重要なのは
**Annotated の第 2 引数以降は
(プログラム中で統一されていれば)
ユーザがどう使ってもかまわない**
ということ。

公式: [Annotated\[\<type\>, \<metadata\>\]](https://docs.python.org/ja/3.13/library/typing.html#typing.Annotated)

例えば

Pydantic でバリデートするなら
Annotated の第 2 引数以降に制約やバリデーション関数を指定する。

FastAPI では
Annotated の第 2 引数は API ドキュメントのためのメタデータ。

あと mypy は Annotated の第 1 引数以降はチェックしない。

微妙にまちがってる例として:
[Python の「Annotated」を初心者に向けてわかりやすく解説する | DevelopersIO](https://dev.classmethod.jp/articles/python-annotated-for-beginner/)

で、
LangGraph では Annotated の第 2 引数は **state 更新のための reducer 関数を指定する**ことになっている。

LangGraph 公式: [Process state updates with reducers](https://langchain-ai.github.io/langgraph/how-tos/graph-api/?h=reducer#process-state-updates-with-reducers)

LangGraph の state で
Annotated の第 2 引数(reducer 関数)を指定しない場合、そのフィールドの更新は「上書き(override)」がデフォルトで使われる。

で、なんでこんな変なことをしてるか、普通に reducer 関数を指定する引数作ればいいんじゃないの?
と思うでしょう?

それはこんなのが書けるようにするため。

```python
class State(TypedDict):
    messages: Annotated[list, add_messages]  # メッセージ追加
    total: Annotated[int, operator.add]      # 数値加算
    data: Annotated[dict, lambda old, new: {**old, **new}]  # 辞書マージ
    counter: int  # 通常の置き換え
```

すごいですねえ! フィールドごとに更新の方法を変えられるわけだ。

Annotated の第 2 引数を私用(誤字ではない)しているライブラリの例は
お近くの ChatGPT 等で

> Python の Annotated で第 2 引数以降には何を書いてもよく、それをどう使うかはユーザやライブラリに任されているようです。有名なのは Pydantic, FastAPI, LangGraph の state などですが、この他の例を挙げてください。

と聞いてみてください。いろいろ出てきますよ。

あたりまえですがこのようなアノテーションの使い方は
ライブラリやプログラムごとのローカルルールです。
なので乱用するとプログラムの可読性を損ないます(この LangGraph の話がいい例)。

独自の使い方をする場合はちゃんとドキュメントに書いておきましょう。
