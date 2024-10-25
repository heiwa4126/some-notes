# BroadcastChannel API のメモ

SPA だとブラウザの複数のタブやウインドウ間で通信するの、
出来ないかと思ってたら意外と簡単に出来るらしい。

- [BroadcastChannel API 概要](#broadcastchannel-api-概要)
- [他の手法](#他の手法)
  - [LocalStorage を使った同期](#localstorage-を使った同期)
  - [BroadcastChannel API (これ)](#broadcastchannel-api-これ)
  - [Service Worker を使った同期](#service-worker-を使った同期)
  - [WebSocket を使ったリアルタイム同期](#websocket-を使ったリアルタイム同期)
- [React 用のいい感じの hook](#react-用のいい感じの-hook)
  - [use-broadcast-channel](#use-broadcast-channel)
  - [react-broadcast-channels](#react-broadcast-channels)
  - [カスタムフックの作成](#カスタムフックの作成)
  - [broadcast-channel](#broadcast-channel)
  - [実験的な機能: @tanstack/query-broadcast-client-experimental](#実験的な機能-tanstackquery-broadcast-client-experimental)
- [その他のライブラリ](#その他のライブラリ)
  - [1. redux-state-sync](#1-redux-state-sync)
  - [2. Yjs と y-broadcastchannel](#2-yjs-と-y-broadcastchannel)
  - [3. RxDB](#3-rxdb)
  - [4. IndexedDB と BroadcastChannel の組み合わせ](#4-indexeddb-と-broadcastchannel-の組み合わせ)
  - [5. PouchDB と自動同期](#5-pouchdb-と自動同期)
  - [6. カスタム実装による統合](#6-カスタム実装による統合)
    - [例: Zustand でのカスタムミドルウェア](#例-zustand-でのカスタムミドルウェア)
    - [例: Jotai でのカスタム Atom](#例-jotai-でのカスタム-atom)
  - [7. broadcast-channel ライブラリの活用](#7-broadcast-channel-ライブラリの活用)
  - [**まとめ**](#まとめ)

## BroadcastChannel API 概要

> **ブロードキャストチャンネル API** (Broadcast Channel API) を使用すると、同じオリジンの閲覧コンテキスト (つまり、ウィンドウ、タブ、フレーム、iframe) やワーカー間で、基本的な通信を行うことができます。

- [ブロードキャストチャンネル API - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/Broadcast_Channel_API)
- [BroadcastChannel - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/BroadcastChannel)
- [ブラウザーの互換性](https://developer.mozilla.org/ja/docs/Web/API/Broadcast_Channel_API#%E3%83%96%E3%83%A9%E3%82%A6%E3%82%B6%E3%83%BC%E3%81%AE%E4%BA%92%E6%8F%9B%E6%80%A7) - 目立つのは Deno がダメなことぐらい。モダンブラウザは大丈夫

BroadcastChannel API はオブジェクトもそのまま渡すことが可能です。BroadcastChannel を使うと、JavaScript のオブジェクトを含むあらゆる JSON 対応のデータ型をシリアライズ(JSON.stringify)せずに、**そのまま**渡すことができます。
つまり、文字列や数値、配列、オブジェクトなどを直接送信できます。

## 他の手法

React で複数のブラウザウィンドウまたはタブ間でデータを同期させることは、
ブラウザの持ついくつかの技術を組み合わせることで可能です。

どれを選択するかは、具体的なユースケースや実装の難易度によります。
たとえば、`localStorage`はシンプルで設定が容易ですが、複雑なデータや即時性が必要な場合には
`BroadcastChannel` や `WebSocket`の方が適しています。

### LocalStorage を使った同期

`localStorage` は、同じドメイン内の全てのタブやウィンドウで共有されるので、これを利用して簡単に状態を同期できます。`localStorage` の変更イベント(`storage`イベント)を使用することで、他のタブが`localStorage`のデータを監視し、変更があった場合にデータを取得して表示を更新することができます。

```js
// タブA(データの更新側)
localStorage.setItem('sharedData', JSON.stringify(newData));

// タブB(データの受信側)
window.addEventListener('storage', (event) => {
  if (event.key === 'sharedData') {
    const updatedData = JSON.parse(event.newValue);
    // 更新データでUIを更新する処理
  }
});
```

### BroadcastChannel API (これ)

`BroadcastChannel` は、同一オリジン内の複数のタブやウィンドウ間でメッセージを送受信できる API です。複雑なデータの同期にはこちらが便利です。

```js
// タブA(送信側)
const channel = new BroadcastChannel('sync-channel');
channel.postMessage({ data: newData });

// タブB(受信側)
const channel = new BroadcastChannel('sync-channel');
channel.onmessage = (event) => {
  const updatedData = event.data.data;
  // 更新データでUIを更新する処理
};
```

### Service Worker を使った同期

Service Worker を使って、ブラウザ間でデータを同期することも可能です。
ただし、この方法は少し高度で、バックグラウンドで同期処理を管理したい場合や、プッシュ通知のような機能を追加したい場合に有用です。

### WebSocket を使ったリアルタイム同期

WebSocket を使うことで、サーバーを介してリアルタイムで全タブやウィンドウにデータを同期することもできます。
こちらはサーバー側のセットアップが必要ですが、リアルタイム性が必要な場合には適しています。

## React 用のいい感じの hook

- [use-broadcast-channel - npm](https://www.npmjs.com/package/use-broadcast-channel)
- [react-broadcast-channels - npm](https://www.npmjs.com/package/react-broadcast-channels)
- `react-broadcast-channel`は存在しない。
- [broadcast-channel - npm](https://www.npmjs.com/package/broadcast-channel) - hook じゃない
- [react-use - npm](https://www.npmjs.com/package/react-use) - これに useBroadcastChannel() がある、という噂だったが、実際には無かった。でもこれはこれで面白いパッケージなのでメモ。
- 自分でカスタムフックを書く

### use-broadcast-channel

インストール:

```bash
npm install use-broadcast-channel
```

使い方:

```jsx
import useBroadcastChannel from 'use-broadcast-channel';
import { useState } from 'react';

function MyComponent() {
  const [message, setMessage] = useState('');
  const [receivedMessage, postMessage] = useBroadcastChannel('my-channel');

  const sendMessage = () => {
    postMessage(message);
  };

  return (
    <div>
      <input value={message} onChange={(e) => setMessage(e.target.value)} />
      <button onClick={sendMessage}>Send</button>
      {receivedMessage && <p>Received: {receivedMessage}</p>}
    </div>
  );
}
```

### react-broadcast-channels

インストール方法:

```bash
npm install react-broadcast-channels
```

使い方:

```jsx
import { useBroadcastChannel } from 'react-broadcast-channels';
import { useState } from 'react';

function MyComponent() {
  const [message, setMessage] = useState('');
  const { message: receivedMessage, postMessage } = useBroadcastChannel('my-channel');

  const sendMessage = () => {
    postMessage(message);
  };

  return (
    <div>
      <input value={message} onChange={(e) => setMessage(e.target.value)} />
      <button onClick={sendMessage}>Send</button>
      {receivedMessage && <p>Received: {receivedMessage}</p>}
    </div>
  );
}
```

### カスタムフックの作成

既存のライブラリが要件に合わない場合や、
より柔軟な実装が必要な場合は、
自分でカスタムフックを作成することもおすすめです。

```jsx
import { useState, useEffect, useRef } from 'react';

function useBroadcastChannel(channelName) {
  const [message, setMessage] = useState(null);
  const bcRef = useRef(null);

  useEffect(() => {
    const bc = new BroadcastChannel(channelName);
    bcRef.current = bc;
    bc.onmessage = (e) => {
      setMessage(e.data);
    };
    return () => {
      bc.close();
    };
  }, [channelName]);

  const postMessage = (msg) => {
    bcRef.current.postMessage(msg);
  };

  return [message, postMessage];
}
```

使い方:

```jsx
function MyComponent() {
  const [message, setMessage] = useState('');
  const [receivedMessage, postMessage] = useBroadcastChannel('my-channel');

  const sendMessage = () => {
    postMessage(message);
  };

  return (
    <div>
      <input value={message} onChange={(e) => setMessage(e.target.value)} />
      <button onClick={sendMessage}>Send</button>
      {receivedMessage && <p>Received: {receivedMessage}</p>}
    </div>
  );
}
```

### broadcast-channel

これは Node.js やブラウザ環境でのタブ間通信を抽象化したライブラリで、
React 専用ではありません。

インストール方法:

```bash
npm install broadcast-channel
```

使い方(React で使用する場合):

```jsx
import { BroadcastChannel } from 'broadcast-channel';
import { useState, useEffect } from 'react';

function MyComponent() {
  const [message, setMessage] = useState('');
  const [receivedMessage, setReceivedMessage] = useState(null);

  useEffect(() => {
    const channel = new BroadcastChannel('my-channel');
    channel.onmessage = (msg) => {
      setReceivedMessage(msg);
    };
    return () => {
      channel.close();
    };
  }, []);

  const sendMessage = () => {
    const channel = new BroadcastChannel('my-channel');
    channel.postMessage(message);
    channel.close();
  };

  return (
    <div>
      <input value={message} onChange={(e) => setMessage(e.target.value)} />
      <button onClick={sendMessage}>Send</button>
      {receivedMessage && <p>Received: {receivedMessage}</p>}
    </div>
  );
}
```

### 実験的な機能: @tanstack/query-broadcast-client-experimental

TanStack Query(旧称 React Query) には、
`broadcastQueryClient` という機能があります。
これは BroadcastChannel API を利用して、
複数のブラウザタブ間でクエリキャッシュを同期するためのものです。

参考: [broadcastQueryClient (Experimental) | TanStack Query React Docs](https://tanstack.com/query/latest/docs/framework/react/plugins/)

`@tanstack/query-broadcast-client-experimental` は**実験的なパッケージであり、将来的に API が変更される可能性があります。**
プロダクション環境で使用する際は注意が必要です。

インストール方法:

```bash
npm install @tanstack/query-broadcast-client-experimental
```

QueryClient の設定:

アプリケーションのエントリポイントで、`broadcastQueryClient` を設定します。

```jsx
import { QueryClient } from '@tanstack/react-query';
import { broadcastQueryClient } from '@tanstack/query-broadcast-client-experimental';

// QueryClient のインスタンスを作成
const queryClient = new QueryClient();

// QueryClient を BroadcastChannel を使って同期
broadcastQueryClient({
  queryClient,
  broadcastChannel: 'tanstack-query' // 任意のチャンネル名
});
```

QueryClientProvider での利用:

```jsx
import { QueryClientProvider } from '@tanstack/react-query';

function App() {
  return <QueryClientProvider client={queryClient}>{/* アプリケーションのコンポーネント */}</QueryClientProvider>;
}

export default App;
```

**バージョン要件**: この機能は **TanStack Query v4** 以降で利用可能です。使用しているバージョンを確認してください。

## その他のライブラリ

**以下未整理で未検証**

TanStack 以外にも BroadcastChannel API を利用して、
複数のブラウザタブ間で状態やデータを同期するライブラリがあります。
以下にいくつかご紹介します。

### 1. redux-state-sync

- **概要**: `redux-state-sync` は Redux 用のミドルウェアで、BroadcastChannel API を使用して複数のタブ間で Redux ストアの状態を同期します。ユーザーが異なるタブでアクションをディスパッチすると、他のタブにもそのアクションが反映されます。

- **インストール方法**:

  ```bash
  npm install redux-state-sync
  ```

- **使い方**:

  ```jsx
  import { createStore, applyMiddleware } from 'redux';
  import { createStateSyncMiddleware, initMessageListener } from 'redux-state-sync';
  import rootReducer from './reducers';

  // ミドルウェアを作成
  const middlewares = [createStateSyncMiddleware()];

  // ストアを作成
  const store = createStore(rootReducer, applyMiddleware(...middlewares));

  // メッセージリスナーを初期化
  initMessageListener(store);
  ```

  **補足**: デフォルトではすべてのアクションが同期されますが、特定のアクションだけ
  を同期したり、同期から除外したりすることも可能です。

### 2. Yjs と y-broadcastchannel

- **概要**: **Yjs** はリアルタイムのコラボレーションを可能にするフレームワークです。`y-broadcastchannel` プロバイダーを使用することで、BroadcastChannel API を通じてデータを複数のタブ間で同期できます。

- **インストール方法**:

  ```bash
  npm install yjs y-broadcastchannel
  ```

- **使い方**:

  ```jsx
  import * as Y from 'yjs';
  import { BroadcastChannelProvider } from 'y-broadcastchannel';

  // Yjs ドキュメントを作成
  const ydoc = new Y.Doc();

  // BroadcastChannel プロバイダーを作成
  const provider = new BroadcastChannelProvider(ydoc, 'my-room-name');

  // シェアされるデータ型を定義
  const yArray = ydoc.getArray('shared-array');

  // データの変更を監視
  yArray.observe((event) => {
    console.log('Data changed:', yArray.toArray());
  });

  // データを更新
  yArray.push(['new item']);
  ```

  **補足**: Yjs は高度なデータ同期を提供し、複雑なデータ構造のリアルタイム共有に適しています。

### 3. RxDB

- **概要**: **RxDB** はリアルタイムの NoSQL データベースで、データをブラウザ内やサーバー間で同期できます。RxDB は内部で BroadcastChannel を使用して、同じブラウザ内の複数のタブ間でデータを同期します。

- **インストール方法**:

  ```bash
  npm install rxdb
  ```

- **使い方**:

  ```jsx
  import { createRxDatabase, addRxPlugin } from 'rxdb';
  import { RxDBBroadcastChannelPlugin } from 'rxdb/plugins/broadcast-channel';
  import { RxDBReplicationPlugin } from 'rxdb/plugins/replication';

  // プラグインを追加
  addRxPlugin(RxDBBroadcastChannelPlugin);
  addRxPlugin(RxDBReplicationPlugin);

  // データベースを作成
  const db = await createRxDatabase({
    name: 'mydb',
    adapter: 'idb' // IndexedDB を使用
  });

  // コレクションを作成
  await db.collection({
    name: 'items',
    schema: {
      title: 'item schema',
      version: 0,
      type: 'object',
      properties: {
        name: { type: 'string' }
      }
    }
  });

  // BroadcastChannel を通じて同期が自動的に行われます
  ```

  **補足**: RxDB はデータのリアクティブな変更監視や、PouchDB との互換性も備えています。

---

### 4. IndexedDB と BroadcastChannel の組み合わせ

- **概要**: **IndexedDB** を直接使用している場合、BroadcastChannel を活用して複数のタブ間でデータの変更を通知できます。

- **使い方**:

  ```jsx
  const bc = new BroadcastChannel('indexeddb-updates');

  // データの変更を他のタブに通知
  function updateData(data) {
    // IndexedDB にデータを書き込む処理
    // ...

    // 他のタブに通知
    bc.postMessage({ type: 'data-updated', data });
  }

  // 他のタブからのデータ変更を受信
  bc.onmessage = (event) => {
    if (event.data.type === 'data-updated') {
      // IndexedDB から最新のデータを取得
      // ...
    }
  };
  ```

  **補足**: IndexedDB はトランザクションをサポートしているため、データの整合性を保ちながら同期を行えます。

### 5. PouchDB と自動同期

- **概要**: **PouchDB** はクライアントサイドのデータベースで、CouchDB と同期できます。BroadcastChannel を直接使用していませんが、内部で同様のメカニズムを使用して複数のタブ間でデータを同期します。

- **インストール方法**:

  ```bash
  npm install pouchdb
  ```

- **使い方**:

  ```jsx
  import PouchDB from 'pouchdb';

  const db = new PouchDB('mydb');

  // データの変更を監視
  db.changes({
    since: 'now',
    live: true
  }).on('change', (change) => {
    // データが変更されたときの処理
    console.log('Data changed:', change);
  });

  // データを追加
  db.put({ _id: 'item1', name: 'Item 1' });
  ```

  **補足**: PouchDB はドキュメント指向のデータベースで、オフラインファーストのアプリケーション開発に適しています。

### 6. カスタム実装による統合

既存のライブラリが要件を満たさない場合、BroadcastChannel API を使用してカスタムの同期機能を実装することも可能です。

#### 例: Zustand でのカスタムミドルウェア

```jsx
import create from 'zustand';
import { BroadcastChannel } from 'broadcast-channel';

const useStore = create((set) => ({
  /* あなたの状態とアクション */
}));

const bc = new BroadcastChannel('my-zustand-channel');

// ストアの変更を他のタブに送信
useStore.subscribe((state) => {
  bc.postMessage(state);
});

// 他のタブからの変更を受信
bc.onmessage = (state) => {
  useStore.setState(state);
};
```

#### 例: Jotai でのカスタム Atom

```jsx
import { atom } from 'jotai';
import { BroadcastChannel } from 'broadcast-channel';

const bc = new BroadcastChannel('my-jotai-channel');

const countAtom = atom(0);

const syncedCountAtom = atom(
  (get) => get(countAtom),
  (get, set, update) => {
    set(countAtom, update);
    bc.postMessage(update);
  }
);

// 他のタブからの変更を受信
bc.onmessage = (value) => {
  set(countAtom, value);
};
```

---

### 7. broadcast-channel ライブラリの活用

- **概要**: `broadcast-channel` ライブラリは、BroadcastChannel API の機能をラップし、古いブラウザでも動作するようにフォールバックを提供します。

- **インストール方法**:

  ```bash
  npm install broadcast-channel
  ```

- **使い方**:

  ```jsx
  import { BroadcastChannel } from 'broadcast-channel';

  const bc = new BroadcastChannel('my-channel');

  // メッセージを送信
  bc.postMessage({ type: 'UPDATE', payload: 'data' });

  // メッセージを受信
  bc.onmessage = (msg) => {
    console.log('Received message:', msg);
  };
  ```

  **補足**: このライブラリはブラウザ間の互換性を高め、Node.js でも使用できます。

---

### **まとめ**

- **redux-state-sync** や **Yjs**、**RxDB** など、BroadcastChannel API を活用して状態やデータを複数のタブ間で同期するライブラリがあります。
- 状態管理ライブラリ（Zustand や Jotai など）と組み合わせてカスタム実装を行うことで、特定の要件に合わせた同期機能を実現できます。
- **broadcast-channel** ライブラリを使用すると、BroadcastChannel API の互換性問題を解決しながら、メッセージ通信を簡単に実装できます。

---

**ご注意**:

- **ブラウザのサポート**: BroadcastChannel API はモダンなブラウザでサポートされていますが、古いブラウザでは動作しない可能性があります。必要に応じてフォールバックやポリフィルの導入を検討してください。
- **パフォーマンス**: 複数のタブ間で大量のデータを頻繁に同期すると、パフォーマンスに影響を与える可能性があります。同期するデータの粒度や頻度を適切に設定してください。
- **データの整合性**: 同期中に競合が発生する場合があります。必要に応じて、競合解決のロジックを実装してください。

---

何かご不明な点や、さらに詳しい情報が必要な場合は、お気軽にお知らせください。
