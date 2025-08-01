# PostgreSQL を Docker で動かす

## Docker

[postgres - Official Image | Docker Hub](https://hub.docker.com/_/postgres)

これにある docker-compose.yml をそのまま使うとして

```yaml
# Use postgres/example user/password credentials
version: '3.1'

services:
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: example

  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```

こんな感じ

```console
$ docker compose up -d
$ docker compose exec db bash
# psql -U postgres
psql (15.3 (Debian 15.3-1.pgdg120+1))
Type "help" for help.

postgres=# \du
                                   List of roles
 Role name |                         Attributes                         | Member of
-----------+------------------------------------------------------------+-----------
 postgres  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}

postgres=# \q
```

とりあえず psql(と libpq)がイメージに入ってる。

あと上記の設定で [Adminer](https://www.adminer.org/) が <http://localhost:8080> で動くので

- データベース種類 - PostgreSQL
- サーバ - db
- パスワード - example
- データベース - postgre

で入れる。(ブラウザが「そのパスワードがデータ侵害で検出されました」とうるさい)

で、まあこれだと

- docker の外からつながらない
- DB が永続化されない

なので、docker-compose.yml をこんな風に

```yaml
version: '3.1'

services:
  db:
    image: postgres
    restart: always
    environment:
      POSTGRES_PASSWORD: example
    ports:
      - '35432:5432'
    volumes:
      - 'postgres_data:/var/lib/postgresql/data'

volumes:
  postgres_data:
    external: false
```

これで
`PGPASSWORD=example psql -U postgres -h 127.0.0.1 -p 35432 postgres`
で入れる。

別に世界に公開したくなければ

```yaml
ports:
  - '127.0.0.1:35432:5432'
```

にするなど。

停止は

```bash
docker compose down
# または
docker compose down -v  # ボリュームも消す
```

[docker compose down — Docker-docs-ja 20.10 ドキュメント](https://docs.docker.jp/engine/reference/commandline/compose_down.html)

## ロケール関連

最近のコンテナは ICU サポート付きでビルドされている。

```sql
CREATE DATABASE testdb WITH ENCODING 'UTF8' LC_COLLATE='ja_JP.UTF-8' LC_CTYPE='ja_JP.UTF-8';
```

が、ダメなときでも、

```sql
-- ICU確認
SELECT * FROM pg_collation WHERE collprovider = 'i' AND collname ILIKE '%ja%';
```

で
ja-x-icu や ja-JP-x-icu が出てくれば、
init.sql でこんな感じに書けば OK

```sql
CREATE DATABASE testdb
  WITH ENCODING = 'UTF8'
  LC_COLLATE = 'C'
  LC_CTYPE = 'C'
  TEMPLATE = template0;

\c testdb;

-- ICU 日本語コレーション(なければ作る)
CREATE COLLATION IF NOT EXISTS ja_icu (provider = icu, locale = 'ja-JP');

-- ja_icu を組み込んだ domain (エリアス) を定義
CREATE DOMAIN ja_text AS text COLLATE "ja_icu";

-- テーブルの作成
-- ここでは例として users テーブルを作成

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name ja_text NOT NULL,
    -- name text COLLATE "ja_icu" NOT NULL, でもいい。varchar(n) などに全部DOMAIN指定できないから
    email VARCHAR(100) UNIQUE NOT NULL
);

INSERT INTO users (name, email) VALUES ('長宗我部元親', 'test@example.com');

CREATE INDEX users_name_idx ON users (name);
CREATE INDEX users_email_idx ON users (email);
```

ただ ICU は glib ロケールベースよりやや遅いらしいので、
Docker でない本物 Postgres を使うときは glib にしたほうがいい。

Docker でも

```dockerfile
FROM postgres:17

# 日本語ロケールをインストール
RUN apt-get update && \
    apt-get install -y locales && \
    sed -i '/^#.* ja_JP.UTF-8 /s/^#//' /etc/locale.gen && \
    locale-gen
```

でいけるはず。

### コレーションの確認

上の例 users の例で:

まずカラム(users.name)は

```sql
SELECT a.attname AS column_name,
       CASE
         WHEN a.attcollation = 0 THEN 'default(' || current_setting('lc_collate') || ')'
         ELSE c.collname
       END AS collation
FROM pg_attribute a
JOIN pg_class t ON a.attrelid = t.oid
JOIN pg_namespace n ON t.relnamespace = n.oid
LEFT JOIN pg_collation c ON a.attcollation = c.oid
WHERE t.relname = 'users'
  AND a.attname = 'name'
  AND a.attnum > 0
  AND NOT a.attisdropped;
```

インデックス(users_name_idx)は、

```sql
SELECT i.relname AS index_name,
       array_agg(
         CASE
           WHEN col.collid = 0 THEN 'default(' || current_setting('lc_collate') || ')'
           ELSE c.collname
         END
         ORDER BY col.ordinality
       ) AS collations
FROM pg_index idx
JOIN pg_class i ON i.oid = idx.indexrelid
JOIN pg_class t ON t.oid = idx.indrelid
CROSS JOIN LATERAL unnest(idx.indcollation) WITH ORDINALITY AS col(collid, ordinality)
LEFT JOIN pg_collation c ON col.collid = c.oid
WHERE t.relname = 'users'
  AND i.relname = 'users_name_idx'
GROUP BY i.relname;
```
