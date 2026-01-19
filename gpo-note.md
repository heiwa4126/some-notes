Ansible で LGPO をいじる話

# GPOとは

よくわからん。
15 年前の記事だけど
[第1回　システム設定とシステム・ポリシー：グループ・ポリシーのしくみ（1/4 ページ） - ＠IT](https://www.atmarkit.co.jp/ait/articles/0601/31/news107.html) を読む。

ユーザがログインする直前に
レジストリを変更する仕組みらしい。

Windows のログインが遅いのはこいつのせい。

優先度(上の方ほど低い):

1. ローカル・コンピュータのポリシー
1. Active Directory のサイトのポリシー
1. Active Directory のドメインのポリシー
1. Active Directory の親の OU のポリシー(先祖から順に)
1. Active Directory の自分の OU のポリシー

「ローカル・コンピュータのポリシー」のみホスト全体。
ほかはドメインユーザ単位。
(ローカルユーザはどうなるんでしょうか? LGPO のみ?)

ポリシーは
AD 環境だったら AD でやるのが基本。
(AD で LGPO は意味がないわけではないけど、優先度が低いことを忘れない)

# LGPO(とローカルセキュリティポリシー)

- gpedit.msc - ローカルグループポリシー(LGPO)をいじる GUI
- secpol.msc - ローカルセキュリティポリシーをいじる GUI

なんで 2 本立てになってるのかよくわからん。
ローカルセキュリティポリシーは LSP とは言わないみたい。

(LGPO でなく)ローカルセキュリティポリシーを適応する手順:

1. secpol.msc でポリシーを設定する
2. secpol で「ポリシーのエクスポート」をする(secedit.exe でエクスポートもできる)
3. secedit.exe でエクスポートしたポリシーを他所に設定

gpedit.msc には「ポリシーのエクスポート」がない。
secedit.exe に当たるものもない。自動化できない。

というところで `lgpo.exe`

- [Microsoft Security Compliance Toolkit 1.0 - Windows security | Microsoft Docs](https://docs.microsoft.com/ja-jp/windows/security/threat-protection/security-compliance-toolkit-10)
- [LGPO.exe - Local Group Policy Object Utility, v1.0 - Microsoft Tech Community](https://techcommunity.microsoft.com/t5/microsoft-security-baselines/lgpo-exe-local-group-policy-object-utility-v1-0/ba-p/701045)
- [Download Microsoft Security Compliance Toolkit 1.0 from Official Microsoft Download Center](https://www.microsoft.com/en-us/download/details.aspx?id=55319) - lgpo.zip がダウンロードできる

実はこういうのもあるので要調査
[Florian's Blog » How can I export local Group Policy settings made in gpedit.msc?](http://www.frickelsoft.net/blog/?p=31)

LGPO もローカルグループポリシーと同様の手順でいける(はず、これから試す)。
ポリシーの設定は secedit.exe でできるらしい(試す)。

おおまかな手順:

1. LGPO を保存するフォルダを作る(`C:\gpo-backup`とする)
2. gpo をなにも設定しない段階でバックアップとっとく。`lgpo /b C:\gpo-backup`
3. `C:\gpo-backup\{uuid}`にバックアップができる。
4. `gpedit.msc`でグループポリシーを編集する。
5. `lgpo /b C:\gpo-backup`でエクスポート。`C:\gpo-backup\{uuid2}`ができたとする。
6. ↑1 個上でできたフォルダ`C:\gpo-backup\{uuid2}`を、対象ホストにコピーもっていく。
7. `C:\tmp\{uuid2}`にコピーしたとして、`lgpo /g C:\tmp\{uuid2}`でインポートする。

インポート時には部分階層的にインポート、とかできるらしい。

レジストリみたいに「この項目をこの値に設定したい」というのはできない。
ただ pol ファイルを人間に読みやすく parse するのはできる。
lgpo.exe 添付の pdf 読むこと。

ほか気づいた点:
「未構成」をインポートはできないみたい(そもそもエクスポートされない)。
