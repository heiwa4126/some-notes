# LangChain のメモ

## FAISS の search_kwargs

リファレンスはこのへん?

- [Query vector store](https://python.langchain.com/docs/integrations/vectorstores/faiss/#query-vector-store)
- [similarity_search\()](https://python.langchain.com/api_reference/community/vectorstores/langchain_community.vectorstores.faiss.FAISS.html#langchain_community.vectorstores.faiss.FAISS.similarity_search)
- [クエリとプロジェクション演算子 - MongoDB マニュアル v8.0](https://www.mongodb.com/ja-jp/docs/manual/reference/operator/query/)

## RecursiveCharacterTextSplitter で 句読点

[Splitting text from languages without word boundaries | 🦜️🔗 LangChain](https://python.langchain.com/docs/how_to/recursive_text_splitter/#splitting-text-from-languages-without-word-boundaries)

日本語だったらやったほうがいい(試した)。
ただ文頭に句読点が来る時があるのがちょっとイヤかな...

## 空のベクトルストア

「空の FAISS ベクトルストアを作り、後から add する」のは結構めんどくさいコードが必要。

[Build a semantic search engine | 🦜️🔗 LangChain](https://python.langchain.com/docs/tutorials/retrievers/#vector-stores)
で、FAISS のチュートリアルで気が付いた。

### これはなぜ?

もともと FAISS は「動的追加」に弱いらしい。事前に全データをインデックス化する用途。

詳細は

FAISS は事前定義が必要:
空の状態でインデックスを作成する場合でも、dimension(ベクトルの次元数)や index type(Flat, IVF, HNSW など)を厳密に定義する必要があります。
後からパラメータを変更できません。

インデックスの静的な構造:
FAISS のインデックスは基本的に「静的」で、データを追加するたびに、インデックスの再構築(train)が必要な場合があり、
特に大量の追加では計算コストが高くなります。

永続化の手動管理:
インデックスの保存/読み込み(write_index/read_index)を自前で実装する必要があり、
追加データのマージ処理も煩雑です。

バッチ処理前提の設計:
単一ベクトルの追加は可能ですが、パフォーマンス向上のためにはバッチ処理(add メソッド)が推奨されます。リアルタイム更新には不向きです。

### これができるほかのベクトルストアは?

開発用なら Chroma(プロトタイプ開発や小規模データ向け)

以下は、Pinecone、Weaviate、Milvus、Qdrant、Chroma の特徴、ライセンス、およびサーバー型または埋め込み型の分類をまとめた表です。

| **データベース** | **特徴**                                                   | **ライセンス**              | **タイプ**            |
| ---------------- | ---------------------------------------------------------- | --------------------------- | --------------------- |
| **Pinecone**     | 完全マネージド型、スケーラブル、リアルタイムデータ取り込み | クローズドソース            | クラウドのみ          |
| **Weaviate**     | オープンソース、ハイブリッド検索、AI ネイティブ            | オープンソース              | サーバー型/埋め込み型 |
| **Milvus**       | 高性能、スケーラブル、非構造化データ対応、オープンソース   | オープンソース (Apache 2.0) | サーバー型/埋め込み型 |
| **Qdrant**       | 高性能、マネージドクラウド対応、柔軟なデプロイ             | オープンソース (Apache 2.0) | サーバー型            |
| **Chroma**       | 埋め込みデータベース、ベクトル検索、軽量設計               | オープンソース (Apache 2.0) | 埋め込み型            |

**詳細補足:**

- **Pinecone**: 完全にクラウドネイティブなマネージドサービスであり、高度なスケーラビリティとリアルタイム機能を提供しますが、クローズドソースでセルフホスティングはできません.
- **Weaviate**: ハイブリッド検索(キーワードとベクトル検索の組み合わせ)や生成検索が可能であり、セルフホストまたはマネージドサービスとして利用可能です.
- **Milvus**: 非構造化データ向けに設計された高性能なベクターデータベースであり、小規模アプリケーション向けのスタンドアロンモードやクラウド向けの分散モードを提供します.
- **Qdrant**: 高性能で柔軟なデプロイオプションを持ちつつも主にサーバー型として利用されます。クラウドマネージドサービスも提供されています.
- **Chroma**: 軽量な埋め込み型データベースとして設計されており、アプリケーションコードと緊密に統合可能です.

## .with_structured_output() を使う時、Pydantic のクラスの Field に default を指定するとエラーになる

default(または第 1 引数) を指定しないか、または `...`(Ellipsis)を指定。

### おまけ: Pydantic の default の `...`

Pydantic の Field 関数における...(Ellipsis;エリプシス;「省略」の意味)は、必須フィールドを示すために使用されます。

## chain の最後に置いて、コンテンツをかならず文字列でとるやつ

`StrOutputParser()`

[StrOutputParser — 🦜🔗 LangChain documentation](https://python.langchain.com/api_reference/core/output_parsers/langchain_core.output_parsers.string.StrOutputParser.html)

```python
from langchain.schema import StrOutputParser
from langchain_core.output_parsers import StrOutputParser # こっちの方が新しいらしい
from langchain.chat_models import ChatOpenAI
from langchain.prompts import PromptTemplate
from langchain.chains import LLMChain

llm = ChatOpenAI(model="gpt-4o-mini")
prompt = PromptTemplate.from_template("こんにちは、{name}さん！")

chain = prompt|llm|StrOutputParser()
```

## 「必ず構造化形式で生成する」パターン

Pydantic と
.with_structured_output()を使うのが一番簡単。

場合によっては
StructuredOutputParser や PydanticOutputParser を使う。

プロンプトを工夫してると時間ばかりかかるのでやめたほうがいい。

あと
[Common issues when transitioning to Pydantic 2](https://python.langchain.com/docs/versions/v0_3/#common-issues-when-transitioning-to-pydantic-2)
を参照して `langchain_core.pydantic_v1` は使わないこと。

> Do not use the langchain_core.pydantic_v1 namespace

あと

- [Output parsers | 🦜️🔗 LangChain](https://python.langchain.com/docs/concepts/output_parsers/)
- [output_parsers — 🦜🔗 LangChain documentation](https://python.langchain.com/api_reference/langchain/output_parsers.html)

には「へー」と思うようなパーサが載ってるので参照。

.with_structured_output()の例

```python
from langchain_aws import ChatBedrock
from langchain_core.prompts import ChatPromptTemplate
from pydantic import BaseModel, Field

llm = ChatBedrock(model="apac.amazon.nova-pro-v1:0")
# モデルは好きなのを使ってください。ここでは Amazon Bedrock の Nova Pro を使っています。

class Book(BaseModel):
    title: str = Field(description="本のタイトル")
    author: str = Field(description="著者名")
    genre: str = Field(description="ジャンル")
    summary: str = Field(description="あらすじ")

prompt = ChatPromptTemplate.from_messages(
    [
        ("system", "ユーザーが入力した本の情報を答えて下さい。"),
        ("human", "{book}"),
    ]
)

chain = prompt | llm.with_structured_output(Book)

output = chain.invoke({"book": "ゲゲゲの鬼太郎"})

print("\n=== type(output) ===")
print(type(output))  # <-- <class '__main__.Book'> になっているはず

print("\n=== output ===")
print(output)

print("\n=== output (JSON) ===")
print(
    output.model_dump_json(indent=2)
)  # pydanticのBaseModelのインスタンスメソッドを使う例
```

出力は

```console
=== output (JSON) ===
{
  "title": "ゲゲゲの鬼太郎",
  "author": "水木しげる",
  "genre": "漫画",
  "summary": "ゲゲゲの鬼太郎は、水木しげるによる日本の漫画作品。妖怪が活躍するストーリーで、主人公の鬼太郎が仲間たちと共に妖怪退治をする内容です。"
}
```
