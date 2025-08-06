# ICU (International Components for Unicode) のメモ

さいしょは PostgreSQL の collation で調べ始めたんだけど、面白くなってきたのでメモ。

- [International Components for Unicode - Wikipedia](https://ja.wikipedia.org/wiki/International_Components_for_Unicode)
- [ICU - International Components for Unicode](https://icu.unicode.org/)
- [ICU Documentation | ICU is a mature, widely used set of C/C++ and Java libraries providing Unicode and Globalization support for software applications. The ICU User Guide provides documentation on how to use ICU.](https://unicode-org.github.io/icu/)
- [unicode-org/icu: The home of the ICU project source code.](https://github.com/unicode-org/icu)

Ubuntu だと

- libicu70 (70 のとこはバージョンで変わる)
- libicu-dev
- icu-devtools

バインディングが

- [pyicu · PyPI](https://pypi.org/project/pyicu/) - 上の `libicu-dev` が必要
- (Node 調べ中)

## PostgreSQL v18

`deterministic = false` (nondeterministic) のコレーション(非決定性コレーション)が
LIKE 演算子で使えるようになった。

- [PostgreSQL: Support LIKE with nondeterministic collations](https://www.postgresql.org/message-id/700d2e86-bf75-4607-9cf2-f5b7802f6e88%40eisentraut.org)
- [Waiting for PostgreSQL 18 – Support LIKE with nondeterministic collations – select \* from depesz;](https://www.depesz.com/2025/01/10/waiting-for-postgresql-18-support-like-with-nondeterministic-collations/)
- [git.postgresql.org Git - postgresql.git/commitdiff](https://git.postgresql.org/gitweb/?p=postgresql.git;a=commitdiff;h=85b7efa1cdd63c2fe2b70b725b8285743ee5787f)

ただし:

- ILIKE については、非決定性コレーション時の動作仕様が明確でないため、対応未定義/未対象とされており、v18 パッチでは対象外
- LIKE に非決定性コレーションを使うと、optimize の処理が制限され、従来よりパターンマッチの文字単位ではなく部分文字列単位での処理となるため、インデックスの効率利用が難しくなる可能性がある。インデックス戦略やパフォーマンスにはさらに注意が必要

### 「非決定性コレーション」とは?

同じ文字列でも複数の表現を同一視するようなコレーションのこと。

### 非決定性コレーションサンプル

**※ 以下の例で kf-upper は ks-level1 で上書きされるので意味が無いです**

```sql
CREATE COLLATION japanese_hiragana_katakana_equal (
    provider = icu,
    locale = 'ja-JP-u-kf-upper-ks-level1',
    deterministic = false
);
SELECT 'ば'='ハ' COLLATE japanese_hiragana_katakana_equal;
-- t になるはず

create table names (name text collate japanese_hiragana_katakana_ignore not null);
insert into names values('りんご');
insert into names values('リンゴ');
select * from names where name='りんご';
-- 両方とも出るはず
```

ここまでは v13 ~ v17 でも OK。

```sql
select * from names where name like '%ん%';
-- v18以前は "ERROR: nondeterministic collations are not supported for LIKE"になる
-- v18なら2つとも出る
```

### LDML (Locale Data Markup Language)

`ja-JP-u-kf-upper-ks-level1` の詳細

- `ja-JP` - 言語:日本(ja)、地域:日本(JP)
- `u` - Unicode ロケール拡張を開始するマーカー
- `kf-upper` - 大文字・小文字の優先順位(kf)、大文字優先(upper)
- `ks-level1` - 比較の厳しさ(ks)、レベル 1: 基本文字のみ比較(濁点・アクセント・大文字小文字は無視)。**Collation Strength(ks)のレベルは高いほど比較が厳密**

で、kf-upper は ks-level1 で上書きされるので意味が無いです。

kf とか ks は
[Unicode Locale Data Markup Language (LDML) Part 5](https://unicode.org/reports/tr35/tr35-collation.html)
で定義されている。
このなかの
[Table: Collation Settings](https://unicode.org/reports/tr35/tr35-collation.html#table-collation-settings)
がわかりやすい。

libicu の
[Collation | ICU Documentation](https://unicode-org.github.io/icu/userguide/collation/)も参照。

全体の構成や、`ja-JP-u-` は BCP47 言語タグを参照。

- [ロケール識別子(BCP47)と Unicode 拡張について(#2)](https://zenn.dev/sajikix/articles/intl-advent-calendar-24-02)
- [RFC 6067 - BCP 47 Extension U](https://datatracker.ietf.org/doc/html/rfc6067)

正直細かすぎてよくわからん。

### ソート順

PostgreSQL では
`ja-JP-u-ks-level1` で抽出して
`ja-JP-u-ks-level3` でソート
とかできるらしい。

つまり level1 だと

- TOKYO
- Tokyo
- tokyo

は全部等しいので、ソート順が不定になる。けど LIKE '%TOKYO%' では全部抽出したい、みたいな時。

こんなノリらしい

```sql
-- チェックしてません。あと CRAETE COLLATON が抜けてる
SELECT *
FROM users
WHERE name = 'tokyo' COLLATE "ja-JP-u-kf-upper-ks-level1"  -- 大文字小文字無視
ORDER BY name COLLATE "ja-JP-u-kf-upper-ks-level3";       -- 大文字小文字を考慮してソート
```

`CREATE INDEX`でも COLLATE 指定できるらしい。
テーブルでカラムに指定した方が楽なんじゃないかな、とは思いますが。

### ICU の Collation Strength レベル

| レベル        | 名前       | 区別するもの                                       | 用途                                     |
| ------------- | ---------- | -------------------------------------------------- | ---------------------------------------- |
| **Level 1**   | Primary    | 基本文字のみ(濁点・アクセント・大文字小文字を無視) | 言語的に大まかな一致(例:検索やソート)    |
| **Level 2**   | Secondary  | アクセント・濁点などを区別(ケースは無視)           | アクセントを考慮する必要がある場合       |
| **Level 3**   | Tertiary   | 大文字小文字も区別                                 | 厳密な比較(ひらがなカタカナ同一視は維持) |
| **Level 4**   | Quaternary | 記号や句読点も区別                                 | 完全一致に近い比較                       |
| **Identical** | Identical  | 文字コードレベルまで完全一致                       | バイナリ同等                             |

#### レベルが上がるとこう変わる

- Level 1:
  `ひらがな == カタカナ`、`A == a`、`か == が`
- Level 2:
  `ひらがな == カタカナ`、`A == a`、`か != が`
- Level 3:
  `ひらがな == カタカナ`、`A != a`、`か != が`
- Level 4:
  上記に加えて `A != a.`(記号の違いも別扱い)

## collation のリスト

こんなノリで

```sql
SELECT collname, collprovider, collisdeterministic, collcollate
FROM pg_collation where collname = 'ja-x-icu';
```

collcollate が None の場合、そのままでは使えないので `

## 日本の法人名に emoji は使えますか?
