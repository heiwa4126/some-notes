# OpenDKIM のメモ

## 【超重要】OpenDKIM の keyTable は1レコード1行で書かなきゃならない

この1レコードが長い。

OpenDKIM が内部で使うdbライブラリ(Berkeley DBなど)が「1キー = 1レコード」を前提としており、改行をレコードの区切りとして扱う。

なんかスクリプト作ったほうがいいかもしれない。

## DKIM canonicalization

```conf
Canonicalization  relaxed/simple
# ↑これは厳しすぎるので
# ↓これぐらいで
Canonicalization  relaxed/relaxed
```

## DKIM h= にはどれぐらいヘッダを含めるべき?

実用上十分

```conf
SignHeaders *,+Message-Id,+Content-Type,+Content-Transfer-Encoding,+Sender
OversignHeaders From,Message-Id,Subject
```

これで
`h=To:Subject:Date:Message-Id:From:From:Message-Id:Subject`
だった。
(元メールにないのは出ない)

MIME-Version, Content-Type, Content-Transfer-Encoding などは壊れやすい (ゲートウェイやMTAが微調整する場合あり)ので、はずしたほうがいいかもしれない。

## Oversigning テクニック

OversignHeaders でヘッダを複数回入れるのにはどんな意味があるのか?

---

以下 Claude に聞いてみました。

### DKIM署名の検証の仕組みをまず理解する

DKIMの `h=` に書かれたヘッダは、**メールの先頭から数えて最も新しいもの**から順に署名されます。同名ヘッダが複数ある場合も、上から1つずつ消費していきます。

### 攻撃シナリオ:ヘッダインジェクション

たとえば `h=from` (1回だけ)で署名した場合:

```
DKIM-Signature: h=from:subject:...
From: legitimate@example.com        ← 署名済み
Subject: 正規のメール
```

悪意ある中継者が**新しい From ヘッダを先頭に追加**すると:

```
DKIM-Signature: h=from:subject:...
From: attacker@evil.com             ← 追加された偽ヘッダ ⚠️
From: legitimate@example.com        ← 署名済み(2番目)
Subject: 正規のメール
```

DKIMの検証は「最も新しい From」を使うので、**署名済みの2番目の From で検証が通ってしまいます**。一方、MUAが表示するのは**最初の From**、つまり攻撃者のアドレスです。署名は valid なのに表示は偽者、という状態になります。

### Oversigning がこれを防ぐ仕組み

`OversignHeaders From` を設定すると、`h=` に `from` が**2回**書かれます:

```
DKIM-Signature: h=from:from:subject:...
```

検証時に `from` を2回消費しようとしますが、**正規のメールには From が1つしかない**ので:

- 1回目:`From: legitimate@example.com` を消費 ✅
- 2回目:**存在しない From を「空」として署名に含める** ✅

この「空の From も署名に含まれている」ことがポイントです。

攻撃者が偽の From を追加すると:

- 1回目:`From: attacker@evil.com`(追加された偽物)を消費
- 2回目:`From: legitimate@example.com` を消費
- **「空の From」がなくなるので署名が壊れる** → 検証失敗 ❌

### まとめると

```
通常署名     h=from:      → 「From が1つ存在すること」を保証
Oversigning  h=from:from: → 「From がちょうど1つであること」を保証
```

Oversigning は**ヘッダの存在だけでなく、個数まで署名で縛る**というテクニックです。`From` のなりすましは最も危険なので、少なくとも `From` だけでも Oversigning しておくことが推奨されます。

### もっと Oversigning したほうがいいのでは?

Oversigning が安全なのは、**送信時に1つだけ存在することが確定していて、中継で追加されないヘッダに限られます**。

「正当に複数存在しうるヘッダ」に追加してはダメ。(例: `Received:`)

`From` が最優先で、余裕があれば `Subject` と `Reply-To` を加えるのが費用対効果の高い選択です。`To` や `Message-Id` はケースバイケースで判断してください。

```conf
# 最低ライン
OversignHeaders From

# 推奨
OversignHeaders From,Subject,Reply-To

# ケースバイケース
OversignHeaders From,Subject,Message-Id,Reply-To,To
```
