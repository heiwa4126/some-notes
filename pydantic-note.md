# Pydantic メモ

驚異のライブラリなんだけど、ローカルルールが多い

## 「デフォルト値はないけど必須」を表すのに Ellipsis オブジェクトを使う

こんなやつ。

```python
class Book(BaseModel):
    """Represents a book with its title, author, genre, and summary."""
    title: str = Field(..., description="本のタイトル")
    author: str = Field(..., description="著者名")
    genre: str = Field(..., description="ジャンル")
    summary: str = Field(..., description="あらすじ")
```

- [Field クラス](https://docs.python.org/ja/3/library/dataclasses.html#dataclasses.Field)
- [Ellipsis](https://docs.python.org/ja/3.13/library/constants.html#Ellipsis)

Ellipsis リテラル が `...`。

公式ドキュメントでは以下に記述が。

- [Fields - Pydantic](https://docs.pydantic.dev/latest/concepts/fields/)

> However, its usage is discouraged as it doesn't play well with static type checkers.

ということで、最近では Annotated を使う方が推奨:

```python
class Book(BaseModel):
    title: Annotated[str, Field(description="本のタイトル")]
    # 省略
```
