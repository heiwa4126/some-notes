- [links](#links)
- [random note](#random-note)

# links

* [Cntlm: Fast NTLM Authentication Proxy in C](http://cntlm.sourceforge.net/)
* [Cntlm Authentication Proxy - Browse /cntlm/cntlm 0.92.3 at SourceForge.net](https://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.92.3/)
* [CNTLMの導入とトラブルシューティング - サイト管理者のよんよん日記](http://yonyon-blog.net/youmei/2014/06/27/cntlm%E3%81%AE%E5%B0%8E%E5%85%A5%E3%81%A8%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0/) - Windows系
* [[Windows]Forefront TMGのNTLM認証プロキシをCntlmでなんとかする – エンジニ屋](https://sevenb.jp/wordpress/ura/2016/01/27/windowsforefront-tmg%E3%81%AEntlm%E8%AA%8D%E8%A8%BC%E3%83%97%E3%83%AD%E3%82%AD%E3%82%B7%E3%82%92cntlm%E3%81%A7%E3%81%AA%E3%82%93%E3%81%A8%E3%81%8B%E3%81%99%E3%82%8B/)
* [Cntlmを使ってNTLMv2認証Proxy環境をやっつける - Qiita](https://qiita.com/yohskeey/items/6f17ea051fbe5568f3bf) - Linux系

* [cntlm(1) - Linux man page](https://linux.die.net/man/1/cntlm)

Red Hat系はEPELにパッケージがある。
Ubuntuは普通にパッケージがある。


# random note 

Windows

1. [Cntlm Authentication Proxy - Browse /cntlm/cntlm 0.92.3 at SourceForge.net](https://sourceforge.net/projects/cntlm/files/cntlm/cntlm%200.92.3/)
から `cntlm-0.92.3-setup.exe` を取得 & 実行
2. xxxxにある設定ファイル `cntlm.ini` を
添付のcntlm.ini で上書きする。
3. スタート→コントロールパネル→管理ツール→サービス→Cntlm Authentication Proxy で右クリック→開始 
4. 同様に 右クリック→全般タブ→スタートアップの種類→自動→OK
    - TODO: 3.4.の手順をスクリプトにする
5. pac

xxxxは
C:\Program Files\Cntlm
C:\Program Files(x86)\Cntlm