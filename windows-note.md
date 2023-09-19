Windowsのメモ

- [Windows serverでRC4とtriple-DESを無効にする](#windows-serverでrc4とtriple-desを無効にする)
- [参考](#参考)
- [Windowsのサポート期限検索](#windowsのサポート期限検索)
- [Windows updateのproxy設定](#windows-updateのproxy設定)
- [Windowsのしつこいアニメーションを無くする](#windowsのしつこいアニメーションを無くする)
- [ms-settings:](#ms-settings)

# Windows serverでRC4とtriple-DESを無効にする

参考:

- [Managing SSL/TLS Protocols and Cipher Suites for AD FS](https://docs.microsoft.com/windows-server/identity/ad-fs/operations/manage-ssl-protocols-in-ad-fs)
- [How to disable RC4 and 3DES on Windows Server?](https://www.tbs-certificates.co.uk/FAQ/en/desactiver_rc4_windows.html)
- [Exchange TLS & SSL Best Practices](https://blogs.technet.microsoft.com/exchange/2015/07/27/exchange-tls-ssl-best-practices/)
- [How to disable SSLv3 and RC4 ciphers in IIS](https://samrueby.com/2015/06/08/how-to-disable-sslv3-and-rc4-ciphers-in-iis/)
- [How to Diable RC4 is Windows 2012 R2](https://social.technet.microsoft.com/Forums/en-US/faad7dd2-19d5-4ba0-bd3a-fc724d234d7b/how-to-diable-rc4-is-windows-2012-r2?forum=winservergen)
- [FREAK 対策を行う](https://www.agilegroup.co.jp/technote/freak-check.html)
- [マイクロソフト セキュリティ アドバイザリ 3009008 - SSL 3.0 の脆弱性により、情報漏えいが起こる](https://docs.microsoft.com/ja-jp/security-updates/securityadvisories/2015/3009008)

regeditを使って、以下の値を設定する。

```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128]
    "Enabled"=dword:00000000
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 40/128]
    "Enabled"=dword:00000000
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 56/128]
    "Enabled"=dword:00000000
HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\Triple DES 168/168]
    "Enabled"=dword:00000000
```

設定したらエクスポートして、他のホストで再利用する。

Powershellだとこんな感じ

```
$key = 'HKLM:\'
$sub = 'SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers'
@('RC4 128/128','RC4 40/128','RC4 56/128','Triple DES 168/168')|%{
    $p = $key + $sub + "\" + $_
    # New-Item $p1 # <- keyに'/'があると正しく動かないので以下の方法で回避
    $k = (get-item -path $key).OpenSubKey($sub, $true)
    $k.CreateSubKey($_)
    $k.Close()
    if( test-path $p ) { Remove-ItemProperty $p -Name Enabled }
    New-ItemProperty $p -Name Enabled -PropertyType DWord -Value 0 -Force | Out-Null
}
```

↑キーの作成に

```
([Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,$env:COMPUTERNAME)).CreateSubKey('SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Ciphers\RC4 128/128')
```

とする手もある。

# 参考

- [Windowsのdirコマンドでファイル名の一覧を取得する](https://www.atmarkit.co.jp/ait/articles/0412/04/news014.html) - 意外と知らないことが書いてあってびっくり。clipとかdir /a-dとか

# Windowsのサポート期限検索

これは便利。
[製品およびサービスのライフサイクル情報の検索 (プレビュー) | Microsoft Docs](https://docs.microsoft.com/ja-jp/lifecycle/products/)

# Windows updateのproxy設定

Windows 10 より前のOSではProxyの設定が必要だった。

管理者権限でcmd.exeひらいて

```
netsh winhttp show proxy
netsh winhttp import proxy source=ie
netsh winhttp set proxy proxy-server="192.168.1.2:10080" bypass-list="*.local"
netsh winhttp reset proxy
```

# Windowsのしつこいアニメーションを無くする

管理者権限で

```
REG ADD "HKEY_CURRENT_USER\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
```

ログアウト必要

参考:

- [Windows10のアニメーション無効化、レジストリ操作まで | GWT Center](https://www.gwtcenter.com/stop-win10-animation)
- [Windows 10 Disable Animations via regedit/script - Super User](https://superuser.com/questions/1052763/windows-10-disable-animations-via-regedit-script)
- [Windows animations (maximize, minimize) are gone.](https://social.technet.microsoft.com/Forums/en-US/4aa71ed5-3500-4d11-a461-7d80c0847f91/windows-animations-maximize-minimize-are-gone?forum=itprovistadesktopui)

# ms-settings:

便利。「設定開いて...」よりは全然楽

- [Windows 10のショートカット「ms-settings:URI」は使い始めると止められない：山市良のうぃんどうず日記（99）（2/2 ページ） - ＠IT](https://www.atmarkit.co.jp/ait/articles/1707/11/news009_2.html)
- [Launch the Windows Settings app - UWP applications | Microsoft Docs](https://docs.microsoft.com/en-us/windows/uwp/launch-resume/launch-settings-app#ms-settings-uri-scheme-reference)

`ms-windows-store:`とかもある。上記参照。
