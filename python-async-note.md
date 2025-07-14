# 非同期 Python

## 参考リンク

まずはこれ。
[asyncio での開発 — Python 3 ドキュメント](https://docs.python.org/ja/3/library/asyncio-dev.html)
最新の状況に対応。ただチュートリアルとしては辛い

他公式から:

- [asyncio --- 非同期 I/O — Python 3 ドキュメント](https://docs.python.org/ja/3/library/asyncio.html)
- [高水準の API インデックス — Python 3 ドキュメント](https://docs.python.org/ja/3/library/asyncio-api-index.html)の「使用例」
- [コルーチンと Task — Python 3 ドキュメント](https://docs.python.org/ja/3/library/asyncio-task.html)

その他

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

## asyncio はコルーチン

「コルーチンと promise の違いがよくわからないのは JavaScript のせい」らしい。

```js
// JavaScript Promise
const promise = fetch('/api/data')
  .then((response) => response.json())
  .then((data) => console.log(data))
  .catch((error) => console.error(error));
```

```js
// これはコルーチン風に見えるが、実際にはPromiseベース
async function fetchData() {
  const response = await fetch('/api/data'); // fetchはPromiseを返す
  const data = await response.json(); // jsonもPromiseを返す
  return data; // 実際にはPromiseでラップされて返される
}
```

JavaScript では両方の概念が共存しています。async/await は Promise ベースのコルーチン風の書き方を提供しており、内部的には Promise を使いつつ、コルーチンのような書き心地を実現しています。`await`は単に Promise の`.then()`の糖衣構文に過ぎません。

**真のコルーチン**(Python の asyncio など)では:

- 関数が実際に一時停止・再開される
  - 関数のスタックフレーム全体が保存・復元される
  - ローカル変数の値も保持される
  - 1 つのスレッドで複数のコルーチンが協調的に実行される
- イベントループが直接コルーチンを管理する
  - イベントループは今や「ポーリング」ではない
- なので、より軽量で効率的

**JavaScript の async/await**では:

- Promise オブジェクトが作られ、チェーンされる
- 見た目はコルーチンだが、実装は Promise ベース
- ガベージコレクションの負荷が高い

他の言語の例を見ると違いが明確になります:

- **Go 言語**:`goroutine`という真のコルーチンがあり、Promise はない
- **C#**:`Task`(Promise に近い)と`async/await`が明確に分離
- **Rust**:`Future`トレイト(Promise に近い)と`async/await`

JavaScript の`async/await`は確かに便利ですが、コルーチンと Promise の概念を混同させる原因となっているのは事実です。

```py
# Python コルーチン
async def fetch_data():
    response = await http_request('/api/data')
    data = await response.json()
    return data
```

## コルーチンとタスクとイベントループ

コルーチン(Coroutine)とは
非同期関数(async def)を呼び出したときに返されるオブジェクト。
(つまり非同期関数を呼び出しただけでは実行はされない)。

タスク(Task)とは
コルーチンをイベントループに登録して実行するためのラッパー。

イベントループとは
非同期タスクやコルーチンをスケジューリングして、順番に実行する仕組み。

イベントループの流れ:

1. プログラムが非同期タスクやコルーチンをイベントループに登録する。
2. イベントループが 登録された処理の中から「今すぐ実行できるものがあるか」を確認する。
3. イベントループが実行可能な処理を選び、順番に実行する。
4. 処理が await などで待機状態になると、イベントループはその処理を一時停止する。
5. イベントループが他の実行可能な処理に切り替えて、並行して進める。
6. イベントループがすべての処理が完了するまでこの流れを繰り返す。

コルーチンを直接イベントループに追加することもできるのだが、
不便すぎるのでやめたほうがいい。

1. 状態の監視ができない  
   タスクなら .done() や .exception() で状態を確認できるが、コルーチンにはそうしたメソッドがない。
2. 途中でキャンセルできない  
   タスクは .cancel() でキャンセル可能だが、コルーチンは直接キャンセルできない。
3. 複数の処理を並行して実行できない  
   タスクなら asyncio.gather() や create_task() で並行処理ができるが、コルーチンは逐次実行になる。
4. 例外を後から取得できない  
   タスクは .exception() で例外を確認できるが、コルーチンは例外が発生すると即座にスローされる。
5. イベントループ外でスケジューリングできない  
   タスクはイベントループに登録された後も非同期にスケジュールされるが、コルーチンは await されるまで動かない。
6. デバッグやトレースが難しい  
   タスクは asyncio.all_tasks() などで一覧取得できるが、コルーチンは追跡が困難。
7. 再利用ができない  
   コルーチンオブジェクトは一度しか使えず、再度使うには新しく呼び出す必要がある。

```py
import asyncio

# 既存のイベントループを取得する
loop = asyncio.get_running_loop()

# 新しくイベントループを作る
loop = asyncio.new_event_loop()
asyncio.set_event_loop(loop)
```

## asyncio.gather(\*aws)

<https://docs.python.org/ja/3/library/asyncio-task.html#running-tasks-concurrently> には 「並行な Task 実行(Running Tasks Concurrently)」と書かれているけど、これも 「awaitables をカレントのイベントループで実行」なので「並行」とはいいがたいのではないか。

あと、asyncio.gather()はカレントループに既存で awaitables があってもなくても
asyncio.gather()で指定した awaitables のみ待ち受ける。

## asyncio.run(coro)

[asyncio\.run\(coro, \*, debug=None, loop_factory=None\)](https://docs.python.org/ja/3.13/library/asyncio-runner.html#asyncio.run)

引数はコルーチン(awaitables でなく)が 1 個とフラグいくつか。

引数はコルーチンは内部でタスクに変換される。
「内部で変換」なので外部からキャンセルはできない。

asyncio.run()はイベントループを自動的に作成・管理・クローズする。
便利だけど、逆に言うとイベントループの再利用はできない。

asyncio.run() は、コルーチン内で発生した例外をそのまま呼び出し元に伝播する。

## asyncio.runner()

[class asyncio\.Runner\(\*, debug=None, loop_factory=None\)](https://docs.python.org/ja/3/library/asyncio-runner.html#asyncio.Runner)

loop_factory で uvloop を指定するのにつかう w

```py

import asyncio
import uvloop

def uvloop_factory():
    loop = uvloop.new_event_loop()
    return loop

async def main():
    print("Hello with uvloop")

with asyncio.Runner(loop_factory=uvloop_factory) as runner:
    runner.run(main())
```

## uvloop

「import するだけでイベントループが早くなる」んだそうです。

[uvloop·PyPI](https://pypi.org/project/uvloop/)

ただし Windows では動かない。
FastAPI なんかではデフォルトは uvloop だが Windows では asyncio にフォールバックするらしい。

## async for

[8\.9\.2\. async for 文](https://docs.python.org/ja/3.13/reference/compound_stmts.html#the-async-for-statement)

非同期ジェネレータ関数(asynchronous iterable)と組み合わせて使う。

非同期ジェネレータ関数の戻り値である
非同期ジェネレータオブジェクトは coro でも awaitable でもない。

```py

# 非同期ジェネレータオブジェクトは coro でも awaitable でもない。
# 非同期ジェネレータオブジェクトは coro ではないが awaitable である。
# どっちが正しい?

import inspect


async def async_gen():
    yield 1
    yield 2


# 非同期ジェネレータオブジェクトを作成
gen = async_gen()

# gen自体はawaitableです(誤り)

print(inspect.iscoroutine(gen))  # False (coroではない)
print(hasattr(gen, "__await__"))  # True (awaitableです) <- 誤り


async def main():
    async for value in gen:
        print(value)


if __name__ == "__main__":
    import asyncio

    asyncio.run(main())
```

出力は

```console
False
False
1
2
```

## async with as

[8\.9\.3\. async with 文](https://docs.python.org/ja/3.13/reference/compound_stmts.html#the-async-with-statement)

非同期コンテキストマネージャはデコレータ([@asynccontextmanager](https://docs.python.org/ja/3.13/library/contextlib.html#contextlib.asynccontextmanager))を使うと簡潔に書ける。
