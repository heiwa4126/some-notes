Windowsのメモ
- [Windows serverでRC4とtriple-DESを無効にする](#windows-server%E3%81%A7rc4%E3%81%A8triple-des%E3%82%92%E7%84%A1%E5%8A%B9%E3%81%AB%E3%81%99%E3%82%8B)
- [参考](#%E5%8F%82%E8%80%83)


# Windows serverでRC4とtriple-DESを無効にする

参考:
* [Managing SSL/TLS Protocols and Cipher Suites for AD FS](https://docs.microsoft.com/windows-server/identity/ad-fs/operations/manage-ssl-protocols-in-ad-fs)
* [How to disable RC4 and 3DES on Windows Server?](https://www.tbs-certificates.co.uk/FAQ/en/desactiver_rc4_windows.html)
* [Exchange TLS & SSL Best Practices](https://blogs.technet.microsoft.com/exchange/2015/07/27/exchange-tls-ssl-best-practices/)
* [How to disable SSLv3 and RC4 ciphers in IIS](https://samrueby.com/2015/06/08/how-to-disable-sslv3-and-rc4-ciphers-in-iis/)
* [How to Diable RC4 is Windows 2012 R2](https://social.technet.microsoft.com/Forums/en-US/faad7dd2-19d5-4ba0-bd3a-fc724d234d7b/how-to-diable-rc4-is-windows-2012-r2?forum=winservergen)
* [FREAK 対策を行う](https://www.agilegroup.co.jp/technote/freak-check.html)

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

* [Windowsのdirコマンドでファイル名の一覧を取得する](https://www.atmarkit.co.jp/ait/articles/0412/04/news014.html)
  - 意外と知らないことが書いてあってびっくり。clipとかdir /a-dとか