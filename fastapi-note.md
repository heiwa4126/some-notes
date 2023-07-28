# FastAPI メモ

- [FastAPI](https://fastapi.tiangolo.com/)
- [FastAPI](https://fastapi.tiangolo.com/ja/) - 日本語(部分)
- [tiangolo/fastapi: FastAPI framework, high performance, easy to learn, fast to code, ready for production](https://github.com/tiangolo/fastapi)

## 追加のステータスコード (Additional Responses)

- [Additional Responses in OpenAPI - FastAPI](https://fastapi.tiangolo.com/advanced/additional-responses/)
- [Additional Status Codes - FastAPI](https://fastapi.tiangolo.com/advanced/additional-status-codes/)
- [追加のステータスコード - FastAPI](https://fastapi.tiangolo.com/ja/advanced/additional-status-codes/)
- [Extra Models - FastAPI](https://fastapi.tiangolo.com/tutorial/extra-models/)

例えば headless CMS の API で、
ID からブログのポスト 1 件を返す API で
以下のような実装をしたとする。

```python
@app.get("/posts/{post_id}", response_model=Post)
def get_posts_post_id(post_id: int) -> Post:
    if post_id not in post_data:
        raise HTTPException(status_code=404, detail="Blog post not found")
    return post_data[post_id]
```

これだと
FastAPI の出力する OpenAPI(Swagger) に 404 に対するレスポンスが含まれない。

そこで [Additional Responses in OpenAPI - FastAPI](https://fastapi.tiangolo.com/advanced/additional-responses/) を参考にして
get()の引数に `response` を追加してみる。

```python
@app.get("/posts/{post_id}", response_model=Post,
    responses={ 404: {"description": "Blog post not found", {"application/json":{}}}})
def get_posts_post_id(post_id: int) -> Post:
    if post_id not in post_data:
        raise HTTPException(status_code=404, detail="Blog post not found")
    return post_data[post_id]
```

`{ 404: {"description": "Blog post not found", {"application/json":{}}}}` の部分は

- レスポンスステータスコード 404 は
- "Blog post not found"(その ID に対応する投稿はないよ) の意味で
- body は"application/json" の何かが帰るよ。

の意味になる。これだと body にどんな内容が帰るか不定なので ("Example Value"も string になる)、
さらにきっちり OpenAPI の出力を詰めたかったら

```python
class SimpleError(BaseModel):
    datail: str

BPNF = "Blog post not found"

@app.get(
    "/posts/{post_id}",
    response_model=Post,
    responses={404: {"description": BPNF, "model": SimpleError}},
)
def get_posts_post_id(post_id: int) -> Post:
    """
    Get a single blog post by ID
    """
    if post_id not in post_data:
        return JSONResponse({"detail": BPNF}, 404)
    return post_data[post_id]
```

のように書くと、いい感じの OPenAPI が出力されるようになる。

SimpleError と`{"detail": BPNF}`が 全然関連が無いのが問題だと思う場合には
SimpleError クラスに JSON シリアライザーを実装するとよい (ちょっと大げさ?)

他にも [Additional Responses in OpenAPI - FastAPI](https://fastapi.tiangolo.com/advanced/additional-responses/) には、複数のタイプのレスポンスがある場合の 追加のステータスコード (Additional Responses)の書き方が書かれている。
