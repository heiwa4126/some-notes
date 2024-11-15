# Broadcast Channel API のメモ

同じオリジン内で複数のブラウザーウィンドウやタブ、フレーム間でメッセージをやり取りするための API。
ウェブワーカー内でも利用可能。

- [BroadcastChannel - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/BroadcastChannel)
- [ブロードキャストチャンネル API - Web API | MDN](https://developer.mozilla.org/ja/docs/Web/API/Broadcast_Channel_API)

JSON などにシリアライズすることなくオブジェクトを渡せる。

> BroadcastChannel API は、メッセージを送受信する際にオブジェクトを自動的にシリアライズ・デシリアライズするため、ユーザーが明示的にシリアライズを行う必要はありません。
> このシリアライズは内部的に構造化クローニングアルゴリズムを使用して行われるため、JSON.stringify のように文字列に変換するわけではなく、通常の JavaScript のオブジェクト(循環参照のないオブジェクト、配列、Date、Map、Set など)も安全にやり取りできます。

ただし
クラスのメソッド(関数)やプロトタイプチェーンに関連する情報はシリアライズされないため
受信側ではそれらが欠落した状態のオブジェクトになります。
