AnsibleでLGPOをいじる話

# GPOとは

よくわからん。
15年前の記事だけど
[第1回　システム設定とシステム・ポリシー：グループ・ポリシーのしくみ（1/4 ページ） - ＠IT](https://www.atmarkit.co.jp/ait/articles/0601/31/news107.html) を読む。

ユーザがログインする直前に
レジストリを変更する仕組みらしい。

Windowsのログインが遅いのはこいつのせい。

優先度(上の方ほど低い):
1. ローカル・コンピュータのポリシー
1. Active Directoryのサイトのポリシー
1. Active Directoryのドメインのポリシー
1. Active Directoryの親のOUのポリシー(先祖から順に)
1. Active Directoryの自分のOUのポリシー

「ローカル・コンピュータのポリシー」のみホスト全体。
ほかはドメインユーザ単位。
(ローカルユーザはどうなるんでしょうか? LGPOのみ?)

ポリシーは
AD環境だったらADでやるのが基本。
(ADでLGPOは意味がないわけではないけど、優先度が低いことを忘れない)


# LGPO(とローカルセキュリティポリシー)

- gpedit.msc - ローカルグループポリシーをいじるGUI
- secpol.msc - ローカルセキュリティポリシーをいじるGUI

(ローカルセキュリティポリシーはLSPとは言わないみたい)

ローカルグループポリシーを適応する手順
1. secpol.mscでポリシーを設定する
2. secpolで「ポリシーのエクスポート」をする(secedit.exeでエクスポートもできる)
3. secedit.exe でエクスポートしたポリシーを他所に設定

gpedit.mscには「ポリシーのエクスポート」がない。
secedit.exeに当たるものもない。自動化できない。

というわけで `lgpo.exe`
- [Microsoft Security Compliance Toolkit 1.0 - Windows security | Microsoft Docs](https://docs.microsoft.com/ja-jp/windows/security/threat-protection/security-compliance-toolkit-10)
- [LGPO.exe - Local Group Policy Object Utility, v1.0 - Microsoft Tech Community](https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045)
- [Download Microsoft Security Compliance Toolkit 1.0 from Official Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=55319) - lgpo.zipがダウンロードできる

実はこういうのもあるので参照
[Florian's Blog » How can I export local Group Policy settings made in gpedit.msc?](http://www.frickelsoft.net/blog/?p=31)

LGPOもローカルグループポリシーと同様の手順でいける(はず、これから試す)。
ポリシーの設定はsecedit.exeでできるらしい(試す)。

おおまかな手順:

1. LGPOを保存するフォルダを作る(`C:\gpo-backup`とする)
2. gpoをなにも設定しない段階でバックアップとっとく。`lgpo /b C:\gpo-backup`
3. `C:\gpo-backup\{uuid}`にバックアップができる。
4. `gpedit.msc`でグループポリシーを編集する。
5. `lgpo /b C:\gpo-backup`でエクスポート。`C:\gpo-backup\{uuid2}`ができたとする。
6. ↑1個上でできたフォルダ`C:\gpo-backup\{uuid2}`を、対象ホストにコピーもっていく。
7. `C:\tmp\{uuid2}`にコピーしたとして、`lgpo /g C:\tmp\{uuid2}`でインポートする。

インポート時には部分階層的にインポート、とかできるらしい。