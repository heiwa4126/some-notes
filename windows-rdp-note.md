# Windows の RDP のメモ

「驚き最小原則」に反することばかり。

## Windows のリモートデスクトップ接続(.rdp)ファイルで接続の資格を保存する時、資格情報は rdp ファイルを別にしてもホスト名単位で 1 個しか保存されない?

はい。

例えば Windows ホスト A に対して user1-a.rdp と user2-a.rdp をつくり、
資格情報を設定すると、後から保存した資格で上書きされます。

1. Windows ホスト A に接続する user1-a.rdp を作成し、user1 の資格情報を保存する
1. 次に user2-a.rdp を作成し、user2 の資格情報を保存する
1. この時点で、ホスト A への接続時に使用される資格情報は user2 のものとなり、user1 の資格情報は上書きされている
1. このように、同一ホストに対しては最後に保存した資格情報が有効になり、以前保存していた資格情報は上書きされてしまいます。

この仕様は、1 つのホストに対して複数の異なる資格情報を管理できないという、Windows のリモートデスクトップの制限によるものです。

**あいかわらず Windows 最低だな。**

DNS に複数 A レコード登録する、などで回避できるけど、それ証明書からむと積むよね...

## Domain Admins グループでない AD ユーザで AD 配下のホストに RDP したい

Domain Admins グループにしてしまうのが一番簡単なんだけど、
それはセキュリティレベル下がりまくりなので調べてみました。

手順:

1. DC で「ビルドインでない AD 管理のセキュリティグループ」を ADUC(dsa.msc) > DOMAIN 名 > users に作り、該当のユーザをグループに追加する。グループにしないで、2. 3.で直接 AD のユーザを追加してもいいが、グループを挟むと DC だけでユーザを RDP 接続不可にできる。
2. RDP する先の AD 配下のホストに Domain Admins のユーザで入って、ローカルポリシー(secpol.msc) の
   Local Policies > User Right Assignment > Allow logon through Remote Desktop Services に 1. で作ったセキュリティグループを追加する。**ただし**すでにローカルの Remote Desktop Users(RDU) グループがエントリにあったら、1. で作ったセキュリティグループを追加する必要はない。RDU がデフォルトでエントリに追加されているかどうかは Windows のバージョンによって違う。
3. さらに 2.と同じホスト&アカウントで Win+x > System > Remote Desktop > Select users that can remotely access this PC で 1. で作ったセキュリティグループを追加する。これはローカルの Buildin グループ Remote Desktop Users(RDU) に 1.のグループをメンバとして追加するのと同じ効果がある。けれど、他になにかやってる可能性もあるのでこの手順でやってください。

注意:

- ファイアウォールの設定等は飛ばしてあります。前提としてローカル Administorator で RDP できればだいたい大丈夫
- DC 自体でも上記 1.2.3.の設定は必要
- これがベストプラクティスかどうかは不明。グループポリシーつかえばもう少しなんとか

参考:

- [Remote Desktop clients FAQ | Microsoft Learn](https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-client-faq)
- [一般的なリモート デスクトップ接続のトラブルシューティング - Windows Server | Microsoft Learn](https://learn.microsoft.com/ja-jp/troubleshoot/windows-server/remote/rdp-error-general-troubleshooting)

以下は上記手順を実行する Powershell によるコード。
**Claude に作ってもらった。テストしてません。**
(流れ確認用)

```powershell
# ADモジュールのロード
Import-Module ActiveDirectory

# 新しいADグループの作成
$groupName = "RDP_Users"
$groupDesc = "Users allowed for Remote Desktop"
New-ADGroup -Name $groupName -GroupScope Global -GroupCategory Security -Description $groupDesc

# ユーザーをグループに追加する (例: user1, user2)
Add-ADGroupMember -Identity $groupName -Members user1,user2

# ターゲットホストに対してリモートデスクトップ権限を設定
$targetHost = "HostName"
$credential = Get-Credential -Message "Enter Domain Admin credentials"

# リモートデスクトップログオン権限の設定
$constant = [System.Security.Principal.SecurityEntityModifierExtensions]
$sid = (Get-ADGroup -Identity $groupName).SID.Value
$newAccess = $constant::UserLogonRight_LogOn_Remotely
$policy = "Local Policy\User Rights Assignment\Allow log on through Remote Desktop Services"
Invoke-Command -ComputerName $targetHost -Credential $credential -ScriptBlock {
    $group = $Using:sid
    $rights = $Using:newAccess
    $item = $Using:policy
    $tmp = ([System.Security.Principal.SecurityEntityModifierExtensions]::ToString($rights)).Trim()
    $tmp += ",*"
    $currentRights = (Get-GPRegistryValue -Name $item -Key HKLM\SYSTEM\CurrentControlSet\Control\Lsa).ToString()
    if($currentRights -notlike "*$group*") {
        $newRights = $currentRights.Trim(",") + "," + $tmp
        Set-GPRegistryValue -Name $item -Value $newRights -Key HKLM\SYSTEM\CurrentControlSet\Control\Lsa -TypeString
    }
}

# リモートデスクトップユーザーへのアクセス許可設定
Invoke-Command -ComputerName $targetHost -Credential $credential -ScriptBlock {
    $group = $Using:groupName
    $regPath = "HKLM:\System\CurrentControlSet\Control\Terminal Server"
    $valueName = "RemoteDesktopUsers"
    $item = Get-ItemProperty -Path $regPath -Name $valueName
    $values = $item.RemoteDesktopUsers.split(",").Trim()
    if($values -notcontains $Using:group) {
        $values += $Using:group
        $newValue = $values -join ","
        Set-ItemProperty -Path $regPath -Name $valueName -Value $newValue.Trim(",")
    }
}
```

## 「このリモート接続の発行元を識別できません。接続しますか?」 を無視オプション以外で解決する

これ接続するサーバが本物であるか確認するためで、サーバなりすましやメンインミドルとか避けるものですよね?
「このコンピューターへの接続について今後確認しない」は拙いと思うんですけど。

- [Windows でリモートデスクトップ接続のサーバに「正しい」証明書を割り当てる：Tech TIPS - ＠IT](https://atmarkit.itmedia.co.jp/ait/articles/1309/20/news036.html)
- [リモートデスクトップで利用される証明書はどこにあるのか？ – ラボラジアン](https://laboradian.com/where-is-remote-desktop-certificate/)
