Proxy Auto-Configuration (PAC)のメモ。

- [概要とリファレンス](#概要とリファレンス)
- [テストツール](#テストツール)
- [tips](#tips)

# 概要とリファレンス

- [プロキシ自動設定 - Wikipedia](https://ja.wikipedia.org/wiki/%E3%83%97%E3%83%AD%E3%82%AD%E3%82%B7%E8%87%AA%E5%8B%95%E8%A8%AD%E5%AE%9A)
- [プロキシ自動設定ファイル - HTTP | MDN](https://developer.mozilla.org/ja/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file)
- [Proxy auto-config - Wikipedia](https://en.wikipedia.org/wiki/Proxy_auto-config)

- [Proxy Auto-Configuration (PAC) file - HTTP | MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Proxy_servers_and_tunneling/Proxy_Auto-Configuration_(PAC)_file)
- [Automatic Discovery for Firewall and Web Proxy Clients | Microsoft Docs](https://docs.microsoft.com/en-us/previous-versions/tn-archive/cc713344(v=technet.10))

# テストツール

テストツールpacktesterがある。Ubuntuだとパッケージになっているので楽

```
apt-get install libpacparser1
```

- [manugarg/pactester: Automatically exported from code.google.com/p/pactester](https://github.com/manugarg/pactester)
- [Writing and testing proxy auto-configuration (PAC) files - ThousandEyes Customer Success Center](https://success.thousandeyes.com/PublicArticlePage?articleIdParam=kA044000000LBBmCAO)
- [man pactester (1): Tool to test proxy auto-config (pac) files.](http://manpages.org/pactester)

テストはこんな感じ

```
$ pactester -p ./proxy.pac -u http://www.yahoo.co.jp/test.html
PROXY 111.222.333.444:8080
```

# tips

- Windows10以降ではfile://のpacが使えないのでWWWサーバを立てること
  - [Windows 10では、ファイル プロトコルによって参照される PAC ファイルが読み取られない](https://support.microsoft.com/ja-jp/help/4025058/windows-10-does-not-read-a-pac-file-referenced-by-a-file-protocol)
  - [[自動構成スクリプトを使用する] に file:// で .pac ファイルを指定しているのに参照されず、Outlook からの接続が失敗する – Outlook Support Team Blog JAPAN](https://blogs.technet.microsoft.com/outlooksupportjp/2014/09/09/file-pac-2345/)
- .pacのMIMEタイプは設定したほうがいい。2つあるけど
  `application/x-ns-proxy-autoconfig`
  のほうがおすすめ。
