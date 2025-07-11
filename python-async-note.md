# 非同期 Python

## 参考リンク

- [aiofiles と asyncio を使用した Python の非同期ファイル処理 | Twilio](https://www.twilio.com/ja-jp/blog/working-with-files-asynchronously-in-python-using-aiofiles-and-asyncio-jp) - やや古い。基本的な使い方は変わっていないが TaskGroup などでもっと効率よく書ける
- [【Python】aiofiles を用いた非同期ファイル入出力| Python Tech](https://tech.nkhn37.net/python-aiofiles-async-basic/)
- [asyncio:Python での非同期プログラミング | よくわかる python とエクセル VBA 入門](https://python-vba.com/asyncio/)
- [Working with Files Asynchronously in Python using aiofiles and asyncio - DEV Community](https://dev.to/sagnew/working-with-files-asynchronously-in-python-using-aiofiles-and-asyncio-1a4k)
- [How to use asyncio.TaskGroup - Super Fast Python](https://superfastpython.com/asyncio-taskgroup/)

## asyncio.run() を event_loop で書くと

おおむねこんな感じ

型無し

```python
def run(coro):
    # 新しいイベントループを作成
    loop = asyncio.new_event_loop()
    try:
        asyncio.set_event_loop(loop)
        return loop.run_until_complete(coro) # コルーチンを実行
    finally:
        # イベントループを適切にクリーンアップ・終了
        asyncio.set_event_loop(None)
        loop.close()
```

型つき

```python
import asyncio
from typing import TypeVar, Coroutine, Any

T = TypeVar('T')

def run(coro: Coroutine[Any, Any, T]) -> T:
    # 新しいイベントループを作成
    loop = asyncio.new_event_loop()
    try:
        asyncio.set_event_loop(loop)
        return loop.run_until_complete(coro) # コルーチンを実行
    finally:
        # イベントループを適切にクリーンアップ・終了
        asyncio.set_event_loop(None)
        loop.close()
```

## 非同期に HTTP リクエスト

httpx や aiohttp を使う。
request は非同期版がない。(requests-async というのがあったけどメンテされてない)

## ブロッキング検出

「Python で非同期な関数を開発しているとき、それがブロッキングしている個所を検出する方法はありますか?」という話。

いろいろあるけど基本は asyncio のデバッグモード
[asyncio での開発 — Python 3.13.5 ドキュメント](https://docs.python.org/ja/3/library/asyncio-dev.html)
らしい。
