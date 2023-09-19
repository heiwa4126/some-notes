# Internet Explorer (IE)のメモ。

- [Internet Explorer (IE)のメモ。](#internet-explorer-ieのメモ)
  - [ローカル イントラネットゾーンはどう決まるのか](#ローカル-イントラネットゾーンはどう決まるのか)
    - [参考](#参考)

## ローカル イントラネットゾーンはどう決まるのか

> 信頼済みサイトや制限付きサイトゾーンと同様、"ローカル イントラネットゾーン" に明示的に追加されているサイトは、問答無用でローカル イントラネットゾーンと判定されます。

[IE のセキュリティ ゾーンについて – Japan IE Support Team Blog](https://blogs.technet.microsoft.com/jpieblog/2016/05/27/ie-securityzone/)

そうでない場合のフローチャートは
https://msdnshared.blob.core.windows.net/media/2018/03/IESecurityZone.pdf

(MS はよく消えるので、用心のため[ローカルコピー](./imgs/IESecurityZone.pdf))

ここで出てくる

- イントラネットのネットワークを自動的に検出する
  - ほかのゾーンに指定されていないローカル(イントラネット)のサイトをすべて含める
  - プロキシサーバーを使用しないサイトをすべて含める
  - すべてのネットワークパス(UNC) を含める

は、これ
![ローカルイントラネット](imgs/ie-opt-local.png 'ローカルイントラネット')

これは、

1. [インターネット オプション] を開き、[セキュリティ] タブを表示します
2. [ローカル イントラネット] アイコンをクリックし、[サイト] ボタンをクリックします。
   ![インターネット オプション](imgs/ie-opt.png 'インターネット オプション')

で、表示する。

なんとなく「イントラネットのネットワークを自動的に検出する」を OFF にすれば
ほかのオプションも無効になるように見えるところが恐ろしい。

[前述のフローチャート](https://msdnshared.blob.core.windows.net/media/2018/03/IESecurityZone.pdf)
を熟読すること。

フローチャートの途中で出てくる「クライアント」は WWW サーバのことらしい。
(例:「クライアントがドメインネットワーク上に存在する」)

フローチャートの途中で出てくる NLA(Network Location Awareness)が難しい。
[ASCII.jp：Windows でネットワークの状況を識別する Network Location Awareness とネットワークプロファイル｜ Windows Info](http://ascii.jp/elem/000/001/734/1734489/)で「管理されている(managed)」なものがイントラネットになる。

### 参考

- [IE のセキュリティ ゾーンについて – Japan IE Support Team Blog](https://blogs.technet.microsoft.com/jpieblog/2016/05/27/ie-securityzone/)
- [Internet Explorer のセキュリティ ゾーン | Hebikuzure's Tech Memo](https://hebikuzure.wordpress.com/2013/12/24/internet-explorer-%E3%81%AE%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3-%E3%82%BE%E3%83%BC%E3%83%B3/)
