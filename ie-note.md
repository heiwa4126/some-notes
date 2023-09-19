Internet Explorer (IE)のメモ。

- [ローカル イントラネットゾーンはどう決まるのか](#%E3%83%AD%E3%83%BC%E3%82%AB%E3%83%AB-%E3%82%A4%E3%83%B3%E3%83%88%E3%83%A9%E3%83%8D%E3%83%83%E3%83%88%E3%82%BE%E3%83%BC%E3%83%B3%E3%81%AF%E3%81%A9%E3%81%86%E6%B1%BA%E3%81%BE%E3%82%8B%E3%81%AE%E3%81%8B)
  - [参考](#%E5%8F%82%E8%80%83)

# ローカル イントラネットゾーンはどう決まるのか

> 信頼済みサイトや制限付きサイトゾーンと同様、"ローカル イントラネットゾーン" に明示的に追加されているサイトは、問答無用でローカル イントラネットゾーンと判定されます。

[IE のセキュリティ ゾーンについて – Japan IE Support Team Blog](https://blogs.technet.microsoft.com/jpieblog/2016/05/27/ie-securityzone/)

そうでない場合のフローチャートは
https://msdnshared.blob.core.windows.net/media/2018/03/IESecurityZone.pdf

(MSはよく消えるので、用心のため[ローカルコピー](./imgs/IESecurityZone.pdf))

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

なんとなく「イントラネットのネットワークを自動的に検出する」をOFFにすれば
ほかのオプションも無効になるように見えるところが恐ろしい。

[前述のフローチャート](https://msdnshared.blob.core.windows.net/media/2018/03/IESecurityZone.pdf)
を熟読すること。

フローチャートの途中で出てくる「クライアント」はWWWサーバのことらしい。
(例:「クライアントがドメインネットワーク上に存在する」)

フローチャートの途中で出てくるNLA(Network Location Awareness)が難しい。
[ASCII.jp：Windowsでネットワークの状況を識別するNetwork Location Awarenessとネットワークプロファイル｜Windows Info](http://ascii.jp/elem/000/001/734/1734489/)で「管理されている(managed)」なものがイントラネットになる。

## 参考

- [IE のセキュリティ ゾーンについて – Japan IE Support Team Blog](https://blogs.technet.microsoft.com/jpieblog/2016/05/27/ie-securityzone/)
- [Internet Explorer のセキュリティ ゾーン | Hebikuzure's Tech Memo](https://hebikuzure.wordpress.com/2013/12/24/internet-explorer-%E3%81%AE%E3%82%BB%E3%82%AD%E3%83%A5%E3%83%AA%E3%83%86%E3%82%A3-%E3%82%BE%E3%83%BC%E3%83%B3/)
