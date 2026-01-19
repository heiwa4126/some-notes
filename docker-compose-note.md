# docker compose メモ

## チュートリアル

- [Quickstart | Docker Docs](https://docs.docker.com/compose/gettingstarted/)
- 日本語。ちょっと古い。watch が無い。[クイックスタート | Docker ドキュメント](https://docs.docker.com/compose/gettingstarted/)

## .env

`docker compose` はデフォルトで `.env` ファイルを読み込む。

1. **`.env` は `compose.yml`（または `docker-compose.yaml`）と同じディレクトリに配置すること**
2. `.env` ファイルの内容は `compose.yml` 内の `${VAR_NAME}` 形式の変数として展開される
3. `.env` 内の変数は `environment` セクションの環境変数や `build.args` などで利用できる
4. **環境変数の優先順位**:

   - `compose` 実行時のシステム環境変数
   - `.env` ファイルの変数

もしシステム環境変数と `.env` の変数名が被っている場合、**システム環境変数が優先される**

## `docker compose up` は compose.yml の変更のみチェックする

compose.yml と compose.yml で include している yml のみ見る。

ソースコードなんかを変更したときは

```sh
docker compose up --build
```

で。

## `docker compose down` と `docker compose stop` の違い

1. コンテナの扱い:

   - `stop`はコンテナを停止するだけで、削除しません
   - `down`はコンテナを停止し、さらに削除も行います

2. リソースの削除:

   - `stop`はコンテナ以外のリソース（ネットワーク、ボリューム、イメージ）を削除しません
   - `down`はコンテナに加えて、ネットワーク、ボリューム、イメージも削除します

3. 再起動方法:

   - `stop`で停止したコンテナは`docker compose start`で再起動できます
   - `down`で停止・削除したコンテナは`docker compose up`で再作成する必要があります

4. 設定の反映:

   - `stop`は停止するだけなので、再開時に`docker-compose.yml`の変更が反映されません
   - `down`は環境を完全に削除するため、再作成時に最新の設定が反映されます[1]。

5. 使用シーン:
   - `stop`は一時的な停止や、起動に時間がかかる環境で使用されることがあります
   - `down`は環境を完全にクリーンアップしたい場合や、設定変更を確実に反映させたい場合に使用します

`docker compose stop` の使いどころは...
開発中にサービスを一時停止してリソースを節約したい場合、
ぐらい?

一般的には、`docker compose down` を使用する運用の方が推奨

### `docker compose stop` のあとに `up` だと...

`docker compose start` と同じ動作になるらしい。

## compose.yml 以外を使う

`-f` オプションか環境変数 COMPOSE_FILE で。

- `-f`や COMPOSE_FILE は `down` にも必要
- `-f`や COMPOSE_FILE には複数定義ファイルが書ける(順番は重要)
