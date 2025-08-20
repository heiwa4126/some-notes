# 非同期 Python

asyncio は基本的にシングルスレッド・シングルプロセスのイベントループで動作するため、
「並列処理」と言っても、
実際には並行(concurrent)処理であり、
真の並列(parallel)処理ではない。

あと
これらに対して、タスクが一つずつ順番に実行され、前のタスクが完了するまで次のタスクは開始されないのを
逐次(sequential)と言う。

並行処理は、ミクロに見れば逐次的

Python や Node.js の非同期プログラミングは、どちらかというとレスポンシブの改善向き。

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
Task は実は Future のサブクラスで「コルーチン実行用の Promise」だと思えばいい

Future は「手動制御可能な Promise」のようなもの

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

loop_factory で uvloop を指定するのにつかう (違う w)

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

### uvloop 使うだけなら

```python
import asyncio
import uvloop

# グローバルに設定
asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

# 通常通り使用
asyncio.run(main())
```

または

```python
import uvloop

# uvloop付きで直接実行
uvloop.run(main())
```

で OK

## asyncio.create_task(coro)

[asyncio\.create_task \( coro , \* , name = None , context = None \)](https://docs.python.org/3/library/asyncio-task.html#asyncio.create_task)

1. coro(コルーチンオブジェクト)を Task に変換。
2. その Task を現在のイベントループに登録(スケジューリング)

なので 「非同期関数を実行して coro を得る」時と違って、関数の実行が始まる。

結果や例外は

- await task
- asyncio.gather(task,...)

で取得する。

で、ドキュメントには

> タスクが実行中に消えてしまうのを防ぐため、この関数の結果への参照を保存してください。イベントループはタスクへの弱参照のみを保持します。

と書いてあるので保持したほうがいいかも。ただ asyncio.gather()とか使えば

## asyncio.gather() vs asyncio.TaskGroup()

```py
results = await asyncio.gather(task1(), task2(), task3())
#
async with asyncio.TaskGroup() as tg:
    fut1 = tg.create_task(task1())
    fut2 = tg.create_task(task2())
    fut3 = tg.create_task(task3())
result = (fut1.result, fut2.result, fut3.result)  # result不要ならfutは不要
```

asyncio.gather()は
例外が発生すると、
その例外が即座に伝播され、他のタスクはキャンセルされません。
キャンセルされないけど例外が throw されるので、
たとえば task2()で例外が起きた場合
task3()は実行されても result がとれないかもしれない。
(ただし return_exceptions=True を使えばうまいぐあいに results に例外も結果として返せる)

asyncio.TaskGroup()は
グループ内のタスクのいずれかが例外を出すと、他のタスクもキャンセルされる。
ただし results に相当するものが無い。

asyncio.TaskGroup の方がよいのだけれど、記述量は増える。
何かラッパーやユーティリティが**Python 標準で**あればいいのだけど、Python 3.13 にはない。

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

## asyncio.to_thread()

同期関数を別スレッドで実行できるようにするユーティリティ。
別スレッドなので CPU バウンドな処理や、ブロックする I/O してもいい。
すでに非同期対応している処理や、スレッド非対応な処理を入れるのは NG。(たとえば async def な関数とか)
あとスレッド非対応な C 拡張やライブラリもダメ。

asyncio.to_thread()の戻り値は coro なので、await できるし task にしてもいい。

[並行処理とマルチスレッド処理](https://docs.python.org/ja/3/library/asyncio-dev.html#asyncio-multithreading)

実行はメインスレッドに紐づいた
concurrent.futures.ThreadPoolExecutor によって管理されるスレッドプール
で実行される。

## sqlite3 を非同期で

[sqlite3 --- SQLite データベース用の DB-API 2.0 インターフェース — Python 3.13.5 ドキュメント](https://docs.python.org/ja/3.13/library/sqlite3.html)
を非同期で使うこともできるけど
[aiosqlite·PyPI](https://pypi.org/project/aiosqlite/)
を使う方が簡潔に書ける。

## await

```py
import asyncio

async def  func1():
	// do something

async def main():
    print('hello')
    await func1()
    print('world')

asyncio.run(main())
```

みたいなコードがあるとき、

1. main()の返す coro オブジェクトがイベントループにスケジュールされる
2. そのうちイベントループから main()が実行される
3. main()の`await func1()` まできたら
   1. main()をサスペンドする
   2. func1()返す coro オブジェクトがイベントループにスケジュールされる
   3. そのうちイベントループから func1()が実行され、完了する
   4. サスペンドを解除して続きの行が実行される
4. おしまい

のような流れ。

## asyncio.eager_task_factory()

- [Eager Task Factory](https://docs.python.org/ja/3/library/asyncio-task.html#eager-task-factory)
- [How can I start a Python async coroutine eagerly? - Stack Overflow](https://stackoverflow.com/questions/69145007/how-can-i-start-a-python-async-coroutine-eagerly)

Python 3.12 で導入された新しい機能。
通常、asyncio.create_task() で作成されたタスクは「遅延実行(lazy execution)」され、
次のイベントループのイテレーションで初めて実行が開始されます。

一方、eager_task_factory を使うと、タスク作成時点で即座にコルーチンの実行が始まる。

## 非同期関数の引数にコールバックを与える

できる。ただコールバックが同期か非同期化で呼び出し方が異なる。

`inspect.iscoroutinefunction(callback)` で動的にチェックして分岐するか、
2 種類つくるか

## 非同期関数をラップする非同期デコレータ

できる。

```py
def log_args_decorator(func):
    @functools.wraps(func)
    async def wrapper(*args, **kwargs):
        print(f"Calling {func.__name__} with args={args}, kwargs={kwargs}")
        return await func(*args, **kwargs)
    return wrapper

@log_args_decorator
async def greet(name):
    await asyncio.sleep(0.5)
    print(f"Hello, {name}!")

asyncio.run(greet("Tokyo"))
```

## asyncio をサポートする便利なパッケージ

aiofiles, aiocsv, aiohttp, httpx などが有名だけど、その他

[timofurrer/awesome-asyncio: A curated list of awesome Python asyncio frameworks, libraries, software and resources](https://github.com/timofurrer/awesome-asyncio)

## I/O バウンドの速度の遅さを体感できる比喩

I/O バウンドがどれぐらい遅いかというのを各種生成 AI に聞いてみたのをまとめてみた

### 質問

I/O バウンドの速度の遅さを実感するために、
「CPU キャッシュ上のデータを読む」のを「人間が自分の机にあるメモを読む(3 秒)」に例えようと思います。
その場合、以下の処理はどのように例えらますか?

- メインメモリを読む
- ファイルを読む
- インターネット上からデータを取得する
- 人間の入力を待つ

### AI が参考にしているリンク

のなかからいくつか

- [システムコンポーネント(CPU、メモリ、ディスク、ネットワーク等)のレイテンシとタイムスケールなどなど - CLOVER🍀](https://kazuhira-r.hatenablog.com/entry/2021/05/01/150306)
- [備忘録まとめ記事:「机」に例えるハードウェアの基本 ~ CPU・メモリ・ディスクの簡単整理 ~ #VirtualBox - Qiita](https://qiita.com/free-honda/items/270f246fbb23fdd51b76)
- [各種メモリ/ストレージのアクセス時間,所要クロックサイクル,転送速度,容量の目安 #コンピュータアーキテクチャ - Qiita](https://qiita.com/zacky1972/items/e0faf71aa0469141dede)

### 答えの例

CPU キャッシュのデータアクセスを「机のメモを読む」という 1 秒の動作に例えた場合、他の処理は以下のような時間スケールになります。

#### メインメモリを読む

**同じ部屋の本棚から本を取る**

- **実際の時間**: 16-100 ナノ秒(キャッシュの 10-25 倍)[1][2]
- **人間スケール**: 約 25 秒
- **例え**: 机から立ち上がって本棚まで歩き、目当ての本を取って戻る程度の時間

#### ファイルを読む

**図書館に行って本を借りる**

- **実際の時間**: 90 マイクロ秒〜20 ミリ秒(キャッシュの 10 万-500 万倍)
- **人間スケール**: 約 138 時間(5-6 日間)
- **例え**: 自宅から図書館まで出かけて、本を探し、借りる手続きをして帰宅するまでの時間

#### インターネット上からデータを取得する

**海外の図書館に電話で問い合わせる**

- **実際の時間**: 10-100 ミリ秒(キャッシュの 1000 万-2500 万倍)
- **人間スケール**: 約 6944 時間(約 290 日間)
- **例え**: 海外の図書館に国際電話をかけて、担当者に本の在庫を確認してもらい、回答を待つ時間

#### 人間の入力を待つ

**友人の返事を待つ**

- **実際の時間**: 100-200 ミリ秒(キャッシュの 5000 万-7500 万倍)[9][10][11]
- **人間スケール**: 約 20833 時間(約 2.4 年間)
- **例え**: 友人にメッセージを送って返事を待つ時間、または質問をして相手が考えてから答えるまでの時間

#### まとめると

1. **CPU キャッシュ**: 机のメモ(1 秒)
2. **メインメモリ**: 同じ部屋(25 秒)
3. **ファイル読み書き**: 図書館(5-6 日)
4. **ネットワーク通信**: 海外への問い合わせ(約 1 年)
5. **人間の反応**: 友人の返事(約 2 年)

この比喩により、コンピュータの記憶階層における**速度のギャップの大きさ**が実感できます

#### 別のまとめ

| 処理                   | たとえ                           | 時間感覚       |
| ---------------------- | -------------------------------- | -------------- |
| CPU キャッシュ         | 机の上のメモを読む               | \~3 秒         |
| メインメモリ           | 机の引き出しを開けて読む         | \~30 秒〜1 分  |
| ファイル I/O(ディスク) | 部屋の棚に取りに行く             | \~数分〜10 分  |
| ネットワーク I/O       | 図書館や別の建物に本を借りに行く | \~1 時間〜数日 |
| 人間の入力             | 誰かに書いてもらうのを待つ       | \~数分〜無限   |

## CPU バウンド

「CPU キャッシュ上のデータを読む」のを「人間が自分の机にあるメモ(1KB)を読むのがを 3 秒」とたとえた場合、これの sha256 を計算するには何秒かかるでしょうか? という質問。ばらつきはありますが

「机の上のメモを読むのが 3 秒」なら：

- CPU キャッシュ上のデータ読み：3 秒
- SHA-256(1KB)計算：約 50 分

ぐらいの感覚らしい
(TODO:人間がちゃんと計算すること)
